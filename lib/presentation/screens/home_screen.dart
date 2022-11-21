import 'package:flutter/material.dart';
import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/presentation/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../routes/screens_routes.dart';
import 'package:e_commerce/cubits/cubits.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsCubit = context.read<ProductsCubit>();

    productsCubit.getProducts();

    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductsLoading) {
          //showLoadingDialog(context);
        } else if (state is ProductsFailure) {
          //hideLoadingDialog(context);
          //showErrorDialog(context, state.message);
        } else if (state is ProductsLoaded) {
          productsCubit.setProducts(state.products);
        }
      },
      builder: (context, state) {
        if (state.products == null) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          List<Product> products = state.products!;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              titleSpacing: 5,
              leading: const SizedBox.shrink(),
              leadingWidth: 5,
              title: SizedBox(
                height: 42,
                child: _searchField(context),
              ),
              actions: const [
                CartButton(),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Text("หมวดหมู่",
                              style: Theme.of(context).textTheme.headline4),
                          _categoryList(context),
                          Text("สินค้าแนะนำ",
                              style: Theme.of(context).textTheme.headline4),
                        ],
                      ),
                    ),
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ProductCard(
                            product: products[index],
                            press: () {},
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _categoryList(context) {
    double side = 65;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: side + 50,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
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
                        overflow: TextOverflow.ellipsis,
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

  Widget _searchField(context) {
    return TextField(
      readOnly: true,
      onTap: () {
        Navigator.pushNamed(context, searchRoute);
      },
      decoration: const InputDecoration(
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
    );
  }
}
