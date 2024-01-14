import 'package:cached_network_image/cached_network_image.dart';
import 'package:citylights/model/monument.dart';
import 'package:citylights/presentation/navigation/navigation_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MonumentListRow extends StatelessWidget {
  const MonumentListRow({super.key, required this.monument});

  final Monument monument;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(NavigationRoutes.MONUMENT_DETAIL_ROUTE,
            extra: monument.monumentId);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Card(
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    placeholder: (context, url) {
                      //TODO: es url o string del asset?
                      return const Image(
                          image: AssetImage("assets/images/church_icon.jpeg"));
                    },
                    errorWidget: (context, url, error) {
                      return const Image(
                          image: AssetImage("assets/images/church_icon.jpeg"));
                    },
                    imageUrl: monument.image,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  monument.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
