import 'package:citylights/data/favorite/remote/mapper/favorite_remote_mapper.dart';
import 'package:citylights/model/favorite_item.dart';
import 'package:citylights/model/monument.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesRemoteImpl {
  final FavoriteRemoteMapper _favoriteRemoteMapper = FavoriteRemoteMapper();

  Future<List<FavoriteItem>> getFavorites() async {
    FirebaseFirestore storage = FirebaseFirestore.instance;
    final data = await storage.collection("favorites").get();

    List<FavoriteItem> items =
        data.docs.map((e) => FavoriteItem.fromMap(e.data())).toList();

    return items;
  }

  addItem(Monument item) async {
    FavoriteItem favorite = _favoriteRemoteMapper.toFirebase(item);

    FirebaseFirestore storage = FirebaseFirestore.instance;
    await storage.collection("favorites").add(favorite.toMap());
  }

  removeItem(Monument item) async {
    FirebaseFirestore storage = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await storage
        .collection("favorites")
        .where('id', isEqualTo: item.monumentId)
        .get();

    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  }
}
