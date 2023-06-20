import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final userRepository = UserRepository();

  void setUser(User user) {
    emit(UserLoaded(user));
  }

  bool isChanged({
    String? name,
    String? gender,
    String? dateOfBirth,
    XFile? image,
  }) {
    if (state is UserLoaded) {
      final user = (state as UserLoaded).user;
      if (user.name != name) {
        return true;
      }
      if (image != null) {
        return true;
      }
      if (user.gender != gender) {
        return true;
      }
      if (dateOfBirth != "") {
        if (user.dateOfBirth == null) return true;
        if (DateFormat('yyyy-MM-dd').format(user.dateOfBirth!) != dateOfBirth) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  Future<void> updateUser({
    required int userId,
    String? name,
    String? gender,
    String? dateOfBirth,
    XFile? image,
  }) async {
    try {
      emit(UserLoading());
      FormData formData = FormData();

      if (name != '' && name != null) {
        formData.fields.add(MapEntry('name', name));
      }
      if (gender != '' && gender != null) {
        formData.fields.add(MapEntry('gender', gender));
      }
      if (dateOfBirth != '' && dateOfBirth != null) {
        formData.fields.add(MapEntry('dateOfBirth',
            '${DateFormat('yyyy-MM-dd').parse(dateOfBirth).toIso8601String()}Z'));
      }
      if (image != null) {
        formData.files.add(MapEntry(
          'picture',
          await MultipartFile.fromFile(
            image.path,
            filename: image.name,
          ),
        ));
      }
      final updatedUser = await userRepository.updateUser(formData);
      emit(UserLoaded(updatedUser));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  void clearUser() {
    emit(UserInitial());
  }
}
