import 'package:flutter/material.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../data/models/models.dart';

class OrderDetailScreen extends StatelessWidget {
  final int orderId;
  const OrderDetailScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderDetailCubit(),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20,
          title: Text("คำสั่งซื้อของฉัน",
              style: Theme.of(context).textTheme.headline2),
        ),
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<OrderDetailCubit, OrderDetailState>(
          builder: (context, state) {
            if (state is OrderDetailInitial) {
              context.read<OrderDetailCubit>().getOrderDetail(orderId);
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OrderDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OrderDetailLoaded) {
              return Column(
                children: [
                  Expanded(
                    child:
                        _productList(context, state.orderDetail.orderProduct),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("วันที่สั่งซื้อ: ",
                                style: Theme.of(context).textTheme.bodyText1),
                            Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(state.orderDetail.createdAt),
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("เวลา: ",
                                style: Theme.of(context).textTheme.bodyText1),
                            Text(
                                DateFormat('HH:mm')
                                    .format(state.orderDetail.createdAt),
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("รวม",
                                style: Theme.of(context).textTheme.headline3),
                            Text(
                                "${state.orderDetail.totalPrice.toString()} บาท",
                                style: Theme.of(context).textTheme.headline2),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
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

  Widget _productList(context, List<OrderProduct> orderProducts) {
    return ListView.separated(
      itemCount: orderProducts.length,
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        final orderProduct = orderProducts[index];
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
                image: orderProduct.product.model.picture != null
                    ? NetworkImage(orderProduct.product.model.picture!)
                    : const AssetImage('assets/images/placeholder3d.jpg')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(orderProduct.product.name,
              style: Theme.of(context).textTheme.bodyText2),
          subtitle: Text("฿${orderProduct.product.price}",
              style: Theme.of(context).textTheme.headline4),
        );
      },
    );
  }
}
