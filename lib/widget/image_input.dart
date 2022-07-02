import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  const ImageInput({Key? key, required this.onSelectImage}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  // File? _storeImage;
  XFile? _storeImage;
  Future<void> getImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
      );
      if (image == null) return;
      setState(() {
        _storeImage = image;
      });
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(image.path);
      final file = await io.File(image.path).copy('${appDir.path}/$fileName');
      widget.onSelectImage(file);
      print(" This is Image File $file");
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> getImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
      if (image == null) return;
      setState(() {
        _storeImage = image;
      });
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(image.path);
      final file = await io.File(image.path).copy('${appDir.path}/$fileName');
      widget.onSelectImage(file);
      print(" This is Image File $file");
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _takePicture() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: _storeImage != null
              ? Image.file(
                  io.File(_storeImage!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text('No Image Taken'),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: _takePicture,
            icon: const Icon(Icons.camera),
            label: const Text(
              'Take Picture',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
