import 'package:e_commerce/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepository authRepository = AuthRepository();

  Future<void> login(String email, String password) async {
    try {
      emit(LoginLoadingState());
      final token = await authRepository.login(email, password);
      emit(LoginSuccessState(token));
    } catch (e) {
      emit(LoginFailureState(e.toString()));
    }
  }
}
