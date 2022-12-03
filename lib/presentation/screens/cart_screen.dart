import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configs/size_config.dart';
import '../../constants/api.dart';
import '../../cubits/cubits.dart';
import '../../data/models/models.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //double width = SizeConfig.screenWidth;
    final cartCubit = context.read<CartCubit>();

    if (cartCubit.state.carts == null) {
      cartCubit.getCart();
    }
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartLoading) {
          //showLoadingDialog(context);
        } else if (state is CartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        } else if (state is CartLoaded) {
          cartCubit.setCart(state.cartList);
        }
      },
      builder: (context, state) {
        List<Cart> carts = state.carts ?? [];
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 20,
            title: Text(
              'ตะกร้าสินค้า',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: carts.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: Text(
                              'ไม่มีสินค้าในตะกร้า',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: carts.length,
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemBuilder: (context, index) {
                            final cart = carts[index];
                            String imageURL = baseUrlStatic +
                                cart.product.model.picture
                                    .replaceAll('\\', '/');
                            return ListTile(
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
                              title: Text(cart.product.name,
                                  style: Theme.of(context).textTheme.bodyText2),
                              subtitle: Text("฿${cart.product.price}",
                                  style: Theme.of(context).textTheme.headline4),
                              trailing: IconButton(
                                onPressed: () {
                                  cartCubit.removeFromCart(
                                      productId: cart.productId);
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: carts.isEmpty
              ? null
              : Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 15,
                    bottom: 10,
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'รวมทั้งหมด ',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          '฿${cartCubit.getTotalPrice()}',
                          style:
                              Theme.of(context).textTheme.headline2?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('ชำระเงิน'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
