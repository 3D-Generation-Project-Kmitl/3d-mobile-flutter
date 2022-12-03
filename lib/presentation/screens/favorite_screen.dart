import 'package:e_commerce/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configs/size_config.dart';
import '../../constants/api.dart';
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

    if (favoriteCubit.state.favorites == null) {
      favoriteCubit.getFavorite();
    }
    return BlocConsumer<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteLoading) {
          //showLoadingDialog(context);
        } else if (state is FavoriteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        } else if (state is FavoriteLoaded) {
          favoriteCubit.setFavorite(state.favoriteList);
        }
      },
      builder: (context, state) {
        List<Favorite> favorites = state.favorites ?? [];
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 20,
            title: Text("รายการโปรด",
                style: Theme.of(context).textTheme.headline2),
            actions: const [
              CartButton(),
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: favorites.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: Text(
                              'ไม่มีสินค้าในรายการโปรด',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: favorites.length,
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemBuilder: (context, index) {
                            final favorite = favorites[index];
                            String imageURL = baseUrlStatic +
                                favorite.product.model.picture
                                    .replaceAll('\\', '/');
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
                                    image: NetworkImage(imageURL),
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
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: InkWell(
                                      onTap: () {
                                        favoriteCubit.removeFromFavorite(
                                            productId: favorite.productId);
                                      },
                                      child: const Icon(
                                        Icons.remove_circle_outline,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: InkWell(
                                      onTap: () {
                                        cartCubit
                                            .addToCart(
                                                productId: favorite.productId)
                                            .then((value) => showInfoDialog(
                                                  context,
                                                  title: value
                                                      ? "เพิ่มสินค้าลงตะกร้าแล้ว"
                                                      : "สินค้านี้อยู่ในตะกร้าแล้ว",
                                                ));
                                      },
                                      child: Icon(
                                        Icons.add_shopping_cart,
                                        size: 22,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
