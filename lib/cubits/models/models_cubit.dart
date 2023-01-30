import 'package:flutter_bloc/flutter_bloc.dart';
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
}