import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LockedImageUploadWidget extends StatefulWidget {
  final Function(XFile file) onPicked;
  final XFile? selectedImage;
  final bool isChecking;
  const LockedImageUploadWidget({
    super.key,
    required this.onPicked,
    this.selectedImage,
    this.isChecking = false,
  });

  @override
  State<LockedImageUploadWidget> createState() => _LockedImageUploadWidgetState();
}

class _LockedImageUploadWidgetState extends State<LockedImageUploadWidget> {
  final picker = ImagePicker();

  void _pickImage() async {
    if (widget.isChecking) return;
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile != null) widget.onPicked(pickedFile);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double boxSize = screenSize.width * 0.8;
      String lockedImagePath = "assets/backgrounds/checkin1.png";


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
                _buildImageContent(lockedImagePath),

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
                          "Checking...",
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

  Widget _buildImageContent(String lockedPath) {
    if (widget.selectedImage != null) {
      return Image.file(File(widget.selectedImage!.path), fit: BoxFit.cover);
    } else {
      return Container(
        color: Colors.grey[200],
        child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0, 
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/backgrounds/checkin0.png',
                height: 200, 
                fit: BoxFit.contain, 
              ),
            ),
          ),
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_rounded, size: 40, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Upload check-in photo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20), 
            ],
          ),
          ],
        ),
      );
    }
  }
}
