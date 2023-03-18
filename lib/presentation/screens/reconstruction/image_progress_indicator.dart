import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/constants/reconstruction.dart';

class ImageProgressIndicatior extends StatelessWidget {
  final List<XFile>? imageFiles;
  const ImageProgressIndicatior({super.key, required this.imageFiles});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: minImages,
                  child: Container(
                    alignment: Alignment.centerRight,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(width: 1.0, color: primaryColor),
                      ),
                      color: Colors.white,
                    ),
                    child: const Text(
                      'ขั้นต่ำ',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                Expanded(
                  flex: goodImages,
                  child: Container(
                    alignment: Alignment.centerRight,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(width: 1, color: primaryColor),
                      ),
                      color: Colors.white,
                    ),
                    child: const Text(
                      'ดี',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                Expanded(
                  flex: maxImages - goodImages - minImages,
                  child: Container(
                    alignment: Alignment.centerRight,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(width: 1.0, color: primaryColor),
                      ),
                      color: Colors.white,
                    ),
                    child: const Text(
                      'เยี่ยม',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              value: imageFiles != null ? imageFiles!.length / maxImages : 0.0,
              semanticsLabel: 'Linear progress indicator',
              color: primaryColor,
              backgroundColor: primaryVeryLight,
            ),
          ],
        ),
      ),
    );
  }
}
