import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  Function passImageToAuthForm;

  UserImagePicker(this.passImageToAuthForm);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
    File? _pickedImage;

  void _pickImage() async{
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 50, maxWidth: 150);
    setState(() {
      _pickedImage =File(image!.path);
    });
    widget.passImageToAuthForm(_pickedImage!);

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).disabledColor,
          radius: 50,
          backgroundImage:_pickedImage == null ? null: FileImage(_pickedImage!),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          label: const Text('Add image'),
          icon: const Icon(Icons.image),
        ),
      ],
    );
  }
}
