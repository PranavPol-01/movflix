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
    endPoint = 'tv/1396/recommendations';
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

  Future<MovieRecommendationsModel> getMovieRecommendations(int movieId) async {
    endPoint = 'movie/$movieId/recommendations';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('success');
      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('failed to load  movie details');
  }

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

  Future<TvShowRecommendationsModel> getTvShowRecommendations(int tvShowId) async {
    endPoint = 'tv/$tvShowId/recommendations';
    final url = '$baseUrl$endPoint$key';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('Fetched TV show recommendations successfully');
      return TvShowRecommendationsModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load TV show recommendations');
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





}
