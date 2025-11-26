import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';

class ImageUploadWidget extends StatefulWidget {
  final Function(XFile file) onPicked;
  final XFile? selectedImage;
  const ImageUploadWidget({
    super.key,
    required this.onPicked,
    this.selectedImage,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final picker = ImagePicker();

  void _pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // hoặc ImageSource.camera
      imageQuality: 80,
    );
    if (pickedFile != null) widget.onPicked(pickedFile);

    //   setState(() {
    //   _selectedImage = File(pickedFile.path);
    //   widget.controller.updateMissionImage(widget.mission.id, pickedFile.path);
    // });
  }

  @override
  Widget build(BuildContext context) {
    Widget? container;
    if (widget.selectedImage != null) {
      container = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(widget.selectedImage!.path),
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    } else {
      container = Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.add_a_photo, size: 48, color: Colors.grey[700]),
      );
    }
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: SizedBox(
            width: screenSize.width * 0.8,
            height: screenSize.width * 0.8,
            child: container,
          ),
        ),
      ],
    );
  }
}
