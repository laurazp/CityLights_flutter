class FavoriteItem {
  String? title;
  String? image;
  String? id;

  FavoriteItem({
    required this.title,
    this.image,
    required this.id,
  });

  factory FavoriteItem.fromMap(Map<String, dynamic> json) => FavoriteItem(
        title: json["title"],
        image: json["image"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "image": image,
        "id": id,
      };
}
