import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; //for File

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});
  final void Function(File image) onPickImage;
  @override
  State<StatefulWidget> createState() {
    return _ImageInput();
  }
}

class _ImageInput extends State<ImageInput> {
  File? _selectedImage; //not an xfile

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 600); //an Xfile is returned
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage =
          File(pickedImage.path); //path to that image file on the device
    });

    widget.onPickImage(_selectedImage!);
    //you're allowing the parent widget to handle the picked image in whatever way it needs to.
    //passing data back up the widget tree.
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: const Text('Take picture!'),
      onPressed: _takePicture,
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        //listen to all kinds of gestures on the child widget
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ); //create and show an image of type file
      //boxFit  cover->image looks good even if it needs to be resized
    }
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.3))),
        height: 250,
        width: double.infinity, //as wide as possible
        alignment: Alignment
            .center, //to make sure that icon is centered inside the container
        child: content);
  }
}
