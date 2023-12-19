import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      //TODO: modificar con los markers de la api
      _markers = [
        Marker(
          point: const LatLng(41.649693, -0.887712),
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Marker clicked!")));
            },
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Example"),
      ),
      body: SafeArea(
        child: FlutterMap(
          options: const MapOptions(
              initialZoom: 17, initialCenter: LatLng(41.649693, -0.887712)),
          children: [
            //TODO: Modificar con los pines
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              tileProvider: CancellableNetworkTileProvider(),
            ),
            MarkerLayer(markers: _markers)
          ],
        ),
      ),
    );
  }
}
