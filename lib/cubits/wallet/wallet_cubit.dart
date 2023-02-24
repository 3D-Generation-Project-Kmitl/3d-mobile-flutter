import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  final walletRepository = WalletRepository();

  Future<void> getWallet() async {
    try {
      emit(WalletLoading());
      final wallet = await walletRepository.getWallet();
      emit(WalletLoaded(wallet));
    } on String catch (e) {
      emit(WalletFailure(e));
    }
  }

  Future<void> withdraw({required int amount}) async {
    try {
      if (state is WalletLoaded) {
        final wallet = (state as WalletLoaded).wallet;
        final walletTransaction =
            await walletRepository.withdraw(amount: amount);
        wallet.balance -= walletTransaction.amountMoney;
        wallet.walletTransactions.insert(0, walletTransaction);
        emit(WalletLoaded(wallet));
      }
    } on String catch (e) {
      emit(WalletFailure(e));
    }
  }
}
