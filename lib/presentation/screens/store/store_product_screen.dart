import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/presentation/widgets/rounded_image_card_widget.dart';
import 'package:marketplace/routes/screens_routes.dart';
import 'package:intl/intl.dart' as intl;

import '../../../configs/size_config.dart';
import '../../../data/models/models.dart';
import '../../helpers/helpers.dart';

class StoreProductScreen extends StatelessWidget {
  const StoreProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20,
          title: Text("สินค้าของฉัน",
              style: Theme.of(context).textTheme.headline2),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: Theme.of(context).textTheme.bodyText1,
            tabs: const [
              Tab(text: "ขายอยู่"),
              Tab(text: "ไม่แสดง"),
              Tab(text: "ละเมิด"),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocBuilder<MyStoreProductCubit, MyStoreProductState>(
            builder: (context, state) {
              if (state is MyStoreProductInitial) {
                context.read<MyStoreProductCubit>().getMyProducts();
                return buildTabBarView(
                    child: const Center(child: CircularProgressIndicator()));
              } else if (state is MyStoreProductLoading) {
                return buildTabBarView(
                    child: const Center(child: CircularProgressIndicator()));
              } else if (state is MyStoreProductLoaded) {
                return TabBarView(
                  children: [
                    buildMyProductList(context: context, status: "AVAILABLE"),
                    buildMyProductList(context: context, status: "UNAVAILABLE"),
                    buildMyProductList(context: context, status: "VIOLATION"),
                  ],
                );
              } else {
                return buildTabBarView(
                    child: const Center(child: Text("มีบางอย่างผิดพลาด")));
              }
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: getProportionateScreenHeight(50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, storeModelRoute);
              },
              child: const Text("เพิ่มสินค้าใหม่"),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProductCard(
      BuildContext context, Product product, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: roundedImageCard(
                          imageURL: product.model.picture, ratio: 0.95)),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400)),
                        const SizedBox(height: 5),
                        Text(
                            intl.NumberFormat.currency(
                              locale: 'th',
                              symbol: '฿',
                              decimalDigits: 0,
                            ).format(product.price),
                            style: Theme.of(context).textTheme.bodyText1),
                        const SizedBox(height: 5),
                        Text('ขายแล้ว: ${product.count!.orderProduct}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.black87)),
                        Text('ถูกใจ: ${product.count!.favorite}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.black87)),
                        Text('ยอดเข้าชม: ${product.views}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.black87)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        status == "AVAILABLE"
                            ? buildNotShowButton(context, product.productId)
                            : const SizedBox.shrink(),
                        status == "UNAVAILABLE"
                            ? buildSellButton(context, product.productId)
                            : const SizedBox.shrink(),
                        const SizedBox(height: 5),
                        status != "VIOLATION"
                            ? buildEditButton(context, product)
                            : const SizedBox.shrink(),
                        const SizedBox(height: 5),
                        buildDeleteButton(context, product)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMyProductList(
      {required BuildContext context, required String status}) {
    final products =
        context.read<MyStoreProductCubit>().getProductByStatus(status);
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return buildProductCard(context, products[index], status);
      },
    );
  }

  TabBarView buildTabBarView({required Widget child}) {
    return TabBarView(
      children: [
        Center(child: child),
        Center(child: child),
        Center(child: child),
      ],
    );
  }

  Widget buildEditButton(BuildContext context, Product product) {
    return SizedBox(
      height: getProportionateScreenHeight(35),
      width: getProportionateScreenWidth(80),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, storeEditProductRoute,
              arguments: product);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          side: const BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: Text(
          "แก้ไข",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.grey),
        ),
      ),
    );
  }

  Widget buildSellButton(BuildContext context, int productId) {
    return SizedBox(
      height: getProportionateScreenHeight(35),
      width: getProportionateScreenWidth(80),
      child: ElevatedButton(
        onPressed: () {
          context
              .read<MyStoreProductCubit>()
              .updateStatusProduct(productId, "AVAILABLE");
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          side: const BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: Text(
          "ลงขาย",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.grey),
        ),
      ),
    );
  }

  Widget buildNotShowButton(BuildContext context, int productId) {
    return SizedBox(
      height: getProportionateScreenHeight(35),
      width: getProportionateScreenWidth(80),
      child: ElevatedButton(
        onPressed: () {
          context
              .read<MyStoreProductCubit>()
              .updateStatusProduct(productId, "UNAVAILABLE");
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          side: const BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: Text(
          "ไม่แสดง",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.grey),
        ),
      ),
    );
  }

  Widget buildDeleteButton(BuildContext context, Product product) {
    return SizedBox(
      height: getProportionateScreenHeight(35),
      width: getProportionateScreenWidth(80),
      child: ElevatedButton(
        onPressed: () {
          showConfirmDialog(
            context,
            title: "คุณต้องการลบสินค้านี้ใช่หรือไม่",
            message: "ชื่อ: ${product.name}\nหากลบแล้วจะไม่สามารถกู้คืนได้",
            onConfirm: () {
              context
                  .read<MyStoreProductCubit>()
                  .updateStatusProduct(product.productId, "DELETED");
            },
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          side: const BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: Text(
          "ลบ",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.grey),
        ),
      ),
    );
  }
}
