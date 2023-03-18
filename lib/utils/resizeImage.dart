import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';

Future<File> resizeImageFromPath(String path) async {
  File compressedFile =
      await FlutterNativeImage.compressImage(path, quality: 50, percentage: 50);
  return compressedFile;
}
