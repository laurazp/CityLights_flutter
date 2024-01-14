import 'package:citylights/model/monument.dart';
import 'package:citylights/model/monument_list.dart';

abstract class MonumentsRepository {
  Future<MonumentList> getMonumentList(int page);
  Future<List<Monument>> getMapMonumentList();
  Future<Monument> getMonumentDetail(String monumentId);
}
