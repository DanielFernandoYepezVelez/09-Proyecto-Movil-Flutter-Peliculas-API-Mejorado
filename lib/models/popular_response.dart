import 'dart:convert';

/* Movie Model */
import 'package:peliculas_app/models/models.dart';

class PopularResponse {
  int page;
  int totalPages;
  int totalResults;
  List<Movie> results;

  PopularResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory PopularResponse.fromJson(String str) =>
      PopularResponse.fromMap(json.decode(str));

  factory PopularResponse.fromMap(Map<String, dynamic> json) => PopularResponse(
        page: json["page"],
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
      );
}
