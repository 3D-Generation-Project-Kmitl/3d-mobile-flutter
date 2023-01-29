import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final CategoryRepository categoryRepository = CategoryRepository();

  Future<void> getCategories() async {
    try {
      emit(CategoryLoading());
      final categories = await categoryRepository.getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }
}
