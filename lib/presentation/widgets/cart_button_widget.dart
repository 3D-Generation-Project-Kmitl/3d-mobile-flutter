import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../routes/screens_routes.dart';

class CartButton extends StatelessWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, cartRoute);
          },
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: primaryColor,
            size: 30,
          ),
        ),
        Positioned(
          top: 3,
          right: 6,
          child: Container(
            height: 18,
            width: 18,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: const Center(
                child: Text(
              "5",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
      ],
    );
  }
}
