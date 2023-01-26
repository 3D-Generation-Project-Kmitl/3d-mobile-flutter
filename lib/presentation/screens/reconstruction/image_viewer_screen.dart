import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/constants/colors.dart';
import 'dart:io';

import 'package:marketplace/presentation/screens/reconstruction/image_gallery_screen.dart';

class ImageViewerScreen extends StatelessWidget {
  final XFile previewImage;
  final List<XFile> imageFiles;

  const ImageViewerScreen({super.key, required this.previewImage, required this.imageFiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultTextStyle(
            style: const TextStyle(color: Colors.black, fontSize: 14),
            child: Text(previewImage.name)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(color: Colors.red,fontSize: 12),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImageGalleryScreen(
                    imageFiles: imageFiles,
                  ),
                ),
              );
            },
            child: const Text('รูปภาพทั้งหมด'),
          )
        ],
      ),
      body: SafeArea(child: Image.file(File(previewImage.path))),
    );
  }
}
