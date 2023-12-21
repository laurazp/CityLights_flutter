class MonumentRemoteModel {
  int id;
  String? title;
  String? description;
  String? estilo;
  String? address;
  String? horario;
  String? phone;
  String? datacion;
  String? pois;
  String? price;
  String? visita;
  String? image;
  Geometry? geometry;

  MonumentRemoteModel({
    required this.id,
    required this.title,
    required this.description,
    this.estilo,
    this.address,
    this.horario,
    this.phone,
    this.datacion,
    this.pois,
    this.price,
    this.visita,
    this.image,
    this.geometry,
  });

  factory MonumentRemoteModel.fromMap(Map<String, dynamic> json) =>
      MonumentRemoteModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        estilo: json["estilo"],
        address: json["address"],
        horario: json["horario"],
        phone: json["phone"],
        datacion: json["datacion"],
        pois: json["pois"],
        price: json["price"],
        visita: json["visita"],
        image: json["image"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromMap(json["geometry"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "estilo": estilo,
        "address": address,
        "horario": horario,
        "phone": phone,
        "datacion": datacion,
        "pois": pois,
        "price": price,
        "visita": visita,
        "image": image,
        "geometry": geometry?.toMap(),
      };
}

class Geometry {
  List<double> coordinates;

  Geometry({
    required this.coordinates,
  });

  factory Geometry.fromMap(Map<String, dynamic> json) => Geometry(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}
