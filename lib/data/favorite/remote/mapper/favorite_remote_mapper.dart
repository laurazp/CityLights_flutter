import 'package:citylights/model/favorite_item.dart';
import 'package:citylights/model/monument.dart';

class FavoriteRemoteMapper {
  FavoriteItem toFirebase(Monument model) {
    return FavoriteItem(
      title: model.title,
      image: model.image,
      id: model.monumentId,
    );
  }
}
