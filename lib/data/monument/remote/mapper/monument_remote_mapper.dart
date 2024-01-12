import 'package:citylights/data/monument/remote/model/monument_remote_model.dart';
import 'package:citylights/model/monument.dart';
import 'package:latlong2/latlong.dart';

class MonumentRemoteMapper {
  static Monument fromRemote(MonumentRemoteModel remoteModel) {
    return Monument(
      monumentId: remoteModel.id.toString(),
      title: remoteModel.title ?? "Unknown",
      description: remoteModel.description ?? "",
      style: remoteModel.estilo ?? "Unknown",
      address: remoteModel.address ?? "Address unknown",
      hours: remoteModel.horario ?? "Unknown",
      phone: remoteModel.phone ?? "",
      dates: remoteModel.datacion ?? "",
      pois: remoteModel.pois ?? "",
      price: remoteModel.price ?? "Unknown",
      visitInfo: remoteModel.visita ?? "",
      image: _setMonumentImage(remoteModel.image),
      coords: _getCoordsFromGeometry(remoteModel.geometry),
    );
  }

  // TODO: borrar si no se usa
  static MonumentRemoteModel toRemote(Monument model) {
    return MonumentRemoteModel(
      id: int.parse(model.monumentId),
      title: model.title,
      description: model.description,
      estilo: model.style,
      address: model.address,
      horario: model.hours,
      phone: model.phone,
      datacion: model.dates,
      pois: model.pois,
      price: model.price,
      visita: model.visitInfo,
      image: model.image,
      geometry: Geometry(
          coordinates: [model.coords.latitude, model.coords.longitude]),
    );
  }

  static LatLng _getCoordsFromGeometry(Geometry? geometry) {
    if (geometry != null) {
      return LatLng(geometry.coordinates[1], geometry.coordinates[0]);
    } else {
      return const LatLng(0.0, 0.0);
    }
  }

  static String _setMonumentImage(String? url) {
    if (url != null && url != "") {
      return url;
    } else {
      return "https://i.pinimg.com/originals/89/c3/af/89c3af7ea32b8abe1caf2420c5c7ca5d.png";
    }
  }
}
