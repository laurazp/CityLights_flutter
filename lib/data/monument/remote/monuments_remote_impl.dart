import 'package:citylights/data/monument/remote/mapper/monument_list_remote_mapper.dart';
import 'package:citylights/data/monument/remote/model/monument_list_remote_model.dart';
import 'package:citylights/data/monument/remote/model/monument_remote_model.dart';
import 'package:citylights/data/remote/error/remote_error_mapper.dart';
import 'package:citylights/data/remote/network_client.dart';
import 'package:citylights/data/remote/network_constants.dart';
import 'package:citylights/model/monument.dart';

class MonumentsRemoteImpl {
  final NetworkClient _networkClient;

  MonumentsRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Future<List<Monument>> getMonumentList() async {
    try {
      final response = await _networkClient.dio.get(
          NetworkConstants.MONUMENT_LIST_PATH,
          queryParameters: {"rows": 100, "srsname": "wgs84"});
      final listResponse = response.data;
      MonumentListRemoteModel remoteModel =
          MonumentListRemoteModel.fromMap(listResponse);
      return MonumentListRemoteMapper.fromRemote(remoteModel);
    } catch (error) {
      throw RemoteErrorMapper.getException(error);
    }
  }

  Future<MonumentRemoteModel> getMonumentDetail(String monumentId) async {
    try {
      final response = await _networkClient.dio.get(
        NetworkConstants.getMonumentDetailPath(monumentId),
        queryParameters: {"srsname": "wgs84"},
      );
      return MonumentRemoteModel.fromMap(response.data);
    } catch (error) {
      throw RemoteErrorMapper.getException(error);
    }
  }
}
