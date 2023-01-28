import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../data/repositories/repository.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  final PaymentRepository paymentRepository = PaymentRepository();

  Future<void> getPaymentIntent() async {
    try {
      emit(PaymentLoading());
      final payment = await paymentRepository.getPaymentIntent();
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: payment.paymentIntent,
        merchantDisplayName: '3D Model Marketplace',
        customerId: payment.customer,
        customerEphemeralKeySecret: payment.ephemeralKey,
      ));
      await Stripe.instance.presentPaymentSheet();
      emit(PaymentLoaded());
    } catch (e) {
      if (e is StripeException) {
        emit(PaymentFailure(errorMessage: e.error.localizedMessage.toString()));
      } else {
        emit(PaymentFailure(errorMessage: e.toString()));
      }
    }
  }

  void clear() {
    emit(PaymentInitial());
  }
}
