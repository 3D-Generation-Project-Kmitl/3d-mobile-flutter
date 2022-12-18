import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void setUser(User user) {
    emit(UserLoaded(user));
  }

  void clearUser() {
    emit(UserInitial());
  }

  // void setUser(User user) {
  //   emit(state.copyWith(user: user));
  // }

  // void clearUser() {
  //   emit(const UserState());
  // }
}
