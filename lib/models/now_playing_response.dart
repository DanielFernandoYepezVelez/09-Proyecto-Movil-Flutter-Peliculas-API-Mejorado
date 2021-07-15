import 'dart:convert';

/* Global Models */
import 'models.dart';

class NowPlayingResponse {
  int page;
  Dates dates;
  int totalPages;
  int totalMovies;
  List<Movie> results;

  NowPlayingResponse({
    required this.page,
    required this.dates,
    required this.results,
    required this.totalPages,
    required this.totalMovies,
  });

  factory NowPlayingResponse.fromJson(String str) =>
      NowPlayingResponse.fromMap(json.decode(str));

  factory NowPlayingResponse.fromMap(Map<String, dynamic> json) =>
      NowPlayingResponse(
        page: json["page"],
        totalPages: json["total_pages"],
        totalMovies: json["total_results"],
        dates: Dates.fromMap(json["dates"]),
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
      );
}

/*  -----------------------------------------------------------  */

class Dates {
  DateTime maximum;
  DateTime minimum;

  Dates({
    required this.maximum,
    required this.minimum,
  });

  factory Dates.fromJson(String str) => Dates.fromMap(json.decode(str));

  factory Dates.fromMap(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );
}

/*  -----------------------------------------------------------  */