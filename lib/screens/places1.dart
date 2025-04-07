//import 'package:fav_places_app/models/fav_pl.dart';
import 'package:fav_places_app/screens/places2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fav_places_app/provider/placesProvider.dart';
import 'package:fav_places_app/screens/placesDeet.dart';

class Places1 extends ConsumerStatefulWidget {
  const Places1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Places1State();
  }
}

class _Places1State extends ConsumerState<Places1> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = _load();
    //update the state of the provider
  }

  Future<void> _load() async {
    await ref.read(placesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    //WidgetRef ref->now. generally available
    final favs = ref.watch(placesProvider);
    late Widget content;
    if (favs.isEmpty) {
      content = Center(
        child: Text('No places added yet!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.onSurface)),
      );
    } else {
      content = FutureBuilder(
        //so _placesFuture loads the data and favs displays it
        future: _placesFuture,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: favs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundImage: FileImage(
                            favs[index].image), //wants an image provider
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Placesdeet(
                            fav: favs[index],
                          );
                        }));
                      },
                      title: Text(favs[index].title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                      subtitle: Text(favs[index].location.address,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface)),
                    );
                  },
                );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your places'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Places2()));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: content,
    );
  }
}
