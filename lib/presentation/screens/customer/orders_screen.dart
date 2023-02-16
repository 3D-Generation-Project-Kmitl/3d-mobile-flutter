import 'package:flutter/material.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/routes/screens_routes.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20,
          title: Text("คำสั่งซื้อของฉัน",
              style: Theme.of(context).textTheme.headline2),
        ),
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersInitial) {
              context.read<OrdersCubit>().getOrders();
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OrdersLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return Center(
                  child: Text(
                    "ไม่มีข้อมูล",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, orderDetailRoute,
                            arguments: state.orders[index].orderId);
                      },
                      title: Text(
                          "หมายเลขคำสั่งซื้อ ${state.orders[index].orderId.toString()}"),
                      subtitle: Text(
                          "จำนวน ${state.orders[index].count.orderProduct.toString()} รายการ"),
                      trailing: Text(
                          "จำนวนเงิน ${state.orders[index].totalPrice.toString()} บาท"),
                    ),
                  );
                },
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
}
