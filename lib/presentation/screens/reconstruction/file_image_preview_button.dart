import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FileImagePreviewButton extends StatelessWidget {
  final List<XFile> imageFiles;
  const FileImagePreviewButton(
      {super.key, required this.imageFiles});
  @override
  Widget build(BuildContext context) {
    return imageFiles.isNotEmpty
        ? Stack(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  color: Colors.grey,
                  child: FittedBox(
                          fit:BoxFit.cover,
                          clipBehavior: Clip.hardEdge,
                          child:Image.file(File(imageFiles.last.path)) ,
                        )),
              Container(
                  height: 40,
                  width: 40,
                  color: Colors.grey.withOpacity(0.3),
                  child: Center(
                      child: DefaultTextStyle(
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          child: Text(imageFiles.length.toString())))),
            ],
          )
        : Container(
            height: 50,
            width: 50,
            color: Colors.grey.withOpacity(0),
          );
  }
}
