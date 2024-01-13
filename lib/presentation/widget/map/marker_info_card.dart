import 'package:citylights/model/marker_info.dart';
import 'package:citylights/presentation/navigation/navigation_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MarkerInfoCard extends StatefulWidget {
  const MarkerInfoCard({super.key, required this.markerInfo});

  final MarkerInfo markerInfo;

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
          //TODO: revisar por qué va al mismo
          context.go(NavigationRoutes.MONUMENT_DETAIL_ROUTE,
              extra: widget.markerInfo.monumentId);
        },
        child: SizedBox(
            height: 50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Text(widget.markerInfo.title.toString()),
                ],
              ),
            )),
      ),
    );
  }
}
