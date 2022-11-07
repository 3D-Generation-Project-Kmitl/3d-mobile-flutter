import 'package:flutter/material.dart';

import '../../configs/size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth * 0.44,
      height: 230,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SizeConfig.screenWidth * 0.44,
            height: 180,
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
