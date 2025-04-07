import 'dart:convert';

import 'package:fav_places_app/models/fav_pl.dart';
import 'package:fav_places_app/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(PlaceLocation location) onSelectLocation;
  @override
  State<StatefulWidget> createState() {
    return _LocationInput();
  }
}

class _LocationInput extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    //This getter allows you to access the value of locationImage from outside the class,always updated
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    final geoKey = dotenv.env['GOOGLE_MAPS_GEOCODING_KEY'];
    final imageUrl =
        'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$lat,$lng&key=$geoKey';
    print("Static Map URL: $imageUrl");
    return imageUrl; //gives image of picked location
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    print("MAPS_API_KEY: ${dotenv.env["MAPS_API_KEY"]}");
    final geoKey = dotenv.env['GOOGLE_MAPS_GEOCODING_KEY'];
    final url = Uri.parse(//reverse geocode
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$geoKey');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      _pickedLocation = PlaceLocation(
          latitude: latitude, longitude: longitude, address: address);
      print("Tapped location: $_pickedLocation");
      _isGettingLocation = false;
    }); //update ui
    widget.onSelectLocation(_pickedLocation!);
  }

  void _getCurrentLocation() async {
    //gives location data

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    }); //update ui

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context)
        .push<LatLng>(MaterialPageRoute(builder: (context) {
      return MapScreen();
    }));

    if (pickedLocation == null) {
      return;
    }
    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Text('Failed to load map preview');
        },
      );
    }
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
            height: 140,
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.3))),
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceEvenly, //adds even space around the items inside the row
          children: [
            TextButton.icon(
                icon: const Icon(Icons.location_on),
                onPressed: () {
                  _getCurrentLocation();
                },
                label: const Text('Get current location')),
            TextButton.icon(
                icon: const Icon(Icons.map),
                onPressed: _selectOnMap,
                label: const Text('Select on Map'))
          ],
        )
      ],
    );
  }
}
