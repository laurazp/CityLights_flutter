import 'package:citylights/model/favorite_item.dart';
import 'package:citylights/model/monument.dart';

abstract class FavoritesRepository {
  Future<List<FavoriteItem>> getFavoriteList();
  addItem(Monument item);
  removeItem(Monument item);
  isFavoriteInDatabase(Monument monument);
}
