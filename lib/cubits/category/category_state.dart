part of 'category_cubit.dart';

class CategoryState extends Equatable {
  final List<Category>? categories;

  const CategoryState({
    this.categories,
  });

  CategoryState copyWith({List<Category>? categories}) {
    return CategoryState(
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [categories];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryLoaded({required this.categories});
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);
}
