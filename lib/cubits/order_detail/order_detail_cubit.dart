import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit() : super(OrderDetailInitial());

  final orderRepository = OrderRepository();

  Future<void> getOrderDetail(int id) async {
    try {
      emit(OrderDetailLoading());
      final orderDetail = await orderRepository.getOrderById(id);
      emit(OrderDetailLoaded(orderDetail));
    } on String catch (e) {
      emit(OrderDetailFailure(e));
    }
  }
}
