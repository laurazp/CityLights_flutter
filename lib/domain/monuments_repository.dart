import 'package:citylights/model/monument.dart';

abstract class MonumentsRepository {
  Future<List<Monument>> getMonumentList(int offset);
  Future<List<Monument>> getMapMonumentList();
  Future<Monument> getMonumentDetail(String monumentId);
}