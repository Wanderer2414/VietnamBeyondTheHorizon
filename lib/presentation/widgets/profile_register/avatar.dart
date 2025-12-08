import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vietnambeyondthehorizon/presentation/controllers/proxy/proxy.dart';

class AvatarWidget extends StatefulWidget {
  final double radius;
  final bool onClick;
  // final Function(File)? onAvatarChanged;
  final String? currentAvatarUrl;
  const AvatarWidget({
    super.key,
    required this.radius,
    this.onClick = true,
    this.currentAvatarUrl,
    // this.onAvatarChanged,
  });

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
 
  String? _avatarUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _avatarUrl = widget.currentAvatarUrl;
  }
  
  Future<bool> _onAvatarChanged(File? _imageFile) async {
    if(_imageFile == null) throw Exception("Null avatar image");
    setState(() {
      _isUploading = true;
    });
    try{
     _avatarUrl = await NetworkProxy.updateAvatar(_imageFile.path);
      if(_avatarUrl != null){
        return true;
      }
    }
    catch (e){
      print("Exception(avatar): $e");
    }
    finally {
      setState(() {
        _isUploading = false;
      });
    }
    return false;
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    File? _imageFile;
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
     if((await _onAvatarChanged(_imageFile)) == false){
      _imageFile = null;
     }

    }
  }

  @override
  Widget build(BuildContext context) {

    ImageProvider? backgroundImage ;
    if(_avatarUrl != null){
      backgroundImage = NetworkImage(_avatarUrl!);
    }
    return GestureDetector(
      onTap: (widget.onClick && !_isUploading) ? _pickImage : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: widget.radius,
            backgroundColor: Colors.grey[300],
            backgroundImage: backgroundImage,
            child: (backgroundImage == null)
                ? Icon(
                    Icons.person,
                    size: widget.radius * 0.8,
                    color: const Color.fromARGB(255, 110, 110, 110),
                  )
                : null,
          ),

          if (_isUploading)
            Container(
              width: widget.radius * 2,
              height: widget.radius * 2,
              decoration: BoxDecoration(
                color: Colors.black45, 
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
            
          if (widget.onClick && !_isUploading)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Icon(Icons.camera_alt, size: 14, color: Colors.grey[700]),
              ),
            )
        ],
      ),
    );
  }
}
