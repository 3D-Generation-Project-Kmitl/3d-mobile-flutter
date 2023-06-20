import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'customer_models_state.dart';

class CustomerModelsCubit extends Cubit<CustomerModelsState> {
  CustomerModelsCubit() : super(CustomerModelsInitial());

  final ModelRepository modelRepository = ModelRepository();

  Future<void> getModelsCustomer() async {
    try {
      emit(CustomerModelsLoading());
      final models = await modelRepository.getModelsCustomer();
      emit(CustomerModelsLoaded(models));
    } on String catch (e) {
      emit(CustomerModelsFailure(e));
    }
  }

  Future<void> deleteModel(int modelId) async {
    try {
      if (state is CustomerModelsLoaded) {
        final models = (state as CustomerModelsLoaded).models;
        await modelRepository.deleteModel(modelId);
        models.removeWhere((element) => element.modelId == modelId);
        emit(CustomerModelsLoaded(models));
      }
    } on String catch (e) {
      emit(CustomerModelsFailure(e));
    }
  }
}
