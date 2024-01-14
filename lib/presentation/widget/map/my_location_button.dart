import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MyLocationButton extends StatelessWidget {
  const MyLocationButton(
      {super.key, required this.location, required this.mapController});

  final LatLng location;
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 16,
        right: 16,
        child: GestureDetector(
          child: const Icon(Icons.my_location, color: Colors.black),
          onTap: () {
            mapController.move(location, 17.0);
          },
        ));
  }
}
