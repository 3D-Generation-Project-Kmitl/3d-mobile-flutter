import 'package:marketplace/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user_model.dart';

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
      emit(LoginFailureState(e.toString()));
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
}
