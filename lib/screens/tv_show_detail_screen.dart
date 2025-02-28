// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:movflix/common/utils.dart';
// import 'package:movflix/models/tv_series_detail_model.dart';
// import 'package:movflix/models/tv_series_recommendation_model.dart';
// import 'package:movflix/services/api_services.dart';
//
// class TvShowDetailScreen extends StatefulWidget {
//   final int showId;
//   const TvShowDetailScreen({super.key, required this.showId});
//
//   @override
//   TvShowDetailScreenState createState() => TvShowDetailScreenState();
// }
//
// class TvShowDetailScreenState extends State<TvShowDetailScreen> {
//   ApiServices apiServices = ApiServices();
//
//   late Future<TvShowDetailModel> tvShowDetail;
//   late Future<TvShowRecommendationsModel> tvShowRecommendationModel;
//
//   @override
//   void initState() {
//     fetchInitialData();
//     super.initState();
//   }
//
//   fetchInitialData() {
//     tvShowDetail = apiServices.getTvShowDetail(widget.showId);
//     tvShowRecommendationModel = apiServices.getTvShowRecommendations(widget.showId);
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: FutureBuilder(
//           future: tvShowDetail,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final show = snapshot.data;
//
//               String genresText = show!.genres.map((genre) => genre.name).join(', ');
//
//               return Column(
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                         height: size.height * 0.4,
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 image: NetworkImage(
//                                     "$imageUrl${show.posterPath}"),
//                                 fit: BoxFit.cover)),
//                         child: SafeArea(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.arrow_back_ios,
//                                     color: Colors.white),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding:
//                     const EdgeInsets.only(top: 25, left: 10, right: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           show.name,
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Row(
//                           children: [
//                             Text(
//                               show.firstAirDate.year.toString(),
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const SizedBox(width: 30),
//                             Text(
//                               genresText,
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 17,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 30),
//                         Text(
//                           show.overview,
//                           maxLines: 6,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   FutureBuilder(
//                     future: tvShowRecommendationModel,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         final recommendations = snapshot.data;
//
//                         return recommendations!.results.isEmpty
//                             ? const SizedBox()
//                             : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "More like this",
//                               maxLines: 6,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             GridView.builder(
//                               physics:
//                               const NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               padding: EdgeInsets.zero,
//                               scrollDirection: Axis.vertical,
//                               itemCount: recommendations.results.length,
//                               gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 3,
//                                 mainAxisSpacing: 15,
//                                 childAspectRatio: 1.5 / 2,
//                               ),
//                               itemBuilder: (context, index) {
//                                 return InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => TvShowDetailScreen(
//                                             showId: recommendations
//                                                 .results[index].id),
//                                       ),
//                                     );
//                                   },
//                                   child: CachedNetworkImage(
//                                     imageUrl:
//                                     "$imageUrl${recommendations.results[index].posterPath}",
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         );
//                       }
//                       return const Text("Something went wrong");
//                     },
//                   ),
//                 ],
//               );
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movflix/common/utils.dart';
import 'package:movflix/models/tv_series_detail_model.dart';
import 'package:movflix/models/tv_series_recommendation_model.dart';
import 'package:movflix/models/tv_show_video_model.dart';
import 'package:movflix/services/api_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:share_plus/share_plus.dart';


class TvShowDetailScreen extends StatefulWidget {
  final int showId;
  const TvShowDetailScreen({super.key, required this.showId});

  @override
  TvShowDetailScreenState createState() => TvShowDetailScreenState();
}

class TvShowDetailScreenState extends State<TvShowDetailScreen> {
  ApiServices apiServices = ApiServices();

  late Future<TvShowDetailModel> tvShowDetail;
  late Future<TvShowRecommendationsModel> tvShowRecommendationModel;
  late Future<TvShowVideo> tvShowVideo;

  bool isPlaying = false;
  String? videoKey; // Store YouTube video key

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  void fetchInitialData() {
    tvShowDetail = apiServices.getTvShowDetail(widget.showId);
    tvShowRecommendationModel = apiServices.getTvShowRecommendations(widget.showId);
    tvShowVideo = apiServices.getTvShowVideos(widget.showId);
  }

  void playVideo(String key) {
    setState(() {
      videoKey = key;
      isPlaying = true;
    });
  }
  void _shareTvShow(String title, String overview, int showId) {
    final String shareText =
        "📺 Check out this TV Show: *$title*!\n\n"
        "📖 Overview:\n$overview\n\n"
        "🔗 More details: https://www.themoviedb.org/tv/$showId";

    Share.share(shareText);
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: tvShowDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final show = snapshot.data!;
              String genresText = show.genres.map((genre) => genre.name).join(', ');

              return Column(
                children: [
                  Stack(
                    children: [
                      isPlaying && videoKey != null
                          ? YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: videoKey!,
                            flags: const YoutubePlayerFlags(autoPlay: true),
                          ),
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
                            image: NetworkImage("$imageUrl${show.posterPath}"),
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
                  // const SizedBox(height: 10),
                  FutureBuilder(
                    future: tvShowVideo,
                    builder: (context, videoSnapshot) {
                      if (videoSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator()); // Show loading indicator
                      } else if (videoSnapshot.hasError) {
                        return const Center(child: Text("Error loading video"));
                      } else if (videoSnapshot.hasData) {
                        final videoData = videoSnapshot.data!;
                        if (videoData.results.isNotEmpty) {
                          return Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade800,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                              ),
                              onPressed: () => playVideo(videoData.results.first.key),
                              icon: const Icon(Icons.play_arrow, color: Colors.white, size: 24), // Play Icon
                              label: const Text("PLAY", style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),
                          );
                        }
                      }
                      return const SizedBox(); // Return an empty widget if no data
                    },
                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          show.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          genresText,
                          style: const TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          show.overview,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => _shareTvShow(show.name, show.overview, show.id),
                            icon: const Icon(Icons.share),
                            label: const Text("Share"),
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: tvShowRecommendationModel,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final recommendations = snapshot.data!;
                        return recommendations.results.isEmpty
                            ? const SizedBox()
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "More like this",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),

                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              scrollDirection: Axis.vertical,
                              itemCount: recommendations.results.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.55, // Adjusted to fit poster proportions
                              ),
                              itemBuilder: (context, index) {
                                final show = recommendations.results[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TvShowDetailScreen(showId: show.id),
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
                                            imageUrl: "$imageUrl${show.posterPath}",
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
                                            show.name,
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
                      return const Text("Something went wrong");
                    },
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
