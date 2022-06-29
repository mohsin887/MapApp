import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:great_place/provider/great_places.dart';
import 'package:great_place/widget/image_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/place.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/addPlace';
  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final TextEditingController _titleController = TextEditingController();
  XFile? _pickedImage;

  void _selectImage(io.File pickedImage) {
    _pickedImage = XFile(pickedImage.path);
    print('This is Selected Image $pickedImage');
  }

  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      print(_titleController.text.isEmpty);
      print(_pickedImage);
      print('_AddPlaceScreenState._savePlace');
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('An Error Occurred'),
              content: const Text('Please add Place or Image'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          });
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage!,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ImageInput(onSelectImage: _selectImage),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            onPressed: _savePlace,
            icon: const Icon(Icons.add),
            label: const Text('Add Place'),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          )
        ],
      ),
    );
  }
}
