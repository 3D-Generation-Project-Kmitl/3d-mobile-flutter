part of 'models_cubit.dart';

abstract class ModelsState {}

class ModelsInitial extends ModelsState {}

class ModelsLoading extends ModelsState {}

class ModelsLoaded extends ModelsState {
  final List<Model> models;
  ModelsLoaded(this.models);
}

class ModelsFailure extends ModelsState {
  final String errorMessage;
  ModelsFailure(this.errorMessage);
}
