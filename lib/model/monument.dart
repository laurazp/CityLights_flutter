import 'package:latlong2/latlong.dart';

class Monument {
  String monumentId;
  String title;
  String description;
  String style;
  String address;
  String hours;
  String phone;
  String dates;
  String pois;
  String price;
  String visitInfo;
  String image;
  LatLng coords;

  Monument({
    required this.monumentId,
    required this.title,
    required this.description,
    required this.style,
    required this.address,
    required this.hours,
    required this.phone,
    required this.dates,
    required this.pois,
    required this.price,
    required this.visitInfo,
    required this.image,
    required this.coords,
  });
}
