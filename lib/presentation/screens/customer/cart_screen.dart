import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/presentation/widgets/rounded_image_card_widget.dart';

import '../../../configs/size_config.dart';
import '../../../cubits/cubits.dart';
import '../../../data/models/models.dart';
import '../../../routes/screens_routes.dart';
import 'package:intl/intl.dart' as intl;

import '../../helpers/helpers.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final cartCubit = context.read<CartCubit>();

    if (cartCubit.state is CartInitial) {
      cartCubit.getCart();
    }
    return BlocProvider(
      create: (context) => PaymentCubit(),
      child: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentLoaded) {
            Navigator.pushNamed(context, orderCompletedRoute);
            cartCubit.getCart();
          } else if (state is PaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          }
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return Scaffold(
                appBar: AppBar(
                  titleSpacing: 20,
                  title: Text(
                    'ตะกร้าสินค้า',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                resizeToAvoidBottomInset: false,
                body: const Center(child: CircularProgressIndicator()),
              );
            } else if (state is CartLoaded) {
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
                    child: RefreshIndicator(
                      onRefresh: () async {
                        cartCubit.getCart();
                      },
                      child: _cartList(context, state.carts),
                    ),
                  ),
                  bottomNavigationBar: state.carts.isEmpty
                      ? null
                      : _cartBottomBar(context, cartCubit.getTotalPrice()));
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

  Widget _cartList(context, List<Cart> carts) {
    if (carts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Text(
            'ไม่มีสินค้าในตะกร้า',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      );
    } else {
      return ListView.separated(
        itemCount: carts.length,
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemBuilder: (context, index) {
          final cart = carts[index];
          return ListTile(
            onTap: () {
              Navigator.pushNamed(context, productDetailRoute,
                  arguments: cart.product.productId);
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
              child: roundedImageCard(
                imageURL: cart.product.model.picture,
                radius: 10,
              ),
            ),
            title: Text(cart.product.name,
                style: Theme.of(context).textTheme.bodyText2),
            subtitle: Text(
                intl.NumberFormat.currency(
                  locale: 'th',
                  symbol: '฿',
                  decimalDigits: 0,
                ).format(cart.product.price),
                style: Theme.of(context).textTheme.headline4),
            trailing: IconButton(
              onPressed: () {
                showConfirmDialog(context,
                    title: "ลบสินค้า",
                    message:
                        "คุณต้องการลบสินค้าออกจากตะกร้าสินค้าหรือไม่ ?\nชื่อ: ${cart.product.name}",
                    onConfirm: () {
                  context
                      .read<CartCubit>()
                      .removeFromCart(productId: cart.productId);
                });
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
              splashColor: Colors.transparent,
              splashRadius: 1,
            ),
          );
        },
      );
    }
  }

  Widget _cartBottomBar(context, double totalPrice) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        return Container(
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
                  '฿$totalPrice',
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                const Spacer(),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (state is! PaymentLoading) {
                        await context.read<PaymentCubit>().getPaymentIntent();
                      }
                    },
                    child: (state is PaymentLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('ชำระเงิน')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
