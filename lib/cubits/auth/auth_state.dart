part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class LoginSuccessState extends AuthState {
  final User user;

  LoginSuccessState(this.user);
}

class LoginLoadingState extends AuthState {}

class LoginFailureState extends AuthState {
  final String errorMessage;

  LoginFailureState(this.errorMessage);
}

class RegisterSuccessState extends AuthState {
  final User user;

  RegisterSuccessState(this.user);
}

class RegisterLoadingState extends AuthState {}

class RegisterFailureState extends AuthState {
  final String errorMessage;

  RegisterFailureState(this.errorMessage);
}

class LogoutSuccessState extends AuthState {
  final String message;

  LogoutSuccessState(this.message);
}

class LogoutLoadingState extends AuthState {}

class LogoutFailureState extends AuthState {
  final String errorMessage;

  LogoutFailureState(this.errorMessage);
}

class ValidateTokenSuccessState extends AuthState {
  final User user;

  ValidateTokenSuccessState(this.user);
}

class ValidateTokenLoadingState extends AuthState {}

class ValidateTokenFailureState extends AuthState {
  final String errorMessage;

  ValidateTokenFailureState(this.errorMessage);
}
