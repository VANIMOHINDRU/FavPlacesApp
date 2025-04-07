import 'package:fav_places_app/models/fav_pl.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//show an already existing place or a new place
class MapScreen extends StatefulWidget {
  MapScreen(
      {super.key,
      PlaceLocation? location,
      this.isSelecting = true}) //if no overwriting->opened to pick a new loc
      : location = location ??
            PlaceLocation(latitude: 37.422, longitude: -122.084, address: '');

  final PlaceLocation location;
  final bool isSelecting;
  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
          actions: [
            if (widget.isSelecting)
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  if (_pickedLocation == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select a location on the map')));
                    return;
                  }

                  Navigator.of(context).pop(_pickedLocation);
                },
              )
          ],
        ),
        body: GoogleMap(
            onTap: (postition) {
              print("Tapped location: $postition");
              setState(() {
                _pickedLocation = postition;
              });
            },
            initialCameraPosition: CameraPosition(
              //which part of map should be centered
              target:
                  LatLng(widget.location.latitude, widget.location.longitude),
              zoom: 16,
            ),
            markers: (_pickedLocation == null && widget.isSelecting)
                ? {}
                : {
                    Marker(
                        markerId: const MarkerId('m1'),
                        position: _pickedLocation != null
                            ? _pickedLocation!
                            : LatLng(widget.location.latitude,
                                widget.location.longitude))
                  } //set->no duplicates allowed
            ));
  }
}
