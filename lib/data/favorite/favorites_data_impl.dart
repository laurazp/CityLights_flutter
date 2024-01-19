import 'package:citylights/data/favorite/remote/favorites_remote_impl.dart';
import 'package:citylights/domain/favorites_repository.dart';
import 'package:citylights/model/favorite_item.dart';
import 'package:citylights/model/monument.dart';

class FavoritesDataImpl extends FavoritesRepository {
  final FavoritesRemoteImpl _remoteImpl;

  FavoritesDataImpl({required FavoritesRemoteImpl remoteImpl})
      : _remoteImpl = remoteImpl;

  @override
  Future<List<FavoriteItem>> getFavoriteList() {
    return _remoteImpl.getFavorites();
  }

  @override
  addItem(Monument item) {
    return _remoteImpl.addItem(item);
  }

  @override
  removeItem(Monument item) {
    return _remoteImpl.removeItem(item);
  }

  /*@override
  isFavoriteInDatabase(Monument monument) {
    return _remoteImpl.isFavoriteInDatabase(monument);
  }*/
}
