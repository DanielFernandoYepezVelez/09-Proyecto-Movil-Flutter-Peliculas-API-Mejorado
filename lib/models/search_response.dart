import 'dart:convert';

/* Movie Model */
import 'package:movies_api_flutter/models/models.dart';

class SearchResponse {
  int page;
  int totalPages;
  int totalResults;
  List<Movie> results;

  SearchResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchResponse.fromJson(String str) =>
      SearchResponse.fromMap(json.decode(str));

  factory SearchResponse.fromMap(Map<String, dynamic> json) => SearchResponse(
        page: json["page"],
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
      );
}
