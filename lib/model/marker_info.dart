import 'package:flutter_map/flutter_map.dart';

class MarkerInfo {
  String title;
  Marker marker;
  String monumentId;

  MarkerInfo(
      {required this.title, required this.marker, required this.monumentId});
}
