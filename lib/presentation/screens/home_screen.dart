import 'package:flutter/material.dart';
import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: SizedBox(
            height: 42,
            child: Row(children: <Widget>[
              _searchTextField(),
              _cartButton(),
            ]),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _categoryList(context),
                _productList(context),
              ],
            ),
          )),
        ));
  }

  Widget _productList(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("สินค้าแนะนำ", style: Theme.of(context).textTheme.headline4),
        Row(
          children: [
            ProductCard(),
            ProductCard(),
          ],
        )
      ],
    );
  }

  Widget _categoryList(context) {
    double side = 65;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("หมวดหมู่", style: Theme.of(context).textTheme.headline4),
        SizedBox(
          height: side + 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                width: side + 5,
                height: side,
                margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: side,
                      height: side,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Text("แฟชั่น",
                        style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _searchTextField() {
    return const Expanded(
        child: TextField(
      decoration: InputDecoration(
        hintText: 'ค้นหาสินค้า',
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: outlineColor,
        contentPadding: EdgeInsets.all(8),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    ));
  }

  Widget _cartButton() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        IconButton(
          onPressed: () {},
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
