import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadWidget extends StatefulWidget {
  final Function(XFile file) onPicked;
  final XFile? selectedImage;
  final bool isChecking;
  const ImageUploadWidget({
    super.key,
    required this.onPicked,
    this.selectedImage,
    this.isChecking = false,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final picker = ImagePicker();

  void _pickImage() async {
    if (widget.isChecking) return;
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
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
    final Size screenSize = MediaQuery.of(context).size;
    final double boxSize = screenSize.width * 0.8;

    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildImageContent(),

                if (widget.isChecking)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                            backgroundColor: Colors.white24,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Analyzing...",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    if (widget.selectedImage != null) {
      return Image.file(File(widget.selectedImage!.path), fit: BoxFit.cover);
    } else {
      return Container(
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_rounded, size: 50, color: Colors.grey[400]),
            SizedBox(height: 10),
            Text(
              "Tap to upload",
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
  }
}
