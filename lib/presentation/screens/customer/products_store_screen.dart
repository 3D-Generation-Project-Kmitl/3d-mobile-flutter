import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/constants/colors.dart';

import '../../../configs/size_config.dart';
import '../../../cubits/cubits.dart';
import '../../../data/models/models.dart';
import '../../../routes/screens_routes.dart';
import '../../widgets/widgets.dart';

class ProductsStoreScreen extends StatelessWidget {
  final int storeId;
  const ProductsStoreScreen({Key? key, required this.storeId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => ProductsStoreCubit(),
      child: BlocBuilder<ProductsStoreCubit, ProductsStoreState>(
        builder: (context, state) {
          if (state is ProductsStoreInitial) {
            context.read<ProductsStoreCubit>().getProductsByStoreId(storeId);
          } else if (state is ProductsStoreLoaded) {
            final store = state.productsStore;
            final products = store.products;
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(135),
                child: Column(
                  children: [
                    AppBar(
                      titleSpacing: 20,
                      title: Text("ร้านค้า",
                          style: Theme.of(context).textTheme.headline2),
                      actions: const [
                        CartButton(),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: outlineColor)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: [
                            ImageCard(
                                radius: 25, imageURL: store.picture ?? ""),
                            SizedBox(width: SizeConfig.screenWidth * 0.05),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store.name,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                    height: SizeConfig.screenHeight * 0.005),
                                Text(
                                  "ออนไลน์",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: primaryColor,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "ติดตาม",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      _buildProductList(products),
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 20,
              title:
                  Text("ร้านค้า", style: Theme.of(context).textTheme.headline2),
            ),
            resizeToAvoidBottomInset: false,
            body: const SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return SliverList(
        delegate: SliverChildListDelegate(
          [
            const SizedBox(
              height: 500,
              child: Center(
                child: Text('ไม่พบสินค้าที่ค้นหา'),
              ),
            ),
          ],
        ),
      );
    }
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.69,
        crossAxisSpacing: 14,
        mainAxisSpacing: 10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ProductCard(
            product: products[index],
            press: () {
              Navigator.pushNamed(context, productDetailRoute,
                  arguments: products[index]);
            },
          );
        },
        childCount: products.length,
      ),
    );
  }
}