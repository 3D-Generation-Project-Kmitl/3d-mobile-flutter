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

    return GestureDetector(
      onTap: press as void Function()?,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
              image: NetworkImage(imageURL),
              fit: BoxFit.cover,
              height: width * 0.54,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              '฿ ${product.price}',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }
}
