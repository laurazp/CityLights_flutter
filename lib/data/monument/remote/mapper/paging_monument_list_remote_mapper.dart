import 'package:citylights/data/monument/remote/mapper/monument_remote_mapper.dart';
import 'package:citylights/data/monument/remote/model/monument_list_remote_model.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/model/monument_list.dart';

class PagingMonumentListRemoteMapper {
  static MonumentList fromRemote(MonumentListRemoteModel remoteModel) {
    MonumentList monumentList = MonumentList(
        totalCount: remoteModel.totalCount,
        result: remoteModel.result.map<Monument>((remoteItem) {
          return MonumentRemoteMapper.fromRemote(remoteItem);
        }).toList());

    return monumentList;
  }
}
