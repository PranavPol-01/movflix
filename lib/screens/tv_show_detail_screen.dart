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
                        height: size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("$imageUrl${show.posterPath}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SafeArea(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: tvShowVideo,
                    builder: (context, videoSnapshot) {
                      if (videoSnapshot.hasData) {
                        final videoData = videoSnapshot.data!;
                        if (videoData.results.isNotEmpty) {
                          return ElevatedButton.icon(
                            onPressed: () => playVideo(videoData.results.first.key),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Play'),
                          );
                        }
                      }
                      return const SizedBox();
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
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
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: recommendations.results.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 15,
                                childAspectRatio: 1.5 / 2,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TvShowDetailScreen(
                                            showId: recommendations.results[index].id),
                                      ),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: "$imageUrl${recommendations.results[index].posterPath}",
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
