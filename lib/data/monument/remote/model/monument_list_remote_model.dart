import 'package:citylights/data/monument/remote/model/monument_remote_model.dart';

class MonumentListRemoteModel {
  int totalCount;
  int start;
  int rows;
  List<MonumentRemoteModel> result;

  MonumentListRemoteModel({
    required this.totalCount,
    required this.start,
    required this.rows,
    required this.result,
  });

  factory MonumentListRemoteModel.fromMap(Map<String, dynamic> json) =>
      MonumentListRemoteModel(
        totalCount: json["totalCount"],
        start: json["start"],
        rows: json["rows"],
        result: List<MonumentRemoteModel>.from(
            json["result"].map((x) => MonumentRemoteModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "totalCount": totalCount,
        "start": start,
        "rows": rows,
        "result": List<dynamic>.from(result.map((x) => x.toMap())),
      };
}
