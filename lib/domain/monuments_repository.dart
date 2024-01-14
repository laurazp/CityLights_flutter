import 'package:citylights/model/monument.dart';

abstract class MonumentsRepository {
  Future<List<Monument>> getMonumentList(int page);
  Future<List<Monument>> getMapMonumentList();
  Future<Monument> getMonumentDetail(String monumentId);
}
