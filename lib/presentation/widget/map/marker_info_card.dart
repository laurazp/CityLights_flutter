import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MarkerInfoCard extends StatefulWidget {
  const MarkerInfoCard({super.key, required this.marker});

  final Marker marker;

  @override
  State<MarkerInfoCard> createState() => _MarkerInfoCardState();
}

class _MarkerInfoCardState extends State<MarkerInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          /*context.go(NavigationRoutes.MONUMENT_DETAIL_ROUTE,
              extra: monument.monumentId);*/
        },
        child: SizedBox(
            height: 50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Text(widget.marker.point.toString()),
                ],
              ),
            )),
      ),
    );
  }
}
