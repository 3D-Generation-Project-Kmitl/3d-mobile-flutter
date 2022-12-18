import 'package:e_commerce/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configs/size_config.dart';
import '../../cubits/cubits.dart';
import '../../data/models/models.dart';
import '../../routes/screens_routes.dart';
import '../helpers/helpers.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final favoriteCubit = context.read<FavoriteCubit>();
    final cartCubit = context.read<CartCubit>();

    if (favoriteCubit.state is FavoriteInitial) {
      favoriteCubit.getFavorite();
    }
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text("รายการโปรด", style: Theme.of(context).textTheme.headline2),
        actions: const [
          CartButton(),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FavoriteLoaded) {
              if (state.favorites.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Text(
                      'ไม่มีสินค้าในรายการโปรด',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                );
              } else {
                return ListView.separated(
                  itemCount: state.favorites.length,
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    final favorite = state.favorites[index];

                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, productDetailRoute,
                            arguments: favorite.product);
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      dense: true,
                      visualDensity: const VisualDensity(vertical: 4),
                      leading: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 64,
                          minHeight: 64,
                          maxWidth: 64,
                          maxHeight: 64,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: NetworkImage(favorite.product.model.picture),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(favorite.product.name,
                          style: Theme.of(context).textTheme.bodyText2),
                      subtitle: Text("฿${favorite.product.price}",
                          style: Theme.of(context).textTheme.headline4),
                      trailing: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              favoriteCubit.removeFromFavorite(
                                  productId: favorite.productId);
                            },
                            child: const Icon(
                              Icons.remove_circle_outline,
                              size: 27,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              cartCubit
                                  .addToCart(productId: favorite.productId)
                                  .then((value) => showInfoDialog(
                                        context,
                                        title: value
                                            ? "เพิ่มสินค้าลงตะกร้าแล้ว"
                                            : "สินค้านี้อยู่ในตะกร้าแล้ว",
                                      ));
                            },
                            child: Icon(
                              Icons.add_shopping_cart,
                              size: 27,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            } else {
              return const Center(
                child: Text('Error'),
              );
            }
          },
        ),
      ),
    );
  }
}
