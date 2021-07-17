import 'dart:convert';

/* Movie Models */
import 'package:peliculas_app/models/models.dart';

class UpcomingResponse {
  int page;
  Dates dates;
  int totalPages;
  int totalResults;
  List<Movie> results;

  UpcomingResponse({
    required this.page,
    required this.dates,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory UpcomingResponse.fromJson(String str) =>
      UpcomingResponse.fromMap(json.decode(str));

  factory UpcomingResponse.fromMap(Map<String, dynamic> json) =>
      UpcomingResponse(
        page: json["page"],
        dates: Dates.fromMap(json["dates"]),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
      );
}

/*  -----------------------------------------------------------  */

// class Dates {
//   DateTime maximum;
//   DateTime minimum;

//   Dates({
//     required this.maximum,
//     required this.minimum,
//   });

//   factory Dates.fromJson(String str) => Dates.fromMap(json.decode(str));

//   factory Dates.fromMap(Map<String, dynamic> json) => Dates(
//         maximum: DateTime.parse(json["maximum"]),
//         minimum: DateTime.parse(json["minimum"]),
//       );
// }

/*  -----------------------------------------------------------  */
