import 'dart:io';
import 'package:flutter/material.dart';
import 'package:haidiloa/app/core/permission/permission_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final _supabase = Supabase.instance.client;
  File? _image;
  String? _uploadedUrl;
  final permissionService = PermissionService();

  Future<void> _pickImage() async {
    if (await permissionService.requestPhotosPermission()) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload lên bucket "avatars"
      final uploadedPath = await _supabase.storage
          .from('avatars')
          .upload(fileName, _image!);

      // Lấy public url
      final publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(uploadedPath);

      setState(() {
        _uploadedUrl = publicUrl;
      });
    } on StorageException catch (e) {
      print('Upload error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Image")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null) Image.file(_image!, height: 150),
            if (_uploadedUrl != null) Image.network(_uploadedUrl!, height: 150),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Chọn ảnh"),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text("Upload lên Supabase"),
            ),
          ],
        ),
      ),
    );
  }
}
