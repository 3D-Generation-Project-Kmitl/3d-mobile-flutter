import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'models_state.dart';

class ModelsCubit extends Cubit<ModelsState> {
  ModelsCubit() : super(ModelsInitial());

  final ModelRepository modelRepository = ModelRepository();

  Future<void> getModelsCustomer() async {
    try {
      emit(ModelsLoading());
      final models = await modelRepository.getModelsCustomer();
      emit(ModelsLoaded(models));
    } on String catch (e) {
      emit(ModelsFailure(e));
    }
  }

  Future<void> getModelsStore() async {
    try {
      emit(ModelsLoading());
      final models = await modelRepository.getModelsStore();
      emit(ModelsLoaded(models));
    } on String catch (e) {
      emit(ModelsFailure(e));
    }
  }

  Future<void> addModel(PlatformFile file) async {
    try {
      if (state is ModelsLoaded) {
        final List<Model> models = (state as ModelsLoaded).models;
        emit(ModelsLoading());
        final formData = FormData.fromMap({
          'type': 'ADD',
          'model':
              await MultipartFile.fromFile(file.path!, filename: file.name),
        });
        final model = await modelRepository.createModel(formData);
        models.insert(0, model);
        emit(ModelsLoaded(models));
      }
    } on String catch (e) {
      emit(ModelsFailure(e));
    }
  }

  Future<void> updateModel(File file, int modelId) async {
    try {
      if (state is ModelsLoaded) {
        final List<Model> models = (state as ModelsLoaded).models;
        emit(ModelsLoading());
        final formData = FormData.fromMap({
          'picture': await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        });
        final model = await modelRepository.updateModel(modelId, formData);
        models.firstWhere((element) => element.modelId == modelId).picture =
            model.picture;
        emit(ModelsLoaded(models));
      }
    } on String catch (e) {
      emit(ModelsFailure(e));
    }
  }
}
