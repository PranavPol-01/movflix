import 'dart:convert';

class UpComingMovies {
  Dates dates;
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  UpComingMovies({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  UpComingMovies copyWith({
    Dates? dates,
    int? page,
    List<Result>? results,
    int? totalPages,
    int? totalResults,
  }) =>
      UpComingMovies(
        dates: dates ?? this.dates,
        page: page ?? this.page,
        results: results ?? this.results,
        totalPages: totalPages ?? this.totalPages,
        totalResults: totalResults ?? this.totalResults,
      );

  factory UpComingMovies.fromRawJson(String str) => UpComingMovies.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpComingMovies.fromJson(Map<String, dynamic> json) => UpComingMovies(
    dates: json["dates"] != null
        ? Dates.fromJson(json["dates"])
        : Dates(maximum: DateTime.now(), minimum: DateTime.now()), // Safe default

    page: json["page"] ?? 1,
    results: json["results"] != null
        ? List<Result>.from(json["results"].map((x) => Result.fromJson(x)))
        : [], // Return an empty list if null

    totalPages: json["total_pages"] ?? 0,
    totalResults: json["total_results"] ?? 0,
  );


  Map<String, dynamic> toJson() => {
    "dates": dates.toJson(),
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Dates {
  DateTime maximum;
  DateTime minimum;

  Dates({
    required this.maximum,
    required this.minimum,
  });

  Dates copyWith({
    DateTime? maximum,
    DateTime? minimum,
  }) =>
      Dates(
        maximum: maximum ?? this.maximum,
        minimum: minimum ?? this.minimum,
      );

  factory Dates.fromRawJson(String str) => Dates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
    maximum: DateTime.parse(json["maximum"]),
    minimum: DateTime.parse(json["minimum"]),
  );

  Map<String, dynamic> toJson() => {
    "maximum": "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
    "minimum": "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
  };
}

class Result {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  OriginalLanguage originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Result({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  Result copyWith({
    bool? adult,
    String? backdropPath,
    List<int>? genreIds,
    int? id,
    OriginalLanguage? originalLanguage,
    String? originalTitle,
    String? overview,
    double? popularity,
    String? posterPath,
    DateTime? releaseDate,
    String? title,
    bool? video,
    double? voteAverage,
    int? voteCount,
  }) =>
      Result(
        adult: adult ?? this.adult,
        backdropPath: backdropPath ?? this.backdropPath,
        genreIds: genreIds ?? this.genreIds,
        id: id ?? this.id,
        originalLanguage: originalLanguage ?? this.originalLanguage,
        originalTitle: originalTitle ?? this.originalTitle,
        overview: overview ?? this.overview,
        popularity: popularity ?? this.popularity,
        posterPath: posterPath ?? this.posterPath,
        releaseDate: releaseDate ?? this.releaseDate,
        title: title ?? this.title,
        video: video ?? this.video,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
      );

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    adult: json["adult"] ?? false,
    backdropPath: json["backdrop_path"] ?? '',
    genreIds: json["genre_ids"] != null
        ? List<int>.from(json["genre_ids"].map((x) => x))
        : [],
    id: json["id"] ?? 0,
    originalLanguage: originalLanguageValues.map[json["original_language"]] ?? OriginalLanguage.EN,
    originalTitle: json["original_title"] ?? 'Unknown Title',
    overview: json["overview"] ?? 'No description available.',
    popularity: (json["popularity"] ?? 0.0).toDouble(),
    posterPath: json["poster_path"] ?? '',
    releaseDate: json["release_date"] != null
        ? DateTime.tryParse(json["release_date"]) ?? DateTime(2000, 1, 1)
        : DateTime(2000, 1, 1), // Fallback date
    title: json["title"] ?? 'Unknown',
    video: json["video"] ?? false,
    voteAverage: (json["vote_average"] ?? 0.0).toDouble(),
    voteCount: json["vote_count"] ?? 0,
  );


  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "original_language": originalLanguageValues.reverse[originalLanguage],
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}

enum OriginalLanguage {
  EN,
  LV,
  ZH
}

final originalLanguageValues = EnumValues({
  "en": OriginalLanguage.EN,
  "lv": OriginalLanguage.LV,
  "zh": OriginalLanguage.ZH
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
