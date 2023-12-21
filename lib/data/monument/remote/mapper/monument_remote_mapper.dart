import 'package:citylights/data/monument/remote/model/monument_remote_model.dart';
import 'package:citylights/model/monument.dart';
import 'package:latlong2/latlong.dart';

class MonumentRemoteMapper {
  static Monument fromRemote(MonumentRemoteModel remoteModel) {
    return Monument(
      monumentId: remoteModel.id.toString(),
      title: remoteModel.title ?? "",
      description: remoteModel.description ?? "",
      style: remoteModel.estilo ?? "",
      address: remoteModel.address ?? "",
      hours: remoteModel.horario ?? "",
      phone: remoteModel.phone ?? "",
      dates: remoteModel.datacion ?? "",
      pois: remoteModel.pois ?? "",
      price: remoteModel.price ?? "Unknown",
      visitInfo: remoteModel.visita ?? "",
      image: remoteModel.image ?? "",
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
      return LatLng(geometry.coordinates[0], geometry.coordinates[1]);
    } else {
      return const LatLng(0.0, 0.0);
    }
  }
}
