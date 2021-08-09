import 'dart:convert';

class PeopleResponse {
  int id;
  bool adult;
  int gender;
  String name;
  String imdbId;
  String birthday;
  String biography;
  dynamic deathday;
  dynamic homepage;
  double popularity;
  String profilePath;
  String placeOfBirth;
  List<String> alsoKnownAs;
  String knownForDepartment;

  PeopleResponse({
    this.deathday,
    this.homepage,
    required this.id,
    required this.name,
    required this.adult,
    required this.gender,
    required this.imdbId,
    required this.birthday,
    required this.biography,
    required this.popularity,
    required this.profilePath,
    required this.alsoKnownAs,
    required this.placeOfBirth,
    required this.knownForDepartment,
  });

  factory PeopleResponse.fromJson(String str) =>
      PeopleResponse.fromMap(json.decode(str));

  factory PeopleResponse.fromMap(Map<String, dynamic> json) => PeopleResponse(
        id: json["id"],
        name: json["name"],
        adult: json["adult"],
        gender: json["gender"],
        imdbId: json["imdb_id"],
        deathday: json["deathday"] == null ? 'Vive' : json["deathday"],
        homepage: json["homepage"],
        birthday: json["birthday"],
        biography: json["biography"],
        profilePath: json["profile_path"],
        placeOfBirth: json["place_of_birth"],
        popularity: json["popularity"].toDouble(),
        knownForDepartment: json["known_for_department"],
        alsoKnownAs: List<String>.from(json["also_known_as"].map((x) => x)),
      );

  getProfilePath() {
    if (this.profilePath == null) {
      return 'https://mantenimientocode.xyz/images/not-found.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/${this.profilePath}';
    }
  }
}
