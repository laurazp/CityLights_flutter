import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> _markers = [];
  final LatLng _currentMapLocation = const LatLng(41.649693, -0.887712);
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();

    setState(() {
      //TODO: modificar con los markers de la api y la location del user
      _markers = [
        Marker(
          point: _currentMapLocation,
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
        title: const Text("Map"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialZoom: 17,
                initialCenter: LatLng(41.649693, -0.887712),
              ),
              children: [
                //TODO: Modificar con los pines
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  tileProvider: CancellableNetworkTileProvider(),
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: _moveToCurrentLocation,
                child: const Icon(Icons.my_location_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _moveToCurrentLocation() async {
    PermissionStatus permissionStatus = await Permission.location.status;
    print(permissionStatus);

    if (permissionStatus != PermissionStatus.granted) {
      permissionStatus = await Permission.location.request();
    }

    if (permissionStatus != PermissionStatus.granted) {
      return;
    }

    loc.LocationData location = await loc.Location().getLocation();

    setState(() {
      //TODO: probar controller. animate()
      _mapController.move(
          LatLng(location.latitude ?? 0, location.longitude ?? 0), 17);
    });
  }
}
