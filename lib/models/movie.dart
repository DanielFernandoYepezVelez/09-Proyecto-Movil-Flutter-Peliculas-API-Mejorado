import 'dart:convert';

class Movie {
  int id;
  bool adult;
  bool video;
  String title;
  int voteCount;
  String overview;
  double popularity;
  String? posterPath;
  double voteAverage;
  List<int> genreIds;
  String? releaseDate;
  String? backdropPath;
  String originalTitle;
  String originalLanguage;

  Movie({
    this.posterPath,
    this.releaseDate,
    required this.id,
    this.backdropPath,
    required this.video,
    required this.title,
    required this.adult,
    required this.genreIds,
    required this.overview,
    required this.voteCount,
    required this.popularity,
    required this.voteAverage,
    required this.originalTitle,
    required this.originalLanguage,
  });

  factory Movie.fromJson(String str) => Movie.fromMap(json.decode(str));

  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
        id: json["id"],
        adult: json["adult"],
        title: json["title"],
        video: json["video"],
        overview: json["overview"],
        voteCount: json["vote_count"],
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        backdropPath: json["backdrop_path"],
        originalTitle: json["original_title"],
        popularity: json["popularity"].toDouble(),
        originalLanguage: json["original_language"],
        voteAverage: json["vote_average"].toDouble(),
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
      );
}
