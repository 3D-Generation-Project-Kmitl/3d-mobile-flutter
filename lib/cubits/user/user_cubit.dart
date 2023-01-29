import 'package:flutter_bloc/flutter_bloc.dart';
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
}
