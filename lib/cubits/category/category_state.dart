part of 'category_cubit.dart';

// class CategoryState extends Equatable {
//   final List<Category>? categories;

//   const CategoryState({
//     this.categories,
//   });

//   CategoryState copyWith({List<Category>? categories}) {
//     return CategoryState(
//       categories: categories ?? this.categories,
//     );
//   }

//   @override
//   List<Object?> get props => [categories];
// }

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categoryList;

  CategoryLoaded({required this.categoryList});
}

class CategoryFailure extends CategoryState {
  final String message;

  CategoryFailure(this.message);
}
