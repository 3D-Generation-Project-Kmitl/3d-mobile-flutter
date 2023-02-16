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

class ForgotPasswordLoadingState extends AuthState {}

class ForgotPasswordSuccessState extends AuthState {
  final String message;

  ForgotPasswordSuccessState(this.message);
}

class ForgotPasswordFailureState extends AuthState {
  final String errorMessage;

  ForgotPasswordFailureState(this.errorMessage);
}

class CheckOTPLoadingState extends AuthState {}

class CheckOTPSuccessState extends AuthState {
  final String token;

  CheckOTPSuccessState(this.token);
}

class CheckOTPFailureState extends AuthState {
  final String errorMessage;

  CheckOTPFailureState(this.errorMessage);
}

class ResetPasswordLoadingState extends AuthState {}

class ResetPasswordSuccessState extends AuthState {
  final String message;

  ResetPasswordSuccessState(this.message);
}

class ResetPasswordFailureState extends AuthState {
  final String errorMessage;

  ResetPasswordFailureState(this.errorMessage);
}

class ResendOTPLoadingState extends AuthState {}

class ResendOTPSuccessState extends AuthState {
  final String message;

  ResendOTPSuccessState(this.message);
}

class ResendOTPFailureState extends AuthState {
  final String errorMessage;

  ResendOTPFailureState(this.errorMessage);
}

class VerifyUserLoadingState extends AuthState {}

class VerifyUserSuccessState extends AuthState {
  final String message;

  VerifyUserSuccessState(this.message);
}

class VerifyUserFailureState extends AuthState {
  final String errorMessage;

  VerifyUserFailureState(this.errorMessage);
}

class ChangePasswordLoadingState extends AuthState {}

class ChangePasswordSuccessState extends AuthState {
  final String message;

  ChangePasswordSuccessState(this.message);
}

class ChangePasswordFailureState extends AuthState {
  final String errorMessage;

  ChangePasswordFailureState(this.errorMessage);
}
