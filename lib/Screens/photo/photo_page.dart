import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectPhotoPage extends StatefulWidget {
  const SelectPhotoPage({super.key});

  @override
  State<SelectPhotoPage> createState() => _SelectPhotoPageState();
}

class _SelectPhotoPageState extends State<SelectPhotoPage> {
  final ImagePicker picker = ImagePicker();

  XFile? selectedImage;
  Uint8List? selectedImageBytes;

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final Uint8List bytes = await image.readAsBytes();

    setState(() {
      selectedImage = image;
      selectedImageBytes = bytes;
    });
  }

  void saveImage() {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma foto antes de salvar'),
        ),
      );
      return;
    }

    Navigator.pop(context, selectedImage!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolher foto'),
        actions: [
          TextButton(
            onPressed: saveImage,
            child: const Text('Salvar'),
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: pickImage,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: selectedImageBytes == null
                ? const Icon(Icons.add_a_photo, size: 64)
                : ClipOval(
              child: Image.memory(
                selectedImageBytes!,
                width: 220,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}