import 'package:flutter/material.dart';
import '../../configs/size_config.dart';
import '../../constants/colors.dart';
import 'package:e_commerce/data/models/models.dart';
import 'package:e_commerce/constants/api.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function press;

  const ProductCard({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenWidth;

    String imageURL =
        baseUrlStatic + product.model.picture.replaceAll('\\', '/');

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: NetworkImage(imageURL),
            fit: BoxFit.cover,
            height: width * 0.52,
          ),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            product.price.toString(),
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
