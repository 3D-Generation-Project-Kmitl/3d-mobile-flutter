part of 'favorite_cubit.dart';

class FavoriteState extends Equatable {
  final List<Favorite>? favorites;

  const FavoriteState({
    this.favorites,
  });

  FavoriteState copyWith({List<Favorite>? favorites}) {
    return FavoriteState(
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [favorites];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Favorite> favoriteList;

  const FavoriteLoaded(this.favoriteList);
}

class FavoriteFailure extends FavoriteState {
  final String errorMessage;

  const FavoriteFailure(this.errorMessage);
}
