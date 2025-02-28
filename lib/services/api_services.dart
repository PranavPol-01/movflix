import 'dart:convert';
import 'dart:developer';

import 'package:movflix/common/utils.dart';
import 'package:http/http.dart' as http;
import 'package:movflix/models/movie_detail_model.dart';
import 'package:movflix/models/movie_model.dart';
import 'package:movflix/models/movie_recommendation_model.dart';
import 'package:movflix/models/search_model.dart';
import 'package:movflix/models/tv_series_model.dart';
import 'package:movflix/models/tv_series_detail_model.dart';
import 'package:movflix/models/tv_series_recommendation_model.dart';
import 'package:movflix/models/tv_show_video_model.dart';
import 'package:movflix/models/upcoming_movie_model.dart' as upcoming;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';


const baseUrl = 'https://api.themoviedb.org/3/';
var key = '?api_key=$apiKey';
late String endPoint;

class ApiServices {
  Future<MovieModel> getUpcomingMovies() async {
    endPoint = 'movie/upcoming';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load upcoming movies');
  }

  static Future<List<upcoming.Result>> getUpComingMovies() async {
    final String endPoint = 'movie/upcoming';
    final String url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    print(response.body);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final upcomingMovies = upcoming.UpComingMovies.fromJson(decodedData);
      return upcomingMovies.results;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }


  Future<MovieModel> getNowPlayingMovies() async {
    endPoint = 'movie/now_playing';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<MovieRecommendationsModel> getPopularMovies() async {
    endPoint = 'movie/popular';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url), headers: {});
    if (response.statusCode == 200) {
      log('success');
      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load now playing movies');
  }

  Future<TvSeriesModel> getTopRatedSeries() async {
    endPoint = 'tv/1399/recommendations';
    // endPoint = 'movie/popular';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load top rated series');
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    endPoint = 'movie/$movieId';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }

  // Future<MovieRecommendationsModel> getMovieRecommendations(int movieId) async {
  //   endPoint = 'movie/$movieId/recommendations';
  //   final url = '$baseUrl$endPoint$key';
  //
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     log('success');
  //     return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
  //   }
  //   throw Exception('failed to load  movie details');
  // }

  Future<MovieRecommendationsModel> getMovieRecommendations(int movieId) async {
    endPoint = 'movie/$movieId/recommendations';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('API success');
      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    } else {
      log(
          'API failed, fetching recommendations from Firebase for movieId 939243');
      return getRecommendationsFromFirebase(939243);
    }
  }

  Future<MovieRecommendationsModel> getRecommendationsFromFirebase(
      int movieId) async {
    final ref = FirebaseDatabase.instance.ref('recommendations/$movieId');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      log('Firebase data found');
      return MovieRecommendationsModel.fromJson(
          jsonDecode(jsonEncode(snapshot.value)));
    } else {
      throw Exception('No recommendations found in Firebase');
    }
  }


  // Future<MovieRecommendationsModel> getMovieRecommendations(int movieId) async {
  //   endPoint = 'movie/$movieId/recommendations';
  //   final url = '$baseUrl$endPoint$key';
  //
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     log('Fetched movie recommendations successfully');
  //     final movieRecommendations = MovieRecommendationsModel.fromJson(jsonDecode(response.body));
  //
  //     // Store in Firestore
  //     await saveRecommendationsToFirestore(movieId, jsonDecode(response.body));
  //
  //     return movieRecommendations;
  //   }
  //   throw Exception('Failed to load movie recommendations');
  // }

  // Future<void> saveRecommendationsToFirestore(int movieId, Map<String, dynamic> data) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   CollectionReference recommendationsCollection = firestore.collection('movie_recommendations');
  //
  //   await recommendationsCollection.doc(movieId.toString()).set({
  //     'movie_id': movieId,
  //     'recommendations': data['results'],
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  //
  //   log("Movie recommendations saved to Firestore.");
  // }


  Future<SearchModel> getSearchedMovie(String searchText) async {
    endPoint = 'search/movie?query=$searchText';
    final url = '$baseUrl$endPoint';
    print(url);
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NTAyYjhjMDMxYzc5NzkwZmU1YzBiNGY5NGZkNzcwZCIsInN1YiI6IjYzMmMxYjAyYmE0ODAyMDA4MTcyNjM5NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.N1SoB26LWgsA33c-5X0DT5haVOD4CfWfRhwpDu9eGkc'
    });
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log('success');
      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  search movie ');
  }


  Future<TvShowDetailModel> getTvShowDetail(int tvShowId) async {
    endPoint = 'tv/$tvShowId';
    final url = '$baseUrl$endPoint$key';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('Fetched TV show details successfully');
      return TvShowDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load TV show details');
  }

  Future<TvShowRecommendationsModel> getTvShowRecommendations(
      int tvShowId) async {
    endPoint = 'tv/$tvShowId/recommendations';
    final url = '$baseUrl$endPoint$key';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('Fetched TV show recommendations successfully');
      return TvShowRecommendationsModel.fromJson(jsonDecode(response.body));
    }else{
      log('Failed to load TV show recommendations');
      return getRecommendationsFromFirebaseTV(939243);
    }

  }

  Future<TvShowRecommendationsModel> getRecommendationsFromFirebaseTV(
      int movieId) async {
    final ref = FirebaseDatabase.instance.ref('recommendations/$movieId');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      log('Firebase data found');
      return TvShowRecommendationsModel.fromJson(
          jsonDecode(jsonEncode(snapshot.value)));
    } else {
      throw Exception('No recommendations found in Firebase');
    }
  }

  Future<TvShowVideo> getTvShowVideos(int tvShowId) async {
    endPoint = 'tv/$tvShowId/videos';
    final url = '$baseUrl$endPoint$key';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('Fetched TV show videos successfully');
      return TvShowVideo.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load TV show videos');
  }

  Future<TvShowVideo> getMovieVideos(int tvShowId) async {
    endPoint = 'movie/$tvShowId/videos';
    final url = '$baseUrl$endPoint$key';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('Fetched TV movie videos successfully');
      return TvShowVideo.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load TV show videos');
  }


}


