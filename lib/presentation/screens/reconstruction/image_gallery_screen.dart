import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:marketplace/presentation/screens/reconstruction/image_viewer_screen.dart';

class ImageGalleryScreen extends StatelessWidget {
  final List<XFile> imageFiles;
  final List<Map<String, dynamic>?>? cameraParameterList;
  final String previousScreen;

  const ImageGalleryScreen(
      {super.key,
      required this.imageFiles,
      required this.previousScreen,
      this.cameraParameterList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('${imageFiles.length.toString()} รูป',
                style: Theme.of(context).textTheme.headline4),
            leading: BackButton(
              onPressed: () => {
                Navigator.of(context).pop(),
              },
            )),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
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
                              cameraParameter: cameraParameterList != null
                                  ? cameraParameterList![index]
                                  : null,
                              cameraParameterList: cameraParameterList,
                              imageFiles: imageFiles,
                              previousScreen: 'ig',
                            ),
                          ),
                        )
                      },
                      child: FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
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
