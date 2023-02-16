import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  final orderRepository = OrderRepository();

  Future<void> getOrders() async {
    try {
      emit(OrdersLoading());
      final orders = await orderRepository.getOrders();
      emit(OrdersLoaded(orders));
    } on String catch (e) {
      emit(OrdersFailure(e));
    }
  }
}
