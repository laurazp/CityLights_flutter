import 'package:citylights/model/favorite_item.dart';
import 'package:citylights/model/monument.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteItem>> getFavoriteList();
  //Future<FavoriteItem> getFavoriteDetail(String monumentId);
  addItem(Monument item);
}
