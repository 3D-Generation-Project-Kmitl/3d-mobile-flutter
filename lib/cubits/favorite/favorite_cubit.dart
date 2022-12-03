import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(const FavoriteState());

  final FavoriteRepository favoriteRepository = FavoriteRepository();

  void setFavorite(List<Favorite> favorites) {
    emit(state.copyWith(favorites: favorites));
  }

  Future<void> getFavorite() async {
    try {
      emit(FavoriteLoading());
      final favorites = await favoriteRepository.getFavorite();
      emit(FavoriteLoaded(favorites));
      //setFavorite(favorites);
    } catch (e) {
      emit(FavoriteFailure(e.toString()));
    }
  }

  Future<bool> addToFavorite({required int productId}) async {
    try {
      final favorite =
          await favoriteRepository.addToFavorite(productId: productId);
      final List<Favorite> favorites = state.favorites ?? [];
      favorites.insert(0, favorite);
      //setFavorite(favorites);
      emit(FavoriteLoaded(favorites));
      return true;
    } catch (e) {
      emit(FavoriteFailure(e.toString()));
      return false;
    }
  }

  Future<void> removeFromFavorite({required int productId}) async {
    try {
      await favoriteRepository.removeFromFavorite(productId: productId);
      final List<Favorite> favorites = state.favorites ?? [];
      favorites.removeWhere((element) => element.productId == productId);
      //emit(FavoriteState(favorites: favorites));
      emit(FavoriteLoaded(favorites));
      //setFavorite(favorites);
    } catch (e) {
      emit(FavoriteFailure(e.toString()));
    }
  }
}
