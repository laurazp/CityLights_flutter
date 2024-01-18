import 'package:cached_network_image/cached_network_image.dart';
import 'package:citylights/model/favorite_item.dart';
import 'package:citylights/presentation/view/monument/monument_detail_page.dart';
import 'package:flutter/material.dart';

class FavoriteListRow extends StatelessWidget {
  const FavoriteListRow({super.key, required this.favorite});

  final FavoriteItem favorite;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MonumentDetailPage(
              monumentId: favorite.id ?? "",
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    placeholder: (context, url) {
                      return const Image(
                          image: AssetImage("assets/images/church_icon.jpeg"));
                    },
                    errorWidget: (context, url, error) {
                      return const Image(
                          image: AssetImage("assets/images/church_icon.jpeg"));
                    },
                    imageUrl:
                        favorite.image ?? "assets/images/church_icon.jpeg",
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(width: 16),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    favorite.title ?? "Unknown",
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
