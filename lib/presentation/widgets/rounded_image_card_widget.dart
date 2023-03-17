import 'dart:io';

import 'package:flutter/material.dart';

Widget roundedImageCard(
    {String? imageURL,
    File? imageFile,
    double radius = 15.0,
    double ratio = 1,
    String? describes}) {
  if (describes == null) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AspectRatio(
        aspectRatio: ratio,
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.softLight,
          ),
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
      ),
    );
  } else {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: AspectRatio(
            aspectRatio: ratio,
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.softLight,
              ),
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
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Container(
              color: Colors.grey.withOpacity(0.5),
              child: Center(
                  child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      child: Text(describes!)))),
        ),
      ],
    );
  }
}
