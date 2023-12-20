import 'package:citylights/model/monument.dart';

abstract class MonumentsRepository {
  Future<List<Monument>> getMonumentList();
  Future<Monument> getMonumentDetail(String monumentId);
}
