import 'package:citylights/model/marker_info.dart';
import 'package:citylights/presentation/view/monument/monument_detail_page.dart';
import 'package:flutter/material.dart';

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
          /*
          En este caso utilizo Navigator.push porque si no la vista del detalle no
          se refrescaba bien al intentar ir al detalle de otro monumento, si no que 
          seguía mostrando el detalle del monumento anterior.
          */
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MonumentDetailPage(
                monumentId: widget.markerInfo.monumentId,
              ),
            ),
          );
        },
        child: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance,
                  color: Colors.grey,
                  size: 20,
                ),
                Text(
                  widget.markerInfo.title.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
