import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

/* Models Para Mapear La Data */
import 'package:peliculas_app/models/models.dart';

class ActorProvider extends ChangeNotifier {
  String _language = 'es-ES';
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = '921377099c0f476d58c37b8abc4e2d3a';

  /* Aqui Estoy Almacenando Como Clave El Id Del Actor, Y En Cada ID
  Voy A Guardar Toda La Información De Ese Actor Clickeado */
  Map<int, PeopleResponse> actorInformation = {};

  ActorProvider() {
    print('ActorProvider Inicializado Método Constructor "Multiprovider"');
  }

  /* ======================= PETICIÓN HTTP (GET JSON DATA) ============================= */
  Future<String> _getJsonData(String segment) async {
    final url = Uri.https(this._baseUrl, segment,
        {'api_key': this._apiKey, 'language': this._language});

    /* TODO: Esto Debe Ingresarse Dentro De Un Try - Catch, En Caso Tal Que Falle La Petición */
    final response = await http.get(url);
    return response.body;
  }
  /* ================================================================= */

  /* ======================= GET ACTOR INFORMATION (HTTP) ============================= */
  Future<PeopleResponse> getActorInformation(int actorId) async {
    /* Revisar El Mapa Para Verificar Si Existe Ya Ese Actor
    Por La Clave Del ID Y No Volver Hacer Una Petición Http */
    if (actorInformation.containsKey(actorId))
      return actorInformation[actorId]!;

    final responseJsonData = await _getJsonData('3/person/$actorId');

    print('Aqui Hacemos La Petición Para La Información Del Actor');

    final responseMapeadaPorLosModels =
        PeopleResponse.fromJson(responseJsonData);

    /* En Mi Mapa Estoy Almacenando El Resultado De La Petición, La Clave 
       Va A Ser El ID Del Actor Y Su Valor Va A Ser El Valor La Información 
       Del Actor Que Pertenecen A Ese ID */
    this.actorInformation[actorId] = responseMapeadaPorLosModels;

    /* No Siempre Tengo Que Trabajar Con El NotifyListeners(), Especialmente Si 
       Trabajo Con Un FutureBuilder() */
    // notifyListeners();

    return responseMapeadaPorLosModels;
  }
}
