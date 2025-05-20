import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(XFile?) onImagePicked;

  const ImagePickerWidget({Key? key, required this.onImagePicked})
      : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Uint8List? _imageBytes;
  XFile? _pickedFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _pickedFile = pickedFile;
        });
      } else {
        setState(() {
          _pickedFile = pickedFile;
          _imageBytes = null;
        });
      }
      widget.onImagePicked(_pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imagePreview;
    if (_imageBytes != null) {
      imagePreview = Image.memory(_imageBytes!, height: 100, fit: BoxFit.cover);
    } else if (_pickedFile != null && !kIsWeb) {
      imagePreview =
          Image.file(File(_pickedFile!.path), height: 100, fit: BoxFit.cover);
    } else {
      imagePreview = const Text('Belum pilih foto');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imagePreview,
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.photo_camera),
            label: const Text('Pilih Foto'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0077B6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(double.infinity, 40),
            ),
          ),
        ),
      ],
    );
  }
}
