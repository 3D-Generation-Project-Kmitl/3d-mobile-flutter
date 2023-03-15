import 'package:flutter/material.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/presentation/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../routes/screens_routes.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/routes/screens_routes.dart';

class SearchResultScreen extends StatelessWidget {
  final String keyword;
  const SearchResultScreen({
    Key? key,
    required this.keyword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchProductsCubit(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            titleSpacing: 5,
            leadingWidth: 40,
            leading: IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, navigationRoute, (route) => false);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: SizedBox(
              height: 40,
              child: _searchField(context, keyword),
            ),
            bottom: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: Theme.of(context).textTheme.bodyText1,
              tabs: const [
                Tab(text: "ยอดนิยม"),
                Tab(text: "ล่าสุด"),
                Tab(text: "ขายดี"),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: BlocBuilder<SearchProductsCubit, SearchProductsState>(
                  builder: (context, state) {
                    if (state is SearchProductsInitial) {
                      context
                          .read<SearchProductsCubit>()
                          .searchProducts(keyword);
                      return buildTabBarView(
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is SearchProductsLoaded) {
                      if (state.products.isEmpty) {
                        return buildTabBarView(
                          child:
                              const Center(child: Text("ไม่พบสินค้าที่ค้นหา")),
                        );
                      } else {
                        return TabBarView(
                          children: [
                            _buildProductList(
                              products: context
                                  .read<SearchProductsCubit>()
                                  .getPopularProducts(),
                            ),
                            _buildProductList(
                              products: context
                                  .read<SearchProductsCubit>()
                                  .getLatestProducts(),
                            ),
                            _buildProductList(
                              products: context
                                  .read<SearchProductsCubit>()
                                  .getBestSellerProducts(),
                            ),
                          ],
                        );
                      }
                    } else {
                      return buildTabBarView(
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                )),
          ),
        ),
      ),
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

  Widget _searchField(context, String keyword) {
    return TextField(
      readOnly: true,
      onTap: () {
        Navigator.pushNamed(context, searchRoute);
      },
      decoration: InputDecoration(
        hintText: keyword,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: outlineColor,
        contentPadding: const EdgeInsets.all(5),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _buildProductList({
    required List<Product> products,
  }) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverGrid(
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
                      arguments: products[index].productId);
                },
              );
            },
            childCount: products.length,
          ),
        ),
      ],
    );
  }
}
