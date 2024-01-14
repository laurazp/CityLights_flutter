import 'package:citylights/data/monument/remote/mapper/monument_remote_mapper.dart';
import 'package:citylights/data/monument/remote/monuments_remote_impl.dart';
import 'package:citylights/domain/monuments_repository.dart';
import 'package:citylights/model/monument.dart';

class MonumentsDataImpl extends MonumentsRepository {
  final MonumentsRemoteImpl _remoteImpl;

  MonumentsDataImpl({required MonumentsRemoteImpl remoteImpl})
      : _remoteImpl = remoteImpl;

  @override
  Future<List<Monument>> getMonumentList(int offset) {
    return _remoteImpl.getMonumentList(offset);
  }

  @override
  Future<List<Monument>> getMapMonumentList() {
    return _remoteImpl.getMonumentListForMap();
  }

  @override
  Future<Monument> getMonumentDetail(String monumentId) async {
    final remoteMonument = await _remoteImpl.getMonumentDetail(monumentId);
    return MonumentRemoteMapper.fromRemote(remoteMonument);
  }
}
