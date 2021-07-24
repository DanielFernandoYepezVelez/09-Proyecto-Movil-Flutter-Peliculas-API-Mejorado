import 'dart:convert';

class Cast {
  int id;
  int? order;
  int gender;
  bool adult;
  String? job;
  int? castId;
  String name;
  String creditId;
  String? character;
  double popularity;
  String? department;
  String? profilePath;
  String originalName;
  String? knownForDepartment;

  Cast({
    this.job,
    this.order,
    this.castId,
    this.character,
    this.department,
    this.profilePath,
    required this.id,
    required this.name,
    required this.adult,
    required this.gender,
    required this.creditId,
    this.knownForDepartment,
    required this.popularity,
    required this.originalName,
  });

  factory Cast.fromJson(String str) => Cast.fromMap(json.decode(str));

  /* Quicktype.io Detecta Cuales Propiedades Pueden Venir Nulas, Y Si Vienen Nulas,
   Yo No Puedo Hacer Nada, Más Que Colocarlas Como Opcionales, Para Que No Me Presente
   Un Error En El Momento De Realizar La Petición HTTP() */
  factory Cast.fromMap(Map<String, dynamic> json) => Cast(
        id: json["id"],
        name: json["name"],
        adult: json["adult"],
        gender: json["gender"],
        creditId: json["credit_id"],
        originalName: json["original_name"],
        popularity: json["popularity"].toDouble(),
        job: json["job"] == null ? null : json["job"],
        knownForDepartment: json["known_for_department"],
        order: json["order"] == null ? null : json["order"],
        castId: json["cast_id"] == null ? null : json["cast_id"],
        character: json["character"] == null ? null : json["character"],
        department: json["department"] == null ? null : json["department"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
      );

  getProfilePath() {
    if (this.profilePath == null) {
      return 'https://mantenimientocode.xyz/images/not-found.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/${this.profilePath}';
    }
  }
}
