// import 'package:flutter/material.dart';
// import 'package:movflix/common/utils.dart';
// import 'package:movflix/models/movie_model.dart';
// import 'package:movflix/screens/movie_detailed_screen.dart';
//
// class UpcomingMovieCard extends StatelessWidget {
//   final Future<MovieModel> future;
//
//   final String headlineText;
//   const UpcomingMovieCard({
//     super.key,
//     required this.future,
//     required this.headlineText,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<MovieModel>(
//         future: future,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             var data = snapshot.data?.results;
//             return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     headlineText,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       // padding: const EdgeInsets.all(3),
//                       scrollDirection: Axis.horizontal,
//                       itemCount: data!.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => MovieDetailScreen(
//                                       movieId: data[index].id,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20)),
//                                 child: Image.network(
//                                   '$imageUrl${data[index].posterPath}',
//                                   fit: BoxFit.fitHeight,
//                                 ),
//                               ),
//                             ));
//                       },
//                     ),
//                   )
//                 ]);
//           } else {
//             return const SizedBox.shrink();
//           }
//         });
//   }
// }

import 'package:flutter/material.dart';
import 'package:movflix/common/utils.dart';
import 'package:movflix/models/movie_model.dart';
import 'package:movflix/screens/movie_detailed_screen.dart';

class UpcomingMovieCard extends StatelessWidget {
  final Future<MovieModel> future;
  final String headlineText;

  const UpcomingMovieCard({
    super.key,
    required this.future,
    required this.headlineText,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieModel>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data?.results ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    headlineText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Movie Cards List
                SizedBox(
                  height: 200, // Ensures it does not take unlimited height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(
                                  movieId: data[index].id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                '$imageUrl${data[index].posterPath}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
