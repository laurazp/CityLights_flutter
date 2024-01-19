import 'package:citylights/di/app_modules.dart';
import 'package:citylights/model/marker_info.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/presentation/model/resource_state.dart';
import 'package:citylights/presentation/view/monument/viewmodel/monuments_view_model.dart';
import 'package:citylights/presentation/widget/error/error_view.dart';
import 'package:citylights/presentation/widget/loading/loading_view.dart';
import 'package:citylights/presentation/widget/map/marker_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MonumentsViewModel _monumentsViewModel = inject<MonumentsViewModel>();
  List<MarkerInfo> _markers = [];
  List<Monument> _monuments = [];
  bool _isLocationEnabled = false;

/* He decidido centrar el mapa en el centro de Zaragoza al cargar la MapPage,
para que, si el usuario no otorga permisos de ubicación, se vean los monumentos 
que hay en el centro de Zaragoza. Y si el usuario quiere ver los monumentos que 
se encuentran alrededor de su localización, puede otorgar permisos y hacer 
click en el botón de centrar mapa en tu ubicación y ya podría ver qué monumentos 
se encuentran a su alrededor */
  final LatLng _initialLocation = const LatLng(41.6559095, -0.876660635);
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();

    _monumentsViewModel.getMapMonumentListState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          setState(() {
            LoadingView.show(context);
          });
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _monuments = state.data!;
            _markers = _addMarkers(_monuments);
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _monumentsViewModel.fetchMapMonumentList();
          });
          break;
      }
    });

    setState(() {
      _monumentsViewModel.fetchMapMonumentList();
    });

    checkPermissions();
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
            SizedBox(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialZoom: 17,
                  initialCenter: _initialLocation,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    tileProvider: CancellableNetworkTileProvider(),
                  ),
                  PopupMarkerLayer(
                    options: PopupMarkerLayerOptions(
                      markers: _markers
                          .map((markerInfo) => markerInfo.marker)
                          .toList(),
                      popupDisplayOptions: PopupDisplayOptions(
                        builder: (BuildContext context, Marker marker) =>
                            MarkerInfoCard(
                                markerInfo: _markers.firstWhere((markerInfo) =>
                                    markerInfo.marker == marker)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: _isLocationEnabled ? _moveToCurrentLocation : null,
                child: const Icon(Icons.my_location_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<MarkerInfo> _addMarkers(List<Monument> monuments) {
    for (Monument monument in monuments) {
      Marker marker = Marker(
        point: LatLng(monument.coords.latitude, monument.coords.longitude),
        child: const Icon(
          Icons.location_on,
          color: Colors.pink,
          size: 40,
        ),
      );

      MarkerInfo markerInfo = MarkerInfo(
          title: monument.title,
          marker: marker,
          monumentId: monument.monumentId);

      _markers.add(markerInfo);
    }

    setState(() {});
    return _markers;
  }

  _moveToCurrentLocation() async {
    PermissionStatus permissionStatus = await Permission.location.status;

    if (permissionStatus != PermissionStatus.granted) {
      permissionStatus = await Permission.location.request();
    }

    if (permissionStatus != PermissionStatus.granted) {
      return;
    }

    loc.LocationData location = await loc.Location().getLocation();

    setState(() {
      _centerMap(LatLng(location.latitude ?? _initialLocation.latitude,
          location.longitude ?? _initialLocation.longitude));
    });
  }

  Future<void> checkPermissions() async {
    PermissionStatus permissionStatus = await Permission.location.status;

    if (permissionStatus != PermissionStatus.granted) {
      if (!await isLocationDialogShown()) {
        permissionStatus = await Permission.location.request();
      }
    }

    if (permissionStatus != PermissionStatus.granted) {
      disabledLocationMapButton();
      _centerMap(_initialLocation);
      return;
    }

    _enableLocationMapButton();
    loc.LocationData location = await loc.Location().getLocation();
    _centerMap(LatLng(location.latitude!, location.longitude!));
  }

  _enableLocationMapButton() {
    setState(() {
      _isLocationEnabled = true;
    });
  }

  disabledLocationMapButton() {
    setState(() {
      _isLocationEnabled = false;
    });
  }

  _centerMap(LatLng location, {double zoom = 17.0}) {
    _mapController.move(LatLng(location.latitude, location.longitude), zoom);
  }

  Future<bool> isLocationDialogShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('location_dialog_shown') ?? false;
  }

  Future<void> setLocationDialogShown() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('location_dialog_shown', true);
  }
}
