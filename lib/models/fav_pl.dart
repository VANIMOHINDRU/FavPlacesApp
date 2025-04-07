import 'package:uuid/uuid.dart';
import 'dart:io';

const uuid = Uuid(); //generating a random id

class FavPl {
  FavPl(
      {required this.title,
      required this.image,
      required this.location,
      String? id})
      : id = id ?? uuid.v4(); //set manually or sys gen
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}

class PlaceLocation {
  PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});
  final double latitude;
  final double longitude;
  final String address;
}
