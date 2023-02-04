import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'identity_state.dart';

class IdentityCubit extends Cubit<IdentityState> {
  IdentityCubit() : super(IdentityInitial());

  final IdentityRepository identityRepository = IdentityRepository();

  Future<void> getIdentity() async {
    try {
      emit(IdentityLoading());
      final identity = await identityRepository.getIdentity();
      emit(IdentityLoaded(identity: identity));
    } catch (e) {
      emit(IdentityFailure(errorMessage: e.toString()));
    }
  }

  Future<void> createIdentity(
      {required String firstName,
      required String lastName,
      required String phone,
      required String idCardNumber,
      required XFile cardPicture,
      required XFile cardFacePicture,
      required String bankName,
      required String bankAccount}) async {
    try {
      emit(IdentityLoading());
      final formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'idCardNumber': idCardNumber,
        'cardPicture': await MultipartFile.fromFile(cardPicture.path,
            filename: cardPicture.name),
        'cardFacePicture': await MultipartFile.fromFile(cardFacePicture.path,
            filename: cardFacePicture.name),
        'bankName': bankName,
        'bankAccount': bankAccount,
      });
      final identity = await identityRepository.createIdentity(formData);
      emit(IdentityLoaded(identity: identity));
    } catch (e) {
      emit(IdentityFailure(errorMessage: e.toString()));
    }
  }

  Future<void> updateIdentity(
      {required String firstName,
      required String lastName,
      required String phone,
      required String idCardNumber,
      required XFile cardPicture,
      required XFile cardFacePicture,
      required String bankName,
      required String bankAccount}) async {
    try {
      emit(IdentityLoading());
      final formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'idCardNumber': idCardNumber,
        'cardPicture': await MultipartFile.fromFile(cardPicture.path,
            filename: cardPicture.name),
        'cardFacePicture': await MultipartFile.fromFile(cardFacePicture.path,
            filename: cardFacePicture.name),
        'bankName': bankName,
        'bankAccount': bankAccount,
      });
      final identity = await identityRepository.updateIdentity(formData);
      emit(IdentityLoaded(identity: identity));
    } catch (e) {
      emit(IdentityFailure(errorMessage: e.toString()));
    }
  }
}
