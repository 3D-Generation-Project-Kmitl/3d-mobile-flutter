import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    required this.imageURL,
    this.radius = 35.0,
  }) : super(key: key);

  final String imageURL;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return imageURL != ''
        ? CircleAvatar(
            radius: radius,
            child: ClipOval(
              child: Image.network(
                imageURL,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          )
        : CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: radius - 10.0,
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          );
  }
}
