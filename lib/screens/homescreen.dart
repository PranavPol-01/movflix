import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movflix/common/utils.dart';
import 'package:movflix/models/movie_model.dart';
import 'package:movflix/models/tv_series_model.dart';
import 'package:movflix/screens/search_screen.dart';
import 'package:movflix/services/api_services.dart';
import 'package:movflix/widgets/upcoming_movie_card_widget.dart';
import 'package:movflix/screens/tv_show_detail_screen.dart';
import 'package:movflix/screens/video_player_screen.dart';
import 'package:movflix/models/tv_show_video_model.dart';
import 'package:movflix/screens/on_boarding_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiServices apiServices = ApiServices();

  late Future<MovieModel> upcomingFuture;
  late Future<MovieModel> nowPlaying;
  late Future<TvSeriesModel> topRatedShows;


  @override
  void initState() {
    upcomingFuture = apiServices.getUpcomingMovies();
    nowPlaying = apiServices.getNowPlayingMovies();
    topRatedShows = apiServices.getTopRatedSeries();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/logo.png',
          height: 50,
          width: 120,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(6),
          //   child: InkWell(
          //     onTap: () async {
          //       await FirebaseAuth.instance.signOut();
          //       Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (_) => OnBoardingScreen()),
          //             (route) => false,
          //       );
          //     },
          //     child: Container(
          //       color: Colors.red.shade800, // Change color to indicate logout
          //       height: 27,
          //       width: 27,
          //       child: Icon(Icons.logout, color: Colors.white, size: 20), // Logout icon
          //     ),
          //   ),
          // ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: () async {
                bool confirmLogout = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false), // Cancel logout
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true), // Confirm logout
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                );

                if (confirmLogout == true) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => OnBoardingScreen()),
                        (route) => false,
                  );
                }
              },
              child: Container(
                color: Colors.red.shade800,
                height: 27,
                width: 27,
                child: const Icon(Icons.logout, color: Colors.white, size: 20),
              ),
            ),
          ),

          const SizedBox(width: 20),

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            FutureBuilder<TvSeriesModel>(
              future: topRatedShows,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
                  return SizedBox(
                    // width: size.width,
                    height: (size.height * 0.6 < 300) ? 300 : size.height * 0.6,
                    child: PageView.builder(
                      itemCount: snapshot.data!.results.length,
                      controller: PageController(viewportFraction: snapshot.data!.results.length == 1 ? 1.0 : 0.9),
                      itemBuilder: (context, index) {

                        var show = snapshot.data!.results[index];
                        // print("Show Data: ${show.toJson()}"); // If show has a toJson() method

                        // return ClipRRect(
                        //   borderRadius: BorderRadius.circular(10),
                        //   child: Stack(
                        //     children: [
                        //       CachedNetworkImage(
                        //         imageUrl: "$imageUrl${show.backdropPath}",
                        //         fit: BoxFit.cover,
                        //         width: double.infinity,
                        //         height: double.infinity,
                        //       ),
                        //       Container(
                        //         decoration: BoxDecoration(
                        //           gradient: LinearGradient(
                        //             colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        //             begin: Alignment.bottomCenter,
                        //             end: Alignment.topCenter,
                        //           ),
                        //         ),
                        //       ),
                        //       Positioned(
                        //         bottom: 50,
                        //         left: 20,
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               show.name.toString(),
                        //               style: const TextStyle(
                        //                 fontSize: 24,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //             const SizedBox(height: 10),
                        //             Row(
                        //               children: [
                        //                 ElevatedButton.icon(
                        //                   onPressed: () async {
                        //                     try {
                        //                       TvShowVideo videoData = await apiServices.getTvShowVideos(show.id);
                        //                       if (videoData.results.isNotEmpty) {
                        //                         String videoKey = videoData.results.first.key;  // Get the first video key
                        //                         Navigator.push(
                        //                           context,
                        //                           MaterialPageRoute(
                        //                             builder: (context) => VideoPlayerScreen(videoKey: videoKey),
                        //                           ),
                        //                         );
                        //                       } else {
                        //                         ScaffoldMessenger.of(context).showSnackBar(
                        //                           const SnackBar(content: Text("No video available for this TV show")),
                        //                         );
                        //                       }
                        //                     } catch (e) {
                        //                       log("Error fetching video: $e");
                        //                       ScaffoldMessenger.of(context).showSnackBar(
                        //                         const SnackBar(content: Text("Failed to fetch video")),
                        //                       );
                        //                     }
                        //                   },
                        //                   icon: const Icon(Icons.play_arrow),
                        //                   label: const Text('Play'),
                        //                   style: ElevatedButton.styleFrom(
                        //                     backgroundColor: Colors.white,
                        //                     foregroundColor: Colors.black,
                        //                   ),
                        //                 ),
                        //
                        //                 const SizedBox(width: 10),
                        //                 ElevatedButton.icon(
                        //                   onPressed: () {
                        //                     Navigator.push(
                        //                       context,
                        //                       MaterialPageRoute(
                        //                         builder: (context) => TvShowDetailScreen(showId: show.id),
                        //                       ),
                        //                     );
                        //                   },
                        //
                        //                   icon: const Icon(Icons.play_arrow),
                        //                   label: const Text('info'),
                        //                   style: ElevatedButton.styleFrom(
                        //                     backgroundColor: Colors.white,
                        //                     foregroundColor: Colors.black,
                        //                   ),
                        //                 ),
                        //
                        //
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // );



                        return
                          Stack(
                            children: <Widget>[
                              // Background Image

                                 CachedNetworkImage(
                                imageUrl: "$imageUrl${show.backdropPath}",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),


                              // Dark Gradient Overlay
                              // Container(
                              //   decoration: BoxDecoration(
                              //     gradient: LinearGradient(
                              //       colors: [
                              //         Colors.black.withOpacity(0.8),
                              //         Colors.black.withOpacity(0.2),
                              //         Colors.transparent,
                              //       ],
                              //       begin: Alignment.bottomCenter,
                              //       end: Alignment.topCenter,
                              //     ),
                              //   ),
                              // ),

                              // 🎨 Smooth Bottom-Fading Gradient
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: [0.0, 0.15, 0.5, 1.0], // Adjusts the fading effect
                                    colors: [
                                      Theme.of(context).scaffoldBackgroundColor, // Matches the app background
                                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                                      Colors.transparent, // Merges at the top
                                    ],
                                  ),
                                ),
                              ),



                              // Netflix Logo (Optional)
                              // Positioned(
                              //   top: 50,
                              //   left: 20,
                              //   child: const Text(
                              //     "NETFLIX",
                              //     style: TextStyle(
                              //       color: Colors.red,
                              //       fontSize: 28,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),

                              // Title & Buttons
                              Positioned(
                                bottom: 90,
                                left: 20,
                                right: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      show.name.toString().toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        // Play Button
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            try {
                                              TvShowVideo videoData = await apiServices.getTvShowVideos(show.id);
                                              if (videoData.results.isNotEmpty) {
                                                String videoKey = videoData.results.first.key;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => VideoPlayerScreen(videoKey: videoKey),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("No video available for this TV show")),
                                                );
                                              }
                                            } catch (e) {
                                              log("Error fetching video: $e");
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text("Failed to fetch video")),
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.play_arrow, color: Colors.black),
                                          label: const Text("Play", style: TextStyle(color: Colors.black)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        // Info Button
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TvShowDetailScreen(showId: show.id),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.info_outline, color: Colors.white),
                                          label: const Text("Info", style: TextStyle(color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey.shade800,
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );

                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 240,
              child: UpcomingMovieCard(
                future: nowPlaying,
                headlineText: 'Now Playing',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 240,
              child: UpcomingMovieCard(
                future: upcomingFuture,
                headlineText: 'Upcoming Movies',
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

