part of 'favorite_cubit.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Favorite> favorites;

  FavoriteLoaded(this.favorites);
}

class FavoriteFailure extends FavoriteState {
  final String errorMessage;

  FavoriteFailure(this.errorMessage);
}
