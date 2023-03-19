import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepository authRepository = AuthRepository();

  Future<void> login(String email, String password) async {
    try {
      emit(LoginLoadingState());
      final user = await authRepository.login(email, password);
      emit(LoginSuccessState(user));
    } catch (e) {
      emit(LoginFailureState((e as ErrorModel).message));
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      emit(RegisterLoadingState());
      final user = await authRepository.register(email, password, name);
      emit(RegisterSuccessState(user));
    } catch (e) {
      emit(RegisterFailureState(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(LogoutLoadingState());
      final message = await authRepository.logout();
      emit(LogoutSuccessState(message));
    } catch (e) {
      emit(LogoutFailureState(e.toString()));
    }
  }

  Future<void> validateToken() async {
    try {
      emit(ValidateTokenLoadingState());
      final user = await authRepository.validateToken();
      emit(ValidateTokenSuccessState(user));
    } catch (e) {
      emit(ValidateTokenFailureState(e.toString()));
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      emit(ForgotPasswordLoadingState());
      final message = await authRepository.forgotPassword(email);
      emit(ForgotPasswordSuccessState(message));
    } catch (e) {
      emit(ForgotPasswordFailureState(e.toString()));
    }
  }

  Future<void> resendOTP(String email) async {
    try {
      emit(ResendOTPLoadingState());
      final message = await authRepository.resendOTP(email);
      emit(ResendOTPSuccessState(message));
    } catch (e) {
      emit(ResendOTPFailureState(e.toString()));
    }
  }

  Future<void> checkOTP(String email, String otp) async {
    try {
      emit(CheckOTPLoadingState());
      final token = await authRepository.checkOTP(email, otp);
      emit(CheckOTPSuccessState(token));
    } catch (e) {
      emit(CheckOTPFailureState(e.toString()));
    }
  }

  Future<void> verifyUser(String token) async {
    try {
      emit(VerifyUserLoadingState());
      final message = await authRepository.verifyUser(token);
      emit(VerifyUserSuccessState(message));
    } catch (e) {
      emit(VerifyUserFailureState(e.toString()));
    }
  }

  Future<void> resetPassword(String newPassword, String token) async {
    try {
      emit(ResetPasswordLoadingState());
      final message =
          await authRepository.forceUpdatePassword(newPassword, token);
      emit(ResetPasswordSuccessState(message));
    } catch (e) {
      emit(ResetPasswordFailureState(e.toString()));
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      emit(ChangePasswordLoadingState());
      final message =
          await authRepository.updatePassword(oldPassword, newPassword);
      emit(ChangePasswordSuccessState(message));
    } catch (e) {
      emit(ChangePasswordFailureState(e.toString()));
    }
  }
}
