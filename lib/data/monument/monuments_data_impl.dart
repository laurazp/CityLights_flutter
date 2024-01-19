import 'package:citylights/data/favorite/remote/favorites_remote_impl.dart';
import 'package:citylights/data/monument/remote/monuments_remote_impl.dart';
import 'package:citylights/domain/monuments_repository.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/model/monument_list.dart';

class MonumentsDataImpl extends MonumentsRepository {
  final MonumentsRemoteImpl _remoteApiImpl;
  final FavoritesRemoteImpl _remoteFirebaseImpl;

  MonumentsDataImpl(
      {required FavoritesRemoteImpl remoteFirebaseImpl,
      required MonumentsRemoteImpl remoteImpl})
      : _remoteApiImpl = remoteImpl,
        _remoteFirebaseImpl = remoteFirebaseImpl;

  @override
  Future<MonumentList> getMonumentList(int page) {
    return _remoteApiImpl.getMonumentList(page);
  }

  @override
  Future<List<Monument>> getMapMonumentList() {
    return _remoteApiImpl.getMonumentListForMap();
  }

  @override
  Future<Monument> getMonumentDetail(String monumentId) async {
    final remoteMonument = await _remoteApiImpl.getMonumentDetail(monumentId);
    remoteMonument.isFavorite =
        await _remoteFirebaseImpl.isFavoriteInDatabase(remoteMonument);
    return remoteMonument;
  }
}
