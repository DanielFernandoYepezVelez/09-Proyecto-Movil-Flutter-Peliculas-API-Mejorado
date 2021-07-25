import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/* Models Para Mapear La Data */
import 'package:peliculas_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _language = 'es-ES';
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = '921377099c0f476d58c37b8abc4e2d3a';

  int _popularPage = 0;
  int _topRatePage = 0;
  int _upcomingPage = 0;

  List<Movie> popularMovies = [];
  List<Movie> topRateMovies = [];
  List<Movie> upcomingMovies = [];
  List<Movie> onDisplayMovies = [];

  /* Una Forma Diferente Para Hacer Las Peticiones http De Actores */
  Map<int, List<Cast>> moviesCast = {};

  MoviesProvider() {
    /* print('MoviesProvider Inicializado En Su Método Constructor'); */
    this.getPopularMovies();
    this.getRateTopMovies();
    this.getUpcomingMovies();
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
    this._popularPage++;

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

/* Las Mejor Calificadas */
  getRateTopMovies() async {
    this._topRatePage++;

    final responseJsonData =
        await _getJsonData('3/movie/top_rated', _topRatePage);

    final responseMapeadaPorLosModels =
        TopRateResponse.fromJson(responseJsonData);

    this.topRateMovies = [
      ...this.topRateMovies,
      ...responseMapeadaPorLosModels.results
    ];

    notifyListeners();
  }

  /* Próximas Peliculas */
  getUpcomingMovies() async {
    this._upcomingPage++;

    final responseJsonData =
        await _getJsonData('3/movie/upcoming', _topRatePage);

    final responseMapeadaPorLosModels =
        UpcomingResponse.fromJson(responseJsonData);

    this.upcomingMovies = [
      ...this.upcomingMovies,
      ...responseMapeadaPorLosModels.results
    ];

    notifyListeners();
  }

  /* Actores En La Pantalla De Details */
  Future<List<Cast>> getMovieCast(int movieId) async {
    /* Revisar El Mapa Para Verificar El ID */
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    print('Pidiendo Información Al Servidor - Cast');

    final responseJsonData = await _getJsonData('3/movie/$movieId/credits');

    final responseMapeadaPorLosModels =
        CreditsResponse.fromJson(responseJsonData);

    /* En Mi Mapa Estoy Almacenando El Resultado De La Petición, La Llave 
       Va A Ser El ID De La Pelicula Y El Valor La Lista De Actores */
    moviesCast[movieId] = responseMapeadaPorLosModels.cast;

    /* Estoy Retornando Una Lista De Actores */
    return responseMapeadaPorLosModels.cast;
  }
}
