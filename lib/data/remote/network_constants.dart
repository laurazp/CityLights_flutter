// ignore_for_file: constant_identifier_names

class NetworkConstants {
  static const BASE_URL = "https://www.zaragoza.es/sede/servicio";

  static const MONUMENT_LIST_PATH = "$BASE_URL/monumento.json";

  static const MONUMENT_DETAIL_PATH = "$BASE_URL/monumento/";

  static String getMonumentDetailPath(String monumentId) {
    return "${NetworkConstants.MONUMENT_DETAIL_PATH}$monumentId.json";
  }
}
