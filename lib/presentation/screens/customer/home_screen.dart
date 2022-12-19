import 'package:flutter/material.dart';
import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/presentation/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/models.dart';
import '../../../routes/screens_routes.dart';
import 'package:e_commerce/cubits/cubits.dart';
import 'package:e_commerce/routes/screens_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsCubit = context.read<ProductsCubit>();
    final productsState = productsCubit.state;

    final categoriesCubit = context.read<CategoryCubit>();
    final categoriesState = categoriesCubit.state;

    if (categoriesState is CategoryInitial) {
      categoriesCubit.getCategories();
    }

    if (productsState is ProductsInitial) {
      productsCubit.getProducts();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 5,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        title: SizedBox(
          height: 40,
          child: _searchField(context),
        ),
        actions: const [
          CartButton(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: RefreshIndicator(
            onRefresh: () async {
              productsCubit.getProducts();
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Text("หมวดหมู่",
                          style: Theme.of(context).textTheme.headline4),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                _buildCategoryList(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(
                        height: 10,
                      ),
                      Text("สินค้าแนะนำ",
                          style: Theme.of(context).textTheme.headline4),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                _buildProductList(),
              ],
            ),
          ),
        ),
      ),
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
        contentPadding: EdgeInsets.all(5),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1,
              crossAxisSpacing: 0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return CategoryCard(
                  category: state.categories[index],
                  press: () {},
                );
              },
              childCount: 5,
            ),
          );
        } else {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildProductList() {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
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
                  product: state.products[index],
                  press: () {
                    Navigator.pushNamed(context, productDetailRoute,
                        arguments: state.products[index]);
                  },
                );
              },
              childCount: state.products.length,
            ),
          );
        } else {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
