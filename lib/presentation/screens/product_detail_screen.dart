import 'package:flutter/material.dart';
import 'package:e_commerce/data/models/models.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Text(
            "Product Detail Screen",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
