import 'dart:convert';

class TvShowRecommendationsModel {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  TvShowRecommendationsModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  TvShowRecommendationsModel copyWith({
    int? page,
    List<Result>? results,
    int? totalPages,
    int? totalResults,
  }) =>
      TvShowRecommendationsModel(
        page: page ?? this.page,
        results: results ?? this.results,
        totalPages: totalPages ?? this.totalPages,
        totalResults: totalResults ?? this.totalResults,
      );

  factory TvShowRecommendationsModel.fromRawJson(String str) => TvShowRecommendationsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvShowRecommendationsModel.fromJson(Map<String, dynamic> json) => TvShowRecommendationsModel(
    page: json["page"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Result {
  String backdropPath;
  int id;
  String name;
  String originalName;
  String overview;
  String posterPath;
  MediaType mediaType;
  bool adult;
  OriginalLanguage originalLanguage;
  List<int> genreIds;
  double popularity;
  DateTime firstAirDate;
  double voteAverage;
  int voteCount;
  List<OriginCountry> originCountry;

  Result({
    required this.backdropPath,
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.adult,
    required this.originalLanguage,
    required this.genreIds,
    required this.popularity,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.originCountry,
  });

  Result copyWith({
    String? backdropPath,
    int? id,
    String? name,
    String? originalName,
    String? overview,
    String? posterPath,
    MediaType? mediaType,
    bool? adult,
    OriginalLanguage? originalLanguage,
    List<int>? genreIds,
    double? popularity,
    DateTime? firstAirDate,
    double? voteAverage,
    int? voteCount,
    List<OriginCountry>? originCountry,
  }) =>
      Result(
        backdropPath: backdropPath ?? this.backdropPath,
        id: id ?? this.id,
        name: name ?? this.name,
        originalName: originalName ?? this.originalName,
        overview: overview ?? this.overview,
        posterPath: posterPath ?? this.posterPath,
        mediaType: mediaType ?? this.mediaType,
        adult: adult ?? this.adult,
        originalLanguage: originalLanguage ?? this.originalLanguage,
        genreIds: genreIds ?? this.genreIds,
        popularity: popularity ?? this.popularity,
        firstAirDate: firstAirDate ?? this.firstAirDate,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
        originCountry: originCountry ?? this.originCountry,
      );

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    backdropPath: json["backdrop_path"] ?? "", // Provide a default empty string if null
    id: json["id"] ?? 0, // Default ID to 0
    name: json["name"] ?? "Unknown",
    originalName: json["original_name"] ?? "Unknown",
    overview: json["overview"] ?? "No description available",
    posterPath: json["poster_path"] ?? "",
    mediaType: mediaTypeValues.map[json["media_type"]] ?? MediaType.TV, // Use default MediaType.TV
    adult: json["adult"] ?? false,
    originalLanguage: originalLanguageValues.map[json["original_language"]] ?? OriginalLanguage.EN,
    genreIds: json["genre_ids"] != null ? List<int>.from(json["genre_ids"].map((x) => x)) : [],
    popularity: (json["popularity"] ?? 0.0).toDouble(),
    firstAirDate: json["first_air_date"] != null ? DateTime.parse(json["first_air_date"]) : DateTime(2000, 1, 1),
    voteAverage: (json["vote_average"] ?? 0.0).toDouble(),
    voteCount: json["vote_count"] ?? 0,
    originCountry: json["origin_country"] != null
        ? List<OriginCountry>.from(json["origin_country"].map((x) => originCountryValues.map[x] ?? OriginCountry.US))
        : [],
  );


  Map<String, dynamic> toJson() => {
    "backdrop_path": backdropPath,
    "id": id,
    "name": name,
    "original_name": originalName,
    "overview": overview,
    "poster_path": posterPath,
    "media_type": mediaTypeValues.reverse[mediaType],
    "adult": adult,
    "original_language": originalLanguageValues.reverse[originalLanguage],
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "popularity": popularity,
    "first_air_date": "${firstAirDate.year.toString().padLeft(4, '0')}-${firstAirDate.month.toString().padLeft(2, '0')}-${firstAirDate.day.toString().padLeft(2, '0')}",
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "origin_country": List<dynamic>.from(originCountry.map((x) => originCountryValues.reverse[x])),
  };
}

enum MediaType {
  TV
}

final mediaTypeValues = EnumValues({
  "tv": MediaType.TV
});

enum OriginCountry {
  DE,
  GB,
  US
}

final originCountryValues = EnumValues({
  "DE": OriginCountry.DE,
  "GB": OriginCountry.GB,
  "US": OriginCountry.US
});

enum OriginalLanguage {
  DE,
  EN
}

final originalLanguageValues = EnumValues({
  "de": OriginalLanguage.DE,
  "en": OriginalLanguage.EN
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
