//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:movflix/common/utils.dart';
// import 'package:movflix/models/movie_recommendation_model.dart';
// import 'package:movflix/models/search_model.dart';
// import 'package:movflix/screens/movie_detailed_screen.dart';
// import 'package:movflix/services/api_services.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   ApiServices apiServices = ApiServices();
//   TextEditingController searchController = TextEditingController();
//   SearchModel? searchedMovie;
//   late Future<MovieRecommendationsModel> popularMovies;
//   stt.SpeechToText speech = stt.SpeechToText();
//   bool isListening = false;
//
//   @override
//   void initState() {
//     popularMovies = apiServices.getPopularMovies();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   void search(String query) {
//     apiServices.getSearchedMovie(query).then((results) {
//       setState(() {
//         searchedMovie = results;
//       });
//     });
//   }
//
//   Future<void> _startListening() async {
//     bool available = await speech.initialize(
//       onStatus: (status) {
//         if (status == "done") {
//           setState(() => isListening = false);
//         }
//       },
//       onError: (error) {
//         setState(() => isListening = false);
//       },
//     );
//
//     if (available) {
//       setState(() => isListening = true);
//       speech.listen(
//         onResult: (result) {
//           setState(() {
//             searchController.text = result.recognizedWords;
//             search(searchController.text);
//           });
//         },
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: Stack(
//                 alignment: Alignment.centerRight,
//                 children: [
//                   CupertinoSearchTextField(
//                     controller: searchController,
//                     padding: const EdgeInsets.all(10.0),
//                     prefixIcon: const Icon(
//                       CupertinoIcons.search,
//                       color: Colors.grey,
//                     ),
//                     suffixIcon: const Icon(
//                       Icons.mic_none,
//                       color: Colors.transparent, // Hide default mic
//                     ),
//                     style: const TextStyle(color: Colors.white),
//                     backgroundColor: Colors.grey.withOpacity(0.3),
//                     onChanged: (value) {
//                       if (value.isNotEmpty) {
//                         search(searchController.text);
//                       }
//                     },
//                   ),
//                   GestureDetector(
//                     onTap: _startListening,
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: Icon(
//                         isListening ? Icons.mic : Icons.mic_none,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: searchController.text.isEmpty
//                     ? FutureBuilder<MovieRecommendationsModel>(
//                   future: popularMovies,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       var data = snapshot.data?.results;
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 20),
//                           const Text(
//                             "Top Searches",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 20),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: data!.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => MovieDetailScreen(
//                                           movieId: data[index].id,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     height: 120,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Image.network(
//                                           '$imageUrl${data[index].posterPath}',
//                                           fit: BoxFit.fitHeight,
//                                         ),
//                                         const SizedBox(width: 20),
//                                         Text(data[index].title)
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       );
//                     } else {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                   },
//                 )
//                     : searchedMovie == null
//                     ? const SizedBox.shrink()
//                     : GridView.builder(
//                   padding: EdgeInsets.zero,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: searchedMovie?.results.length ?? 0,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     mainAxisSpacing: 15,
//                     crossAxisSpacing: 5,
//                     childAspectRatio: 1.2 / 2,
//                   ),
//                   itemBuilder: (context, index) {
//                     return searchedMovie!.results[index].backdropPath == null
//                         ? Column(
//                       children: [
//                         Image.asset(
//                           "assets/netflix.png",
//                           height: 170,
//                         ),
//                         Text(
//                           searchedMovie!.results[index].title,
//                           maxLines: 2,
//                           style: const TextStyle(fontSize: 14),
//                         )
//                       ],
//                     )
//                         : Column(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => MovieDetailScreen(
//                                   movieId: searchedMovie!.results[index].id,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: CachedNetworkImage(
//                             imageUrl: '$imageUrl${searchedMovie?.results[index].backdropPath}',
//                             height: 170,
//                           ),
//                         ),
//                         Text(
//                           searchedMovie!.results[index].title,
//                           maxLines: 2,
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movflix/models/movie_recommendation_model.dart';
import 'package:movflix/models/search_model.dart';
import 'package:movflix/screens/movie_detailed_screen.dart';
import 'package:movflix/services/api_services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:movflix/common/utils.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ApiServices apiServices = ApiServices();
  TextEditingController searchController = TextEditingController();
  SearchModel? searchedMovie;
  late Future<MovieRecommendationsModel> popularMovies;
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;
  bool showListeningOverlay = false;

  @override
  void initState() {
    popularMovies = apiServices.getPopularMovies();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void search(String query) {
    apiServices.getSearchedMovie(query).then((results) {
      setState(() {
        searchedMovie = results;
      });
    });
  }

  Future<void> _startListening() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == "done") {
          setState(() => isListening = false);
          Navigator.pop(context); // Close "Listening..." dialog
        }
      },
      onError: (error) {
        setState(() => isListening = false);
        Navigator.pop(context); // Close "Listening..." dialog
      },
    );

    if (available) {
      setState(() {
        isListening = true;
        searchedMovie = null; // Clear previous results
        searchController.clear();
      });

      // Show "Listening..." dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mic, size: 50, color: Colors.red),
                const SizedBox(height: 10),
                const Text(
                  "Listening...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );

      speech.listen(
        onResult: (result) {
          setState(() {
            searchController.text = result.recognizedWords;
            search(searchController.text);
          });
        },
      );

      // Close dialog & stop listening after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        speech.stop();
        setState(() => isListening = false);
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Close "Listening..." dialog
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoSearchTextField(
                          controller: searchController,
                          padding: const EdgeInsets.all(10.0),
                          prefixIcon: const Icon(
                            CupertinoIcons.search,
                            color: Colors.grey,
                          ),
                          style: const TextStyle(color: Colors.white),
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              search(searchController.text);
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(isListening ? Icons.mic : Icons.mic_none, color: Colors.redAccent),
                        onPressed: _startListening,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: searchController.text.isEmpty
                      ? FutureBuilder<MovieRecommendationsModel>(
                    future: popularMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
                        return GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2 / 3,
                          ),
                          itemCount: snapshot.data!.results.length,
                          itemBuilder: (context, index) {
                            var movie = snapshot.data!.results[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(movieId: movie.id),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: '$imageUrl${movie.posterPath}',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: Text("No results found", style: TextStyle(color: Colors.white)));
                    },
                  )
                      : searchedMovie == null
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: searchedMovie?.results.length ?? 0,
                    itemBuilder: (context, index) {
                      var movie = searchedMovie!.results[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(movieId: movie.id),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: '$imageUrl${movie.posterPath}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (showListeningOverlay)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mic, size: 50, color: Colors.redAccent),
                    SizedBox(height: 10),
                    Text("Listening...", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
