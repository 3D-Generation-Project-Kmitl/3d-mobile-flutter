import 'package:flutter/material.dart';
import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/presentation/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../routes/screens_routes.dart';
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

    if (categoriesState.categories == null) {
      categoriesCubit.getCategories();
    }

    if (productsState.products == null) {
      productsCubit.getProducts();
    }

    return MultiBlocListener(
        listeners: [
          BlocListener<ProductsCubit, ProductsState>(
            listener: (context, state) {
              if (state is ProductsLoading) {
              } else if (state is ProductsFailure) {
                //hideLoadingDialog(context);
                //showErrorDialog(context, state.message);
              } else if (state is ProductsLoaded) {
                productsCubit.setProducts(state.products);
              }
            },
          ),
          BlocListener<CategoryCubit, CategoryState>(
              listener: (context, state) {
            if (state is CategoryLoading) {
              //showLoadingDialog(context);
            } else if (state is CategoryError) {
              //hideLoadingDialog(context);
              //showErrorDialog(context, state.message);
            } else if (state is CategoryLoaded) {
              categoriesCubit.setCategories(state.categories);
            }
          })
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            titleSpacing: 5,
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
            title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 40,
                child: _searchField(context),
              ),
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
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, state) {
                      List<Category> categories = state.categories ?? [];
                      if (categories.isEmpty) {
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
                      return SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 1,
                          crossAxisSpacing: 0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return CategoryCard(
                              category: categories[index],
                              press: () {},
                            );
                          },
                          childCount: 5,
                        ),
                      );
                    },
                  ),
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
                  BlocBuilder<ProductsCubit, ProductsState>(
                    builder: (context, state) {
                      List<Product> products = state.products ?? [];
                      if (products.isEmpty) {
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
                      return SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
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
}
