import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage('assets/images/nature.png'),
          height: 40,
          width: 40,
        ),
        const SizedBox(height: 5),
        Text(
          'ศิลปะ',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
