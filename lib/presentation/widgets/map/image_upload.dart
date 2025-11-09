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

  Future<void> _submitImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var uri = Uri.parse('http://<YOUR_SERVER_IP>:5000/check_image');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('image', _selectedImage!.path),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      var data = jsonDecode(responseBody);
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Server Response'),
          content: Text(data['message'] ?? 'No message'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectedImage = (widget.mission.imagePath != null
        ? File(widget.mission.imagePath!)
        : null);

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: _selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _selectedImage!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
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
                ),
        ),

        const SizedBox(height: 20),

        // Nút submit
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _submitImage,
          icon: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color.fromARGB(255, 160, 7, 7),
                  ),
                )
              : const Icon(Icons.send),
          label: Text(_isLoading ? "Uploading..." : "Submit"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}
