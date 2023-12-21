import 'package:citylights/data/monument/remote/mapper/monument_remote_mapper.dart';
import 'package:citylights/data/monument/remote/model/monument_list_remote_model.dart';
import 'package:citylights/model/monument.dart';

class MonumentListRemoteMapper {
  static List<Monument> fromRemote(MonumentListRemoteModel remoteModel) {
    List<Monument> monuments = remoteModel.result.map<Monument>((remoteItem) {
      return MonumentRemoteMapper.fromRemote(remoteItem);
    }).toList();

    return monuments;
  }
}
