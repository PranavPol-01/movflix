import 'dart:convert';

class TvShowVideo {
  int id;
  List<Result> results;

  TvShowVideo({
    required this.id,
    required this.results,
  });

  TvShowVideo copyWith({
    int? id,
    List<Result>? results,
  }) =>
      TvShowVideo(
        id: id ?? this.id,
        results: results ?? this.results,
      );

  factory TvShowVideo.fromRawJson(String str) => TvShowVideo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvShowVideo.fromJson(Map<String, dynamic> json) => TvShowVideo(
    id: json["id"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  String iso6391;
  String iso31661;
  String name;
  String key;
  String site;
  int size;
  String type;
  bool official;
  DateTime publishedAt;
  String id;

  Result({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  Result copyWith({
    String? iso6391,
    String? iso31661,
    String? name,
    String? key,
    String? site,
    int? size,
    String? type,
    bool? official,
    DateTime? publishedAt,
    String? id,
  }) =>
      Result(
        iso6391: iso6391 ?? this.iso6391,
        iso31661: iso31661 ?? this.iso31661,
        name: name ?? this.name,
        key: key ?? this.key,
        site: site ?? this.site,
        size: size ?? this.size,
        type: type ?? this.type,
        official: official ?? this.official,
        publishedAt: publishedAt ?? this.publishedAt,
        id: id ?? this.id,
      );

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    iso6391: json["iso_639_1"],
    iso31661: json["iso_3166_1"],
    name: json["name"],
    key: json["key"],
    site: json["site"],
    size: json["size"],
    type: json["type"],
    official: json["official"],
    publishedAt: DateTime.parse(json["published_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "iso_639_1": iso6391,
    "iso_3166_1": iso31661,
    "name": name,
    "key": key,
    "site": site,
    "size": size,
    "type": type,
    "official": official,
    "published_at": publishedAt.toIso8601String(),
    "id": id,
  };
}
