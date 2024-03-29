import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/presentation/helpers/confirm_dialog.dart';
import 'package:marketplace/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../configs/size_config.dart';
import '../../../cubits/cubits.dart';
import '../../../routes/screens_routes.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final favoriteCubit = context.read<FavoriteCubit>();

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              if (state is FavoriteLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is FavoriteLoaded) {
                if (state.favorites.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      favoriteCubit.getFavorite();
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Text(
                          'ไม่มีสินค้าในรายการโปรด',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                      onRefresh: () async {
                        favoriteCubit.getFavorite();
                      },
                      child: _favoriteList(context, state.favorites));
                }
              } else {
                return const Center(
                  child: Text('Error'),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _favoriteList(BuildContext context, favorites) {
    return GridView.builder(
      itemCount: favorites.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.69,
        crossAxisSpacing: 14,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return _favoriteCard(context, favorite.product);
      },
    );
  }

  Widget _favoriteCard(BuildContext context, Product product) {
    SizeConfig().init(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          productDetailRoute,
          arguments: product.productId,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImageCard(
            imageURL: product.model.picture,
            ratio: 0.9,
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      intl.NumberFormat.currency(
                        locale: 'th',
                        symbol: '฿',
                        decimalDigits: 0,
                      ).format(product.price),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showConfirmDialog(context,
                        title: "ลบสินค้า",
                        message:
                            "คุณต้องการลบสินค้าออกจากรายการโปรดหรือไม่ ?\nชื่อ: ${product.name}",
                        onConfirm: () {
                      context
                          .read<FavoriteCubit>()
                          .removeFromFavorite(productId: product.productId);
                    });
                  },
                  icon: const Icon(
                    Icons.delete_sweep,
                    color: Colors.red,
                  ),
                  splashColor: Colors.transparent,
                  splashRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
