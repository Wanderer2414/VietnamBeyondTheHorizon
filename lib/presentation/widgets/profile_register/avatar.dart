import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarWidget extends StatefulWidget {
  final double radius;
  final bool onClick;
  final Function(File)? onAvatarChanged;
  const AvatarWidget({
    super.key,
    required this.radius,
    this.onClick = true,
    this.onAvatarChanged,
  });

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      widget.onAvatarChanged?.call(_imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick ? _pickImage : null,
      child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: Colors.grey[300],
        backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
        child: _imageFile == null
            ? Icon(Icons.person, size: widget.radius * 0.8, color: Colors.white)
            : null,
      ),
    );
  }
}
