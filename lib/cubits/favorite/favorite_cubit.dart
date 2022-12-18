import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  final FavoriteRepository favoriteRepository = FavoriteRepository();

  Future getFavorite() async {
    try {
      emit(FavoriteLoading());
      final favorites = await favoriteRepository.getFavorite();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteFailure(e.toString()));
    }
  }

  Future addToFavorite({required int productId}) async {
    try {
      if (state is FavoriteLoaded) {
        final List<Favorite> favorites = (state as FavoriteLoaded).favorites;
        final favorite =
            await favoriteRepository.addToFavorite(productId: productId);
        favorites.insert(0, favorite);
        emit(FavoriteLoaded(favorites));
      }
    } catch (e) {
      emit(FavoriteFailure(e.toString()));
    }
  }

  Future removeFromFavorite({required int productId}) async {
    try {
      if (state is FavoriteLoaded) {
        await favoriteRepository.removeFromFavorite(productId: productId);
        final List<Favorite> favorites = (state as FavoriteLoaded).favorites;
        favorites.removeWhere((element) => element.productId == productId);
        emit(FavoriteLoaded(favorites));
      }
    } catch (e) {
      emit(FavoriteFailure(e.toString()));
    }
  }

  bool isFavorite({required int productId}) {
    if (state is FavoriteLoaded) {
      final List<Favorite> favorites = (state as FavoriteLoaded).favorites;
      return favorites.any((favorite) => favorite.productId == productId);
    }
    return false;
  }

  Future toggleFavorite({required int productId}) async {
    if (isFavorite(productId: productId)) {
      await removeFromFavorite(productId: productId);
    } else {
      await addToFavorite(productId: productId);
    }
  }
}
