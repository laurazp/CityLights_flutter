// ignore_for_file: constant_identifier_names

class NetworkConstants {
  static const BASE_URL = "https://www.zaragoza.es/sede/servicio";

  static const MONUMENT_LIST_PATH = "$BASE_URL/monumento.json";

  static const MONUMENT_DETAIL_PATH = "$BASE_URL/monumento/{monumentId}.json";
}

//TODO: borrar cuando estén añadidos los parámetros query
/*
@GET("monumento.json")
    suspend fun getMonuments(
        @Query("rows") limit: Int = 100,
        @Query("srsname") srsname: String = "wgs84"
    ): MonumentsResponse

    @GET("monumento.json")
    suspend fun getMonumentsPaging(
        @Query("start") offset: Int,
        @Query("rows") limit: Int,
        @Query("srsname") srsname: String = "wgs84"
    ): MonumentsResponse

    @GET("monumento/{monumentId}.json?srsname=wgs84")
    suspend fun getMonument(
        @Path("monumentId") monumentId: String,
        @Query("srsname") srsname: String = "wgs84"
    ): ApiMonument


    static String getPokemonImage(int index) {
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png";
  }
*/