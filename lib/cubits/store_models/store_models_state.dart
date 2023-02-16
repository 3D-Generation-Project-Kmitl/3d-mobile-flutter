part of 'store_models_cubit.dart';

abstract class StoreModelsState {}

class StoreModelsInitial extends StoreModelsState {}

class StoreModelsLoading extends StoreModelsState {}

class StoreModelsLoaded extends StoreModelsState {
  final List<Model> models;
  StoreModelsLoaded(this.models);
}

class StoreModelsFailure extends StoreModelsState {
  final String errorMessage;
  StoreModelsFailure(this.errorMessage);
}
