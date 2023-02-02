import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/configs/theme.dart';
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
        title: Text(previewImage.name,
            style: Theme.of(context).textTheme.headline4),
        actions: [
          TextButton(
            // style: TextButton.styleFrom(
            //   textStyle: const TextStyle(color: Colors.red,fontSize: 12),
            // ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImageGalleryScreen(
                    imageFiles: imageFiles,
                  ),
                ),
              );
            },
            child: Text('รูปภาพทั้งหมด',style:Theme.of(context).textTheme.bodyText2!.copyWith(color:primaryColor)),
          )
        ],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Image.file(File(previewImage.path),width: double.infinity,),
      )),
    );
  }
}
