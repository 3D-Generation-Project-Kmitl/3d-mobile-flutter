import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/size_config.dart';
import '../../../cubits/cubits.dart';
import '../../../data/models/models.dart';
import '../../../routes/screens_routes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final cartCubit = context.read<CartCubit>();

    if (cartCubit.state is CartInitial) {
      cartCubit.getCart();
    }
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(
            child: CircularProgressIndicator(),
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
                child: _cartList(context, state.carts),
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
                  arguments: cart.product);
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
                  image: NetworkImage(cart.product.model.picture),
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
                context
                    .read<CartCubit>()
                    .removeFromCart(productId: cart.productId);
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
                onPressed: () {},
                child: const Text('ชำระเงิน'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
