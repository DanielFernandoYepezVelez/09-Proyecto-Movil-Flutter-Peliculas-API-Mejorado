import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/* Models Para Mapear La Data */
import 'package:peliculas_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _language = 'es-ES';
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = '921377099c0f476d58c37b8abc4e2d3a';

  int _popularPage = 0;
  List<Movie> popularMovies = [];
  List<Movie> onDisplayMovies = [];

  MoviesProvider() {
    /* print('MoviesProvider Inicializado En Su Método Constructor'); */
    this.getPopularMovies();
    this.getOnDisplayMovies();
  }

  Future<String> _getJsonData(String segment, [int page = 1]) async {
    var url = Uri.https(this._baseUrl, segment,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final responseJsonData = await _getJsonData('3/movie/now_playing');

    final responseMapeadaPorLosModels =
        NowPlayingResponse.fromJson(responseJsonData);

    this.onDisplayMovies = responseMapeadaPorLosModels.results;
    notifyListeners();
  }

  getPopularMovies() async {
    /* Antes De Hacer La Petición Voy A Incrementar La Página A La Que Va Ir La Solicitud */
    _popularPage++;

    final responseJsonData =
        await _getJsonData('3/movie/popular', _popularPage);

    final responseMapeadaPorLosModels =
        PopularResponse.fromJson(responseJsonData);

    this.popularMovies = [
      ...this.popularMovies,
      ...responseMapeadaPorLosModels.results
    ];

    notifyListeners();
  }
}
