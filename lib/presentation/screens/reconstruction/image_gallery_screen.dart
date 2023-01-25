import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:marketplace/presentation/screens/reconstruction/image_viewer_screen.dart';

class ImageGalleryScreen extends StatelessWidget {
  final List<XFile> imageFiles;

  const ImageGalleryScreen({super.key, required this.imageFiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: DefaultTextStyle(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                child: Text('${imageFiles.length.toString()} รูป'))),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.69,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      onTap: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImageViewerScreen(
                                previewImage: imageFiles[index],
                                imageFiles: imageFiles),
                          ),
                        )
                      },
                      child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.file(File(imageFiles[index].path)),
                  ),
                    );
                  },
                  childCount: imageFiles.length,
                ),
              )
            ],
          ),
        ));
  }
}
