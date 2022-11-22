import 'package:flutter/material.dart';
import 'package:e_commerce/data/models/models.dart';

import '../../constants/api.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final Function press;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageURL = baseUrlStatic + category.picture.replaceAll('\\', '/');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.23),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Image(
              image: NetworkImage(imageURL),
              height: 32,
              width: 32,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          category.name,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
