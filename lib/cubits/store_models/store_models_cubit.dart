import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'store_models_state.dart';

class StoreModelsCubit extends Cubit<StoreModelsState> {
  StoreModelsCubit() : super(StoreModelsInitial());

  final ModelRepository modelRepository = ModelRepository();

  Future<void> getModelsStore() async {
    try {
      emit(StoreModelsLoading());
      final models = await modelRepository.getModelsStore();
      emit(StoreModelsLoaded(models));
    } on String catch (e) {
      emit(StoreModelsFailure(e));
    }
  }

  Future<void> addModel(PlatformFile file) async {
    try {
      if (state is StoreModelsLoaded) {
        final List<Model> models = (state as StoreModelsLoaded).models;
        emit(StoreModelsLoading());
        final formData = FormData.fromMap({
          'type': 'ADD',
          'model':
              await MultipartFile.fromFile(file.path!, filename: file.name),
        });
        final model = await modelRepository.createModel(formData);
        models.insert(0, model);
        emit(StoreModelsLoaded(models));
      }
    } on String catch (e) {
      emit(StoreModelsFailure(e));
    }
  }

  Future<void> updateModel(File file, int modelId) async {
    try {
      if (state is StoreModelsLoaded) {
        final List<Model> models = (state as StoreModelsLoaded).models;
        emit(StoreModelsLoading());
        final formData = FormData.fromMap({
          'picture': await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        });
        final model = await modelRepository.updateModel(modelId, formData);
        models.firstWhere((element) => element.modelId == modelId).picture =
            model.picture;
        emit(StoreModelsLoaded(models));
      }
    } on String catch (e) {
      emit(StoreModelsFailure(e));
    }
  }

  void removeModel(int modelId) async {
    try {
      if (state is StoreModelsLoaded) {
        final List<Model> models = (state as StoreModelsLoaded).models;
        models.removeWhere((element) => element.modelId == modelId);
        emit(StoreModelsLoaded(models));
      }
    } on String catch (e) {
      emit(StoreModelsFailure(e));
    }
  }
}
