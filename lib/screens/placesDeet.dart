import 'package:fav_places_app/models/fav_pl.dart';
import 'package:fav_places_app/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Placesdeet extends StatefulWidget {
  const Placesdeet({super.key, required this.fav});
  final FavPl fav;

  @override
  State<Placesdeet> createState() => _PlacesdeetState();
}

class _PlacesdeetState extends State<Placesdeet> {
  @override
  void initState() {
    super.initState();
  }

  String get locationImage {
    //This getter allows you to access the value of locationImage from outside the class.

    final lat = widget.fav.location.latitude;
    final lng = widget.fav.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$lat,$lng&key=${dotenv.env["MAPS_API_KEY"]}'; //gives image of picked location
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.fav.title),
        ),
        body: Stack(
          children: [
            Image.file(
              widget.fav.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return MapScreen(
                            location: widget.fav.location,
                            isSelecting: false,
                          );
                        }));
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(locationImage),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black54],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Text(widget.fav.location.address,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                    )
                  ],
                ))
          ],
        ));
  }
}
