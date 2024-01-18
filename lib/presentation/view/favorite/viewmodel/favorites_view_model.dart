import 'dart:async';

import 'package:citylights/domain/favorites_repository.dart';
import 'package:citylights/model/favorite_item.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/presentation/base/base_view_model.dart';
import 'package:citylights/presentation/model/resource_state.dart';

class FavoritesViewModel extends BaseViewModel {
  final FavoritesRepository _favoritesRepository;

  final StreamController<ResourceState<FavoriteItem>> getFavoriteDetailState =
      StreamController();
  final StreamController<ResourceState<List<FavoriteItem>>>
      getFavoriteListState = StreamController();

  FavoritesViewModel({required FavoritesRepository favoritesRepository})
      : _favoritesRepository = favoritesRepository;

  fetchFavoriteList() {
    getFavoriteListState.add(ResourceState.loading());

    _favoritesRepository
        .getFavoriteList()
        .then((value) => getFavoriteListState.add(ResourceState.success(value)))
        .catchError(
            (error) => getFavoriteListState.add(ResourceState.error(error)));
  }

  addMonumentToFavorites(Monument monument) async {
    await _favoritesRepository.addItem(monument);
  }

  @override
  void dispose() {
    getFavoriteListState.close();
  }

  deleteMonumentFromFavorites(Monument monument) async {
    /*if (isFavoriteInDatabase(monument)) {
      await _favoritesRepository.removeItem(monument);
    }*/

    await _favoritesRepository.removeItem(monument);
  }

  /*bool isFavoriteInDatabase(Monument monument) {
    return _favoritesRepository.isFavoriteInDatabase(monument);
  }*/
}
