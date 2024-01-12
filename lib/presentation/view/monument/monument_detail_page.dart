import 'package:cached_network_image/cached_network_image.dart';
import 'package:citylights/di/app_modules.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/presentation/model/resource_state.dart';
import 'package:citylights/presentation/view/monument/viewmodel/monuments_view_model.dart';
import 'package:citylights/presentation/widget/error/error_view.dart';
import 'package:citylights/presentation/widget/loading/loading_view.dart';
import 'package:citylights/presentation/widget/my_location_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

class MonumentDetailPage extends StatefulWidget {
  const MonumentDetailPage({super.key, required this.monumentId});

  final String monumentId;

  @override
  State<MonumentDetailPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MonumentDetailPage> {
  final MonumentsViewModel _viewModel = inject<MonumentsViewModel>();
  final MapController _mapController = MapController();
  Monument? _monument;

  @override
  void initState() {
    super.initState();

    _viewModel.getMonumentDetailState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          setState(() {
            LoadingView.show(context);
          });
          break;
        case Status.SUCCESS:
          setState(() {
            LoadingView.hide();
            _monument = state.data;
          });
          break;
        case Status.ERROR:
          debugPrint("Error: ${state.exception.toString()}");
          setState(() {
            LoadingView.hide();
            ErrorView.show(context, state.exception.toString(), () {
              _viewModel.fetchMonumentDetail(widget.monumentId);
            });
          });
          break;
      }
    });

    _viewModel.fetchMonumentDetail(widget.monumentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_monument?.title ?? '', maxLines: 2),
        ),
        body: _getContentView());
  }

  Widget _getContentView() {
    if (_monument == null) return Container();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: _monument!.image,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            "Description: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(_monument!.description),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Text(
                                "Style: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(_monument!.style.toUpperCase(),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Opening hours: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(_monument!.hours),
                          const SizedBox(height: 16),
                          const Text(
                            "Address: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(_monument!.address),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialZoom: 17,
                            initialCenter: _monument?.coords ??
                                const LatLng(41.649693, -0.887712),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              tileProvider: CancellableNetworkTileProvider(),
                            ),
                            MarkerLayer(markers: [
                              Marker(
                                point: _monument?.coords ??
                                    const LatLng(41.649693, -0.887712),
                                child: GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(_monument?.title ??
                                                "Monument")));
                                  },
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.pink,
                                    size: 40,
                                  ),
                                ),
                              )
                            ]),
                          ],
                        ),
                      ),
                    ),
                    MyLocationButton(
                        location: _monument?.coords ??
                            const LatLng(41.649693, -0.887712),
                        mapController: _mapController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
