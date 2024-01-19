import 'package:citylights/data/monument/remote/mapper/monument_list_remote_mapper.dart';
import 'package:citylights/data/monument/remote/mapper/monument_remote_mapper.dart';
import 'package:citylights/data/monument/remote/mapper/paging_monument_list_remote_mapper.dart';
import 'package:citylights/data/monument/remote/model/monument_list_remote_model.dart';
import 'package:citylights/data/monument/remote/model/monument_remote_model.dart';
import 'package:citylights/data/remote/error/remote_error_mapper.dart';
import 'package:citylights/data/remote/network_client.dart';
import 'package:citylights/data/remote/network_constants.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/model/monument_list.dart';

class MonumentsRemoteImpl {
  final NetworkClient _networkClient;
  final int _rows = 50;

  MonumentsRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Future<MonumentList> getMonumentList(int page) async {
    try {
      final response = await _networkClient.dio
          .get(NetworkConstants.MONUMENT_LIST_PATH, queryParameters: {
        "start": page * _rows,
        "rows": _rows,
        "srsname": "wgs84"
      });
      final listResponse = response.data;
      return PagingMonumentListRemoteMapper.fromRemote(
          MonumentListRemoteModel.fromMap(listResponse));
    } catch (error) {
      throw RemoteErrorMapper.getException(error);
    }
  }

  Future<List<Monument>> getMonumentListForMap() async {
    try {
      final response = await _networkClient.dio.get(
          NetworkConstants.MONUMENT_LIST_PATH,
          queryParameters: {"rows": 200, "srsname": "wgs84"});
      final listResponse = response.data;
      MonumentListRemoteModel remoteModel =
          MonumentListRemoteModel.fromMap(listResponse);
      return MonumentListRemoteMapper.fromRemote(remoteModel);
    } catch (error) {
      throw RemoteErrorMapper.getException(error);
    }
  }

  Future<Monument> getMonumentDetail(String monumentId) async {
    try {
      final response = await _networkClient.dio.get(
        NetworkConstants.getMonumentDetailPath(monumentId),
        queryParameters: {"srsname": "wgs84"},
      );
      return MonumentRemoteMapper.fromRemote(MonumentRemoteModel.fromMap(response.data));
    } catch (error) {
      throw RemoteErrorMapper.getException(error);
    }
  }
}
