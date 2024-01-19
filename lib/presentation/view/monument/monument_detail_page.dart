import 'package:cached_network_image/cached_network_image.dart';
import 'package:citylights/di/app_modules.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/presentation/model/resource_state.dart';
import 'package:citylights/presentation/view/favorite/favorites_provider.dart';
import 'package:citylights/presentation/view/monument/viewmodel/monuments_view_model.dart';
import 'package:citylights/presentation/widget/error/error_view.dart';
import 'package:citylights/presentation/widget/loading/loading_view.dart';
import 'package:citylights/presentation/widget/map/my_location_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MonumentDetailPage extends StatefulWidget {
  const MonumentDetailPage({super.key, required this.monumentId});

  final String monumentId;

  @override
  State<MonumentDetailPage> createState() => _MonumentDetailPageState();
}

class _MonumentDetailPageState extends State<MonumentDetailPage> {
  final MonumentsViewModel _monumentsViewModel = inject<MonumentsViewModel>();
  //final FavoritesViewModel _favoritesViewModel = inject<FavoritesViewModel>();
  final MapController _mapController = MapController();

  Monument? _monument;
  //late bool _isFavorite;

  @override
  void initState() {
    super.initState();

    //_isFavorite = false;

    _monumentsViewModel.getMonumentDetailState.stream.listen((state) {
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
              _monumentsViewModel.fetchMonumentDetail(widget.monumentId);
            });
          });
          break;
      }
    });

    _monumentsViewModel.fetchMonumentDetail(widget.monumentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            _monument?.title ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: _getContentView());
  }

  Widget _getContentView() {
    final provider = Provider.of<FavoritesProvider>(context, listen: false);

    if (_monument == null) return Container();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Column(
                  children: [
                    Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          placeholder: (context, url) {
                            return const Image(
                                image: AssetImage(
                                    "assets/images/church_icon.jpeg"));
                          },
                          errorWidget: (context, url, error) {
                            return const Image(
                                image: AssetImage(
                                    "assets/images/church_icon.jpeg"));
                          },
                          imageUrl: _monument!.image,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 16.0,
                        right: 16.0,
                        child: FloatingActionButton(
                          //backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: () {
                            //_addToFavorites
                            setState(() {
                              if (!_monument!.isFavorite) {
                                _monument!.isFavorite = true;
                                provider.addToFavorites(_monument!);
                                provider.getFavorites();
                                //Provider.of<FavoritesProvider>(context, listen: false).addToFavorites(_monument!);
                              } else {
                                _monument!.isFavorite = false;
                                provider.deleteFromFavorites(_monument!);
                                provider.getFavorites();
                                //Provider.of<FavoritesProvider>(context, listen: false).deleteFromFavorites(_monument!);
                              }
                            });
                          },
                          child: _monument!.isFavorite
                              ? const Icon(Icons.favorite, color: Colors.red)
                              : const Icon(Icons.favorite_border),
                        ),
                      ),
                    ]),
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
                          const Text(
                            "Style: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _monument!.style.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
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
                                                "Unknown Monument")));
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

  /*_addToFavorites() async {
    setState(() {
      if (!_monument!.isFavorite) {
        _monument!.isFavorite = true;
        _favoritesViewModel.addMonumentToFavorites(_monument!);
      } else {
        _deleteFromFavorites();
      }
    });
  }

  _deleteFromFavorites() async {
    setState(() {
      _monument!.isFavorite = false;
      _favoritesViewModel.deleteMonumentFromFavorites(_monument!);
    });
  }*/

  @override
  void dispose() {
    _monumentsViewModel.dispose();
    super.dispose();
  }
}
