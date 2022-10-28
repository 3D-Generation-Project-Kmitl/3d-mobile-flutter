import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  void getUser(User user) {
    emit(state.copyWith(user: user));
  }

  void clearUser() {
    emit(const UserState());
  }
}
