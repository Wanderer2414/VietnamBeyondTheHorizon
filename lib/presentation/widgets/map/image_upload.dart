import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:vietnambeyondthehorizon/data/models/mission_model.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/map_controller.dart';

class ImageUploadWidget extends StatefulWidget {
  final MissionModel mission;
  final MyMapController controller;
  const ImageUploadWidget({
    required this.mission,
    required this.controller,
    super.key,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _selectedImage;
  bool _isLoading = false;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // hoặc ImageSource.camera
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        widget.controller.updateMissionImage(
          widget.mission.id,
          pickedFile.path,
        );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    _selectedImage = (widget.mission.imagePath != null
        ? File(widget.mission.imagePath!)
        : null);
    Widget? container;
    if (_selectedImage != null) {
        container = ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            _selectedImage!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        );
    }
    else {
      container = Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.add_a_photo,
                    size: 48,
                    color: Colors.grey[700],
                  ),
                );

    }
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: SizedBox(
            width: screenSize.width*0.8,
            height: screenSize.width*0.8,
            child: container,
          ),
        ),
      ],
    );
  }
}
