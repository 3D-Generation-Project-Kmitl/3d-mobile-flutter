import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../routes/screens_routes.dart';

class CartButton extends StatelessWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, cartRoute);
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: primaryColor,
              size: 27,
            ),
          ),
          Positioned(
            top: 8,
            right: 10,
            child: Container(
              height: 11,
              width: 11,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
