import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../configs/size_config.dart';
import 'package:marketplace/data/models/models.dart';

import 'rounded_image_card_widget.dart';

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

    return GestureDetector(
      onTap: press as void Function()?,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImageCard(
            imageURL: product.model.picture,
            radius: 15,
            ratio: 0.85,
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
              intl.NumberFormat.currency(
                locale: 'th',
                symbol: '฿',
                decimalDigits: 0,
              ).format(product.price),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }
}
