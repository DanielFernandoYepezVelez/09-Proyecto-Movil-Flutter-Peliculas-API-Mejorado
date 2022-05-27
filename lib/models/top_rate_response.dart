import 'dart:convert';

/* Movie Model */
import 'package:movies_api_flutter/models/models.dart';

class TopRateResponse {
  int page;
  int totalPages;
  int totalResults;
  List<Movie> results;

  TopRateResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TopRateResponse.fromJson(String str) =>
      TopRateResponse.fromMap(json.decode(str));

  factory TopRateResponse.fromMap(Map<String, dynamic> json) => TopRateResponse(
        page: json["page"],
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
      );
}
