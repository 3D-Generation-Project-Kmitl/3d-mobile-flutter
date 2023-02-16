part of 'identity_cubit.dart';

abstract class IdentityState {}

class IdentityInitial extends IdentityState {}

class IdentityLoading extends IdentityState {}

class IdentityLoaded extends IdentityState {
  final Identity? identity;

  IdentityLoaded({required this.identity});
}

class IdentityFailure extends IdentityState {
  final String errorMessage;

  IdentityFailure({required this.errorMessage});
}
