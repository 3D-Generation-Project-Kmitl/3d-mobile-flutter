import 'dart:io';

import 'package:flutter/material.dart';

Widget roundedImageCard({
  String? imageURL,
  File? imageFile,
  double radius = 15.0,
  double ratio = 1,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: AspectRatio(
      aspectRatio: ratio,
      child: Image(
        image: imageURL != null
            ? NetworkImage(imageURL)
            : imageFile != null
                ? FileImage(imageFile)
                : const AssetImage('assets/images/placeholder3d.jpg')
                    as ImageProvider,
        fit: BoxFit.cover,
      ),
    ),
  );
}
