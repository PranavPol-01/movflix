
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movflix/common/utils.dart';
import 'package:movflix/models/movie_model.dart';
import 'package:movflix/models/tv_series_model.dart';
import 'package:movflix/screens/search_screen.dart';
import 'package:movflix/services/api_services.dart';
import 'package:movflix/widgets/upcoming_movie_card_widget.dart';

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
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: () {},
              child: Container(
                color: Colors.blue,
                height: 27,
                width: 27,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // FutureBuilder<TvSeriesModel>(
            //   future: topRatedShows,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const CircularProgressIndicator();
            //     }
            //     if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
            //       return SizedBox(
            //         width: size.width,
            //         height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
            //         child: PageView.builder(
            //           itemCount: snapshot.data!.results.length,
            //           controller: PageController(viewportFraction: 0.9),
            //           itemBuilder: (context, index) {
            //             var url = snapshot.data!.results[index].backdropPath.toString();
            //             return Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(10),
            //                 child: Stack(
            //                   children: [
            //                     CachedNetworkImage(
            //                       imageUrl: "$imageUrl$url",
            //                       fit: BoxFit.cover,
            //                       width: double.infinity,
            //                       height: double.infinity,
            //                     ),
            //                     Positioned(
            //                       bottom: 20,
            //                       left: 20,
            //                       child: Text(
            //                         snapshot.data!.results[index].name.toString(),
            //                         style: const TextStyle(
            //                           fontSize: 20,
            //                           fontWeight: FontWeight.bold,
            //                           color: Colors.white,
            //                           backgroundColor: Colors.black54,
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       );
            //     }
            //     return const SizedBox();
            //   },
            // ),
            FutureBuilder<TvSeriesModel>(
              future: topRatedShows,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
                  return SizedBox(
                    // width: size.width,
                    height: (size.height * 0.5 < 300) ? 300 : size.height * 0.5,
                    child: PageView.builder(
                      itemCount: snapshot.data!.results.length,
                      controller: PageController(viewportFraction: snapshot.data!.results.length == 1 ? 1.0 : 0.9),
                      itemBuilder: (context, index) {
                        var show = snapshot.data!.results[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: "$imageUrl${show.backdropPath}",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 50,
                                left: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      show.name.toString(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.play_arrow),
                                          label: const Text('Play'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.info_outline),
                                          label: const Text('Info'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[800],
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: UpcomingMovieCard(
                future: nowPlaying,
                headlineText: 'Now Playing',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: UpcomingMovieCard(
                future: upcomingFuture,
                headlineText: 'Upcoming Movies',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:movflix/common/utils.dart';
// import 'package:movflix/models/movie_model.dart';
// import 'package:movflix/models/tv_series_model.dart';
// import 'package:movflix/screens/search_screen.dart';
// import 'package:movflix/services/api_services.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   ApiServices apiServices = ApiServices();
//
//   late Future<MovieModel> upcomingFuture;
//   late Future<MovieModel> nowPlaying;
//   late Future<TvSeriesModel> topRatedShows;
//
//   @override
//   void initState() {
//     upcomingFuture = apiServices.getUpcomingMovies();
//     nowPlaying = apiServices.getNowPlayingMovies();
//     topRatedShows = apiServices.getTopRatedSeries();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Image.asset(
//           'assets/logo.png',
//           height: 50,
//           width: 120,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, size: 30, color: Colors.white),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const SearchScreen()),
//               );
//             },
//           ),
//           const SizedBox(width: 20),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Featured Content
//             FutureBuilder<TvSeriesModel>(
//               future: topRatedShows,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
//                   var featured = snapshot.data!.results[0];
//                   return Stack(
//                     children: [
//                       CachedNetworkImage(
//                         imageUrl: "$imageUrl${featured.backdropPath}",
//                         height: size.height * 0.5,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                       Container(
//                         height: size.height * 0.5,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.black.withOpacity(0.6), Colors.transparent],
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 50,
//                         left: 20,
//                         right: 20,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               featured.name.toString(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             const Text(
//                               'Gritty · Dark · Thriller · Crime',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Row(
//                               children: [
//                                 ElevatedButton.icon(
//                                   onPressed: () {},
//                                   icon: const Icon(Icons.play_arrow),
//                                   label: const Text('Play'),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.white, // Use backgroundColor instead of primary
//                                     foregroundColor: Colors.black, // Text and icon color
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 ElevatedButton.icon(
//                                   onPressed: () {},
//                                   icon: const Icon(Icons.info_outline),
//                                   label: const Text('Info'),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.grey[800], // Use backgroundColor instead of primary
//                                     foregroundColor: Colors.white, // Text and icon color
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//                 return const SizedBox();
//               },
//             ),
//             const SizedBox(height: 20),
//
//             // Carousel Preview
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 'Previews',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 120,
//               child: FutureBuilder<TvSeriesModel>(
//                 future: topRatedShows,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
//                     return ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: snapshot.data!.results.length,
//                       itemBuilder: (context, index) {
//                         var show = snapshot.data!.results[index];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Column(
//                             children: [
//                               CircleAvatar(
//                                 radius: 40,
//                                 backgroundImage: NetworkImage("$imageUrl${show.posterPath}"),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 show.name!,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }
//                   return const SizedBox();
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // "Now Playing" Section
//             SizedBox(
//               height: 220,
//               child: FutureBuilder<MovieModel>(
//                 future: nowPlaying,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
//                     return ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: snapshot.data!.results.length,
//                       itemBuilder: (context, index) {
//                         var movie = snapshot.data!.results[index];
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               CachedNetworkImage(
//                                 imageUrl: "$imageUrl${movie.posterPath}",
//                                 height: 150,
//                                 width: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 movie.title!,
//                                 style: const TextStyle(color: Colors.white),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }
//                   return const SizedBox();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
