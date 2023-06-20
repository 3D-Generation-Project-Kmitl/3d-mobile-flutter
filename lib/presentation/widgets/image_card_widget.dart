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
            backgroundColor: Theme.of(context).primaryColor,
            radius: radius,
            backgroundImage: NetworkImage(
              imageURL,
            ))
        : CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: radius,
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          );
  }
}
