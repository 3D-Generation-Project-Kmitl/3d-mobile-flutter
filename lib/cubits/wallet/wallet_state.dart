part of 'wallet_cubit.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final Wallet wallet;

  WalletLoaded(this.wallet);
}

class WalletFailure extends WalletState {
  final String errorMessage;

  WalletFailure(this.errorMessage);
}
