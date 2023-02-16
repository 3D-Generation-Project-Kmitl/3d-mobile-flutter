part of 'customer_models_cubit.dart';

abstract class CustomerModelsState {}

class CustomerModelsInitial extends CustomerModelsState {}

class CustomerModelsLoading extends CustomerModelsState {}

class CustomerModelsLoaded extends CustomerModelsState {
  final List<Model> models;
  CustomerModelsLoaded(this.models);
}

class CustomerModelsFailure extends CustomerModelsState {
  final String errorMessage;
  CustomerModelsFailure(this.errorMessage);
}
