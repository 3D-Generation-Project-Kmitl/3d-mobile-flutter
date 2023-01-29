part of 'order_detail_cubit.dart';

abstract class OrderDetailState {}

class OrderDetailInitial extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  final OrderDetail orderDetail;

  OrderDetailLoaded(this.orderDetail);
}

class OrderDetailFailure extends OrderDetailState {
  final String message;

  OrderDetailFailure(this.message);
}
