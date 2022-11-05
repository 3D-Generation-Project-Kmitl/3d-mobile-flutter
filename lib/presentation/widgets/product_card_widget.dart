import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

import '../../configs/size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth * 0.4,
      height: 200,
      margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SizeConfig.screenWidth * 0.4,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 5),
          Text("ชื่อสินค้า", style: Theme.of(context).textTheme.subtitle1),
          const SizedBox(height: 5),
          Text(
            "ราคา",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
