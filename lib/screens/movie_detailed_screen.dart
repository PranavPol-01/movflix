import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movflix/common/utils.dart';
import 'package:movflix/models/movie_detail_model.dart';
import 'package:movflix/models/movie_recommendation_model.dart';
import 'package:movflix/services/api_services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:movflix/models/tv_show_video_model.dart';



class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  MovieDetailScreenState createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends State<MovieDetailScreen> {
  ApiServices apiServices = ApiServices();

  late Future<MovieDetailModel> movieDetail;
  late Future<MovieRecommendationsModel> movieRecommendationModel;
  late Future<TvShowVideo> movieVideo;
  bool isPlaying = false;
  String? videoKey; // Store YouTube video key
  YoutubePlayerController? _youtubeController;


  @override
  void initState() {
    fetchInitialData();
    super.initState();
  }

  fetchInitialData() {
    movieDetail = apiServices.getMovieDetail(widget.movieId);
    movieRecommendationModel =
        apiServices.getMovieRecommendations(widget.movieId);
    movieVideo = apiServices.getMovieVideos(widget.movieId);
    setState(() {});
  }
  void playVideo(String key) {
    setState(() {
      videoKey = key;
      isPlaying = true;
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoKey!,
        flags: const YoutubePlayerFlags(autoPlay: true),
      );
    });
  }


  void _shareMovie(MovieDetailModel movie) {
    final String shareText =
        "🎬 Check out this movie: *${movie.title}*!\n\n"
        "📅 Released: ${movie.releaseDate.year}\n"
        "🎭 Genre: ${movie.genres.map((genre) => genre.name).join(', ')}\n\n"
        "📖 Overview:\n${movie.overview}\n\n"
        "🔗 More details: https://www.themoviedb.org/movie/${movie.id}";

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(widget.movieId);
    return Scaffold(
      body: SafeArea(
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: movieDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final movie = snapshot.data;

              String genresText =
              movie!.genres.map((genre) => genre.name).join(', ');

              return Column(
                children: [
                  Stack(
                    children: [
                      isPlaying && videoKey != null
                          ? YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: _youtubeController!,
                          showVideoProgressIndicator: true,
                        ),
                        builder: (context, player) {
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: player,
                          );
                        },
                      )
                          : Container(
                        height: size.height * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("$imageUrl${movie.posterPath}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: [0.0, 0.15, 0.5, 1.0], // Adjust the fade intensity
                                  colors: [
                                    Theme.of(context).scaffoldBackgroundColor,
                                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),

                            // SafeArea for back button
                            SafeArea(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: movieVideo,
                    builder: (context, videoSnapshot) {
                      if (videoSnapshot.hasData) {
                        final videoData = videoSnapshot.data!;
                        if (videoData.results.isNotEmpty) {
                          return Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                minimumSize: Size(size.width, 50),
                              ),
                              onPressed: () => playVideo(videoData.results.first.key),
                              child: const Text("\u25B6 PLAY", style: TextStyle(fontSize: 16)),
                            ),
                            // child: ElevatedButton.icon(
                            //   onPressed: () => playVideo(videoData.results.first.key),
                            //   icon: const Icon(Icons.play_arrow),
                            //   label: const Text('Play '),
                            // ),
                          );
                        }
                      }
                      return const SizedBox();
                    },
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 25, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              movie.releaseDate.year.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Text(
                              genresText,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          movie.overview,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),const SizedBox(height: 20),


                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => _shareMovie(movie),
                            icon: const Icon(Icons.share),
                            label: const Text("Share"),
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: movieRecommendationModel,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final movie = snapshot.data;

                        return movie!.results.isEmpty
                            ? const SizedBox()
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "More like this",
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // GridView.builder(
                            //   physics:
                            //   const NeverScrollableScrollPhysics(),
                            //   shrinkWrap: true,
                            //   padding: EdgeInsets.zero,
                            //   scrollDirection: Axis.vertical,
                            //   itemCount: movie.results.length,
                            //   gridDelegate:
                            //   const SliverGridDelegateWithFixedCrossAxisCount(
                            //     crossAxisCount: 3,
                            //     mainAxisSpacing: 15,
                            //     childAspectRatio: 1.5 / 2,
                            //   ),
                            //   itemBuilder: (context, index) {
                            //     return InkWell(
                            //       onTap: () {
                            //         Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //             builder: (context) =>
                            //                 MovieDetailScreen(
                            //                     movieId: movie
                            //                         .results[index].id),
                            //           ),
                            //         );
                            //       },
                            //       child: CachedNetworkImage(
                            //         imageUrl:
                            //         "$imageUrl${movie.results[index].posterPath}",
                            //       ),
                            //     );
                            //   },
                            // ),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: movie.results.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.55, // Increased height for better proportions
                              ),
                              itemBuilder: (context, index) {
                                final movieItem = movie.results[index];

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetailScreen(movieId: movieItem.id),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      // Card with Shadow
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            imageUrl: "$imageUrl${movieItem.posterPath}",
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            placeholder: (context, url) => Container(
                                              color: Colors.grey[900],
                                              child: const Center(child: CircularProgressIndicator()),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.grey[900],
                                              child: const Center(child: Icon(Icons.error, color: Colors.red)),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Gradient Overlay for Better Visibility
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.8),
                                                Colors.black.withOpacity(0.3),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                          child: Text(
                                            movieItem.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                          ],
                        );
                      }
                      return const Text("Something Went wrong");
                    },
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    ),
    );
  }
}