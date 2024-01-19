// ignore_for_file: unused_element

import 'package:citylights/di/app_modules.dart';
import 'package:citylights/model/favorite_item.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/presentation/view/favorite/viewmodel/favorites_view_model.dart';
import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  int count = 0;
  List<FavoriteItem> monuments = [];

  final FavoritesViewModel _favoritesViewModel = inject<FavoritesViewModel>();

  addToFavorites(Monument monument) async {
    _favoritesViewModel.addMonumentToFavorites(monument);
    notifyListeners();
  }

  deleteFromFavorites(Monument monument) async {
    _favoritesViewModel.deleteMonumentFromFavorites(monument);
    notifyListeners();
  }

  getFavorites() async {
    _favoritesViewModel.fetchFavoriteList();
    notifyListeners();
  }

  addFavorites(List<FavoriteItem> favorites) {
    monuments = favorites;
    notifyListeners();
  }
}
