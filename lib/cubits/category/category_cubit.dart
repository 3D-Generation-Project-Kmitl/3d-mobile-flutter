import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryState());

  final CategoryRepository categoryRepository = CategoryRepository();

  Future<void> getCategories() async {
    try {
      emit(CategoryLoading());
      final categories = await categoryRepository.getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void setCategories(List<Category> categories) {
    emit(state.copyWith(categories: categories));
  }

  void clearCategories() {
    emit(const CategoryState());
  }
}
