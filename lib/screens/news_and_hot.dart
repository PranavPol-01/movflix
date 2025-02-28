// import 'package:flutter/material.dart';
// import 'package:movflix/widgets/coming_soon_movie_widget.dart';
//
// class MoreScreen extends StatefulWidget {
//   const MoreScreen({super.key});
//
//   @override
//   State<MoreScreen> createState() => _MoreScreenState();
// }
//
// class _MoreScreenState extends State<MoreScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.black,
//             title: const Text(
//               'New & Hot',
//               style: TextStyle(color: Colors.white),
//             ),
//             actions: [
//               const Padding(
//                 padding: EdgeInsets.only(right: 10.0),
//                 child: Icon(
//                   Icons.cast,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//                 child: Container(
//                   color: Colors.blue,
//                   height: 27,
//                   width: 27,
//                 ),
//               ),
//               const SizedBox(
//                 width: 20,
//               ),
//             ],
//             bottom: TabBar(
//               dividerColor: Colors.black,
//               isScrollable: false,
//               indicator: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white,
//               ),
//               labelColor: Colors.black,
//               labelStyle:
//               const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//               unselectedLabelColor: Colors.white,
//               tabs: const [
//                 Tab(
//                   text: '  🍿 Coming Soon  ',
//                 ),
//                 Tab(
//                   text: "  🔥 Everyone's watching  ",
//                 ),
//               ],
//             ),
//           ),
//           body: const TabBarView(children: [
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   ComingSoonMovieWidget(
//                     imageUrl:
//                     'https://miro.medium.com/v2/resize:fit:1024/1*P_YU8dGinbCy6GHlgq5OQA.jpeg',
//                     overview:
//                     'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.',
//                     logoUrl:
//                     "https://s3.amazonaws.com/www-inside-design/uploads/2017/10/strangerthings_feature-983x740.jpg",
//                     month: "Jun",
//                     day: "19",
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   ComingSoonMovieWidget(
//                     imageUrl:
//                     'https://www.pinkvilla.com/images/2022-09/rrr-review.jpg',
//                     overview:
//                     'A fearless revolutionary and an officer in the British force, who once shared a deep bond, decide to join forces and chart out an inspirational path of freedom against the despotic rulers.',
//                     logoUrl:
//                     "https://www.careerguide.com/career/wp-content/uploads/2023/10/RRR_full_form-1024x576.jpg",
//                     month: "Mar",
//                     day: "07",
//                   ),
//                 ],
//               ),
//             ),
//             ComingSoonMovieWidget(
//               imageUrl:
//               'https://miro.medium.com/v2/resize:fit:1024/1*P_YU8dGinbCy6GHlgq5OQA.jpeg',
//               overview:
//               'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces, and one strange little girl.',
//               logoUrl:
//               "https://logowik.com/content/uploads/images/stranger-things4286.jpg",
//               month: "Feb",
//               day: "20",
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:movflix/widgets/coming_soon_movie_widget.dart';
// import 'package:movflix/services/api_services.dart';
// import 'package:movflix/models/upcoming_movie_model.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// class MoreScreen extends StatefulWidget {
//   const MoreScreen({super.key});
//
//   @override
//   State<MoreScreen> createState() => _MoreScreenState();
// }
//
// class _MoreScreenState extends State<MoreScreen> {
//   late Future<UpComingMovies> _upcomingMovies;
//
//   @override
//   void initState() {
//     super.initState();
//     _upcomingMovies = ApiServices().getUpComingMovies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.black,
//             title: const Text(
//               'New & Hot',
//               style: TextStyle(color: Colors.white),
//             ),
//             actions: [
//               const Padding(
//                 padding: EdgeInsets.only(right: 10.0),
//                 child: Icon(
//                   Icons.cast,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//                 child: Container(
//                   color: Colors.blue,
//                   height: 27,
//                   width: 27,
//                 ),
//               ),
//               const SizedBox(width: 20),
//             ],
//             bottom: TabBar(
//               dividerColor: Colors.black,
//               isScrollable: false,
//               indicator: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.white,
//               ),
//               labelColor: Colors.black,
//               labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//               unselectedLabelColor: Colors.white,
//               tabs: const [
//                 Tab(text: '  🍿 Coming Soon  '),
//                 Tab(text: "  🔥 Everyone's watching  "),
//               ],
//             ),
//           ),
//           body: TabBarView(children: [
//             FutureBuilder<UpComingMovies>(
//               future: _upcomingMovies,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text("Error loading movies"));
//                 } else {
//                   var movies = snapshot.data?.results ?? [];
//                   return SingleChildScrollView(
//                     child: Column(
//                       children: movies.map((movie) => ComingSoonMovieWidget(
//                         imageUrl: '$imageUrl${movie.posterPath}',
//                         overview: movie.overview,
//                         logoUrl: '$imageUrl${movie.backdropPath}',
//                         month: movie.releaseDate.month.toString(),
//                         day: movie.releaseDate.day.toString(),
//                       )).toList(),
//                     ),
//                   );
//                 }
//               },
//             ),
//             Center(child: Text("🔥 Everyone's watching")),
//           ]),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movflix/widgets/coming_soon_movie_widget.dart';
import 'package:movflix/models/upcoming_movie_model.dart';
import 'package:movflix/services/api_services.dart';
import 'package:movflix/screens/movie_detailed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movflix/screens/on_boarding_screen.dart';


class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  List<Result> upcomingMovies = [];



  @override
  void initState() {
    super.initState();
    loadUpcomingMovies();
  }

  Future<void> loadUpcomingMovies() async {
    try {
      final movies = await ApiServices.getUpComingMovies();
      if (movies.isNotEmpty) {
        setState(() {
          upcomingMovies = movies;
        });
      } else {
        print("No upcoming movies available.");
      }
    } catch (e, stackTrace) {
      print('Error loading upcoming movies: $e');
      print(stackTrace);
    }
  }

// Function to show the logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) =>  OnBoardingScreen()),
                      (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            title: const Text(
              'New & Hot',
              style: TextStyle(color: Colors.white),
            ),
            actions:  [
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(Icons.cast, color: Colors.white),
              ),
              SizedBox(width: 10),

              InkWell(
                onTap: () => _showLogoutDialog(context), // Show confirmation dialog
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade800,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  height: 30,
                  width: 30,
                  child: const Icon(Icons.logout, color: Colors.white, size: 20),
                ),
              ),
              SizedBox(width: 20),
            ],
            // bottom: TabBar(
            //   dividerColor: Colors.black,
            //   indicator: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //     color: Colors.white,
            //   ),
            //   labelColor: Colors.black,
            //   labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            //   unselectedLabelColor: Colors.white,
            //   tabs: const [
            //     Tab(text: "  🍿 Everyone's Watching")
            //   ],
            // ),
          ),

          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: upcomingMovies.map((movie) => ComingSoonMovieWidget(
                    imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    overview: movie.overview,
                    logoUrl: 'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                    month: movie.releaseDate.month.toString(),
                    day: movie.releaseDate.day.toString(),
                    movieId: movie.id, // Pass movieId for navigation
                  )).toList(),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}



class ComingSoonMovieWidget extends StatelessWidget {
  final String imageUrl;
  final String overview;
  final String logoUrl;
  final String month;
  final String day;
  final int movieId; // Add movieId for navigation

  const ComingSoonMovieWidget({
    super.key,
    required this.imageUrl,
    required this.overview,
    required this.logoUrl,
    required this.month,
    required this.day,
    required this.movieId, // Pass movieId
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Text(month, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40, letterSpacing: 5)),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(movieId: movieId),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CachedNetworkImage(imageUrl: logoUrl, alignment: Alignment.centerLeft, height: 45),
                    const SizedBox(width: 10),
                    // Text('Watch Now', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(movieId: movieId),
                          ),
                        );
                      },
                      child: Text(
                        'Watch Now',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                          color: Colors.red, // Make it visually distinct
                          // decoration: TextDecoration.underline, // Optional underline
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 10),
                Text(overview, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 12.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
