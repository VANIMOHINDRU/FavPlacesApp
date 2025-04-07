import 'package:fav_places_app/models/fav_pl.dart';
import 'package:fav_places_app/provider/placesProvider.dart';
import 'package:fav_places_app/widgets/image_input.dart';
import 'package:fav_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class Places2 extends ConsumerStatefulWidget {
  const Places2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Places2State();
  }
}

class _Places2State extends ConsumerState<Places2> {
  final _titleController = TextEditingController();
//TextEditingController is used to capture the text input for the title of a favorite place
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  void _savePlace() {
    final enteredText = _titleController.text;

    if (enteredText.isEmpty ||
        enteredText.trim().length <= 1 ||
        enteredText.trim().length > 50 ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }

    ref.read(placesProvider.notifier).togglePlaces(FavPl(
        title: enteredText,
        image: _selectedImage!,
        location: _selectedLocation!));

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // Always dispose of the controller when it's no longer needed
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new Place!'),
        ),
        body: SingleChildScrollView(
          child: Form(
            //formKey helps to access the form’s internal state, enabling you to reset or save the form’s data
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                    controller: _titleController,
                    maxLength: 50,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        label: Text('Title',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface))),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return 'Please enter a valid title.';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 6,
                ),
                ImageInput(
                  onPickImage: (image) {
                    _selectedImage = image;//selectedImage is initially empty and then it gets its value when user captures an image?
                  }, //no image is passed to _selectedImage
                ),
                const SizedBox(
                  height: 6,
                ),
                LocationInput(
                  onSelectLocation: (loc) {
                    //provided by onSelectLoc
                    _selectedLocation = loc;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white)),
                  onPressed: _savePlace,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ))
              ],
            ),
          ),
        ));
  }
}
