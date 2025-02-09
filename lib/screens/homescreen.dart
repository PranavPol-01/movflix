// import 'package:flutter/material.dart';
// import 'package:movflix/models/movie_model.dart';
// import 'package:movflix/models/tv_series_model.dart';
// import 'package:movflix/screens/search_screen.dart';
// import 'package:movflix/services/api_services.dart';
// import 'package:movflix/widgets/custom_carousel.dart';
// import 'package:movflix/widgets/upcoming_movie_card_widget.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//    ApiServices apiServices = ApiServices();
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
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Image.asset(
//           'assets/logo.png',
//           height: 50,
//           width: 120,
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20.0),
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SearchScreen(),
//                   ),
//                 );
//               },
//               child: const Icon(
//                 Icons.search,
//                 size: 30,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(6),
//             child: InkWell(
//               onTap: () {},
//               child: Container(
//                 color: Colors.blue,
//                 height: 27,
//                 width: 27,
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 20,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             FutureBuilder<TvSeriesModel>(
//               future: topRatedShows,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return CustomCarouselSlider(data: snapshot.data!);
//                 }
//                 return const SizedBox();
//               },
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//               height: 220,
//               child: UpcomingMovieCard(
//                 future: nowPlaying,
//                 headlineText: 'Now Playing',
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//               height: 220,
//               child: UpcomingMovieCard(
//                 future: upcomingFuture,
//                 headlineText: 'Upcoming Movies',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
            FutureBuilder<TvSeriesModel>(
              future: topRatedShows,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
                  return SizedBox(
                    width: size.width,
                    height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
                    child: PageView.builder(
                      itemCount: snapshot.data!.results.length,
                      controller: PageController(viewportFraction: 0.9),
                      itemBuilder: (context, index) {
                        var url = snapshot.data!.results[index].backdropPath.toString();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: "$imageUrl$url",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: Text(
                                    snapshot.data!.results[index].name.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      backgroundColor: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
