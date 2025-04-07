import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fav_places_app/models/fav_pl.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;

Future<Database> _getDatabase() async {
  // _ ->only usable inside of this file
  final dbPath =
      await sql.getDatabasesPath(); //yield the path(directory) of db on device
  final db = await sql.openDatabase(
      path.join(
          dbPath, 'places.db'), //construct a path by specifying a database name
      onCreate: (db, version) {
    //when db is created for the first time
    return db.execute(//initial setup
        'CREATE TABLE User_places(id TEXT PRIMARY KEY, title TEXT, image TEXT,lat REAL,lng REAL, address TEXT)'); //REAL ->NUMBER WITH DECIMALS
  },
      version:
          1 //theoretically, increase this so that new db file is created whenever a query is changed
      ); //db is either open or created of name places.db
  return db;
}

class PlacesNotifier extends StateNotifier<List<FavPl>> {
  PlacesNotifier() : super(const []); //initializer list

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db
        .query('User_places'); //gets all the places, returns a list of maps
    final places = data.map(
      //maps each row in the data list to a new structure.
      (row) {
        return FavPl(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String));
      },
    ).toList();
    state = places; //updates the state
    //state = places replaces the entire state with a new list of favorite places,
  }

  void togglePlaces(FavPl fav) async {
    final appDir = await syspaths //through path_provider
        .getApplicationDocumentsDirectory(); //path name to store(since wihtout this, the path may differ for different os)
    final filename = path.basename(fav.image.path); //target file name
    final copiedImage = await fav.image.copy('${appDir.path}/$filename');
    final newPlace =
        FavPl(title: fav.title, image: copiedImage, location: fav.location);

    final db = await _getDatabase();
    db.insert('User_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address
    });
    state = [newPlace, ...state];
  } //new files will be created each time.
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<FavPl>>((ref) {
  return PlacesNotifier();
});

//By inserting the data into the database, you ensure that the favorite place is saved permanently.
//Immediate Feedback: By updating the state, you ensure that the new place is instantly 
//visible in the user interface. This is crucial for providing a responsive and user-friendly experience.
