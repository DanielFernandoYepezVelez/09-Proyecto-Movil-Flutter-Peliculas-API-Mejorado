import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/* Models Para Mapear La Data */
import 'package:peliculas_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _language = 'es-ES';
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = '921377099c0f476d58c37b8abc4e2d3a';

  MoviesProvider() {
    print('MoviesProvider Inicializado En Su Método Constructor');
    this.getOnDisplayMovies();
  }

  getOnDisplayMovies() async {
    var url = Uri.https(this._baseUrl, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language, 'page': '1'});

    final response = await http.get(url);
    final responseMapeadaPorLosModels =
        NowPlayingResponse.fromJson(response.body);

    print(responseMapeadaPorLosModels.results[1].title);
  }
}
