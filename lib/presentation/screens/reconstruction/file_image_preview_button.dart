import 'dart:io';
import 'package:flutter/material.dart';

class FileImagePreviewButton extends StatelessWidget {
  final String imagePath;
  final int numberOfPicture;
  const FileImagePreviewButton(
      {super.key, required this.imagePath, required this.numberOfPicture});
  @override
  Widget build(BuildContext context) {
    return imagePath != ''
        ? Stack(
            children: [
              Container(
                  height: 50,
                  width: 50,
                  color: Colors.grey,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.file(File(imagePath)),
                  )),
              Container(
                  height: 50,
                  width: 50,
                  color: Colors.grey.withOpacity(0.3),
                  child: Center(
                      child: DefaultTextStyle(
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          child: Text(numberOfPicture.toString())))),
            ],
          )
        : Container(
            height: 50,
            width: 50,
            color: Colors.grey.withOpacity(0),
          );
  }
}
