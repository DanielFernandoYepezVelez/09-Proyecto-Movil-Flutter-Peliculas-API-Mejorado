import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/* Helpers */
import 'package:peliculas_app/helpers/debouncer.dart';

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

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  /* Implementando El Debouncer Con El StreamController */
  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;

  MoviesProvider() {
    /* print('MoviesProvider Inicializado En Su Método Constructor'); */
    this.getPopularMovies();
    this.getRateTopMovies();
    this.getUpcomingMovies();
    this.getOnDisplayMovies();
  }

  /* ======================= PETICIÓN HTTP (GET JSON DATA) ============================= */
  Future<String> _getJsonData(String segment, [int page = 1]) async {
    final url = Uri.https(this._baseUrl, segment,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    /* TODO: Esto Debe Ingresarse Dentro De Un Try - Catch, En Caso Tal Que Falle La Petición */
    final response = await http.get(url);
    return response.body;
  }
  /* ================================================================= */

  /* ======================= GET MOVIES CARD_SWIPER ============================= */
  getOnDisplayMovies() async {
    final responseJsonData = await _getJsonData('3/movie/now_playing');

    final responseMapeadaPorLosModels =
        NowPlayingResponse.fromJson(responseJsonData);

    this.onDisplayMovies = responseMapeadaPorLosModels.results;
    notifyListeners();
  }
  /* ================================================================= */

  /* ======================= GET MOVIES POPULARES ============================= */
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
  /* ================================================================= */

  /* ======================= GET MOVIES MEJOR CALIFICADAS ============================= */
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
  /* ================================================================= */

  /* ======================= GET MOVIES PROXIMOS LANZAMIENTOS ============================= */
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
  /* ================================================================= */

  /* ======================= GET ACTORS PHOTO DETAILS (HTTP) ============================= */
  Future<List<Cast>> getMovieCast(int movieId) async {
    /* Revisar El Mapa Para Verificar Si Existe Ya Esa Pelicula
    Por La Clave Del ID Y No Volver Hacer Una Petición Http */
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    // print('Pidiendo Información Al Servidor - Cast');

    final responseJsonData = await _getJsonData('3/movie/$movieId/credits');

    final responseMapeadaPorLosModels =
        CreditsResponse.fromJson(responseJsonData);

    /* En Mi Mapa Estoy Almacenando El Resultado De La Petición, La Clave 
       Va A Ser El ID De La Pelicula Y El Valor La Lista De Actores 
       Que Pertenecen A Dicha Pelicula */
    moviesCast[movieId] = responseMapeadaPorLosModels.cast;

    /* Estoy Retornando Una Lista De Actores */
    return responseMapeadaPorLosModels.cast;
  }
  /* ================================================================= */

  /* ======================= SEARCH MOVIE ============================= */
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(this._baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final responseJsonData = await http.get(url);

    final responseMapeadaPorLosModels =
        SearchResponse.fromJson(responseJsonData.body);

    return responseMapeadaPorLosModels.results;
  }

  // Agrega El Valor Del Query Al Stream, Pero Cuando La Persona Deja De Escribir
  void getSuggetionsByQuery(String searchItem) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos Valor a buscar: $value');
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchItem;
    });

    Future.delayed(Duration(milliseconds: 301)).then((value) => timer.cancel());
  }
  /* ================================================================= */
}
