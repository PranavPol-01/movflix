// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:movflix/common/utils.dart';
// import 'package:movflix/models/movie_recommendation_model.dart';
// import 'package:movflix/models/search_model.dart';
// import 'package:movflix/screens/movie_detailed_screen.dart';
// import 'package:movflix/services/api_services.dart';
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
//
//   void search(String query) {
//     apiServices.getSearchedMovie(query).then((results) {
//       setState(() {
//         searchedMovie = results;
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     popularMovies = apiServices.getPopularMovies();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     searchController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               CupertinoSearchTextField(
//                 controller: searchController,
//                 padding: const EdgeInsets.all(10.0),
//                 prefixIcon: const Icon(
//                   CupertinoIcons.search,
//                   color: Colors.grey,
//                 ),
//                 suffixIcon: const Icon(
//                   Icons.cancel,
//                   color: Colors.grey,
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 backgroundColor: Colors.grey.withOpacity(0.3),
//                 onChanged: (value) {
//                   if (value.isEmpty) {
//                   } else {
//                     search(searchController.text);
//                   }
//                 },
//               ),
//               searchController.text.isEmpty
//                   ? FutureBuilder<MovieRecommendationsModel>(
//                 future: popularMovies,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     var data = snapshot.data?.results;
//                     return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           const Text(
//                             "Top Searches",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             // padding: const EdgeInsets.all(3),
//                             scrollDirection: Axis.vertical,
//                             itemCount: data!.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             MovieDetailScreen(
//                                               movieId: data[index].id,
//                                             ),
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     height: 120,
//                                     decoration: BoxDecoration(
//                                         borderRadius:
//                                         BorderRadius.circular(20)),
//                                     child: Row(
//                                       children: [
//                                         Image.network(
//                                           '$imageUrl${data[index].posterPath}',
//                                           fit: BoxFit.fitHeight,
//                                         ),
//                                         const SizedBox(
//                                           width: 20,
//                                         ),
//                                         Text(data[index].title)
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           )
//                         ]);
//                   } else {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 },
//               )
//                   : searchedMovie == null
//                   ? const SizedBox.shrink()
//                   : GridView.builder(
//                 padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: searchedMovie?.results.length,
//                 gridDelegate:
//                 const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 15,
//                   crossAxisSpacing: 5,
//                   childAspectRatio: 1.2 / 2,
//                 ),
//                 itemBuilder: (context, index) {
//                   return searchedMovie!.results[index].backdropPath ==
//                       null
//                       ? Column(
//                     children: [
//                       Image.asset(
//                         "assets/netflix.png",
//                         height: 170,
//                       ),
//                       Text(
//                         searchedMovie!.results[index].title,
//                         maxLines: 2,
//                         style: const TextStyle(
//                           fontSize: 14,
//                         ),
//                       )
//                     ],
//                   )
//                       : Column(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   MovieDetailScreen(
//                                       movieId: searchedMovie!
//                                           .results[index].id),
//                             ),
//                           );
//                         },
//                         child: CachedNetworkImage(
//                           imageUrl:
//                           '$imageUrl${searchedMovie?.results[index].backdropPath}',
//                           height: 170,
//                         ),
//                       ),
//                       Text(
//                         searchedMovie!.results[index].title,
//                         maxLines: 2,
//                         style: const TextStyle(
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
//   stt.SpeechToText speech = stt.SpeechToText(); // Speech recognition
//   bool isListening = false; // Voice status
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
//             search(searchController.text); // Start search automatically
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
//                 children: [
//                   CupertinoSearchTextField(
//                     controller: searchController,
//                     padding: const EdgeInsets.all(10.0),
//                     prefixIcon: const Icon(
//                       CupertinoIcons.search,
//                       color: Colors.grey,
//                     ),
//                     suffixIcon: const Icon( // Keep suffixIcon as an Icon (required)
//                       Icons.mic_none,
//                       color: Colors.grey,
//                     ),
//                     style: const TextStyle(color: Colors.white),
//                     backgroundColor: Colors.grey.withOpacity(0.3),
//                     onChanged: (value) {
//                       if (value.isNotEmpty) {
//                         search(searchController.text);
//                       }
//                     },
//                   ),
//                   Positioned(
//                     right: 10, // Adjust position
//                     top: 5, // Align with text field
//                     child: GestureDetector(
//                       onTap: _startListening, // Start voice search
//                       child: Icon(
//                         isListening ? Icons.mic : Icons.mic_none, // Toggle mic icon
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child:               searchController.text.isEmpty
//                   ? FutureBuilder<MovieRecommendationsModel>(
//                 future: popularMovies,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     var data = snapshot.data?.results;
//                     return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           const Text(
//                             "Top Searches",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             // padding: const EdgeInsets.all(3),
//                             scrollDirection: Axis.vertical,
//                             itemCount: data!.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             MovieDetailScreen(
//                                               movieId: data[index].id,
//                                             ),
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     height: 120,
//                                     decoration: BoxDecoration(
//                                         borderRadius:
//                                         BorderRadius.circular(20)),
//                                     child: Row(
//                                       children: [
//                                         Image.network(
//                                           '$imageUrl${data[index].posterPath}',
//                                           fit: BoxFit.fitHeight,
//                                         ),
//                                         const SizedBox(
//                                           width: 20,
//                                         ),
//                                         Text(data[index].title)
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           )
//                         ]);
//                   } else {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 },
//               )
//                   : searchedMovie == null
//                   ? const SizedBox.shrink()
//                   : GridView.builder(
//                 padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: searchedMovie?.results.length,
//                 gridDelegate:
//                 const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 15,
//                   crossAxisSpacing: 5,
//                   childAspectRatio: 1.2 / 2,
//                 ),
//                 itemBuilder: (context, index) {
//                   return searchedMovie!.results[index].backdropPath ==
//                       null
//                       ? Column(
//                     children: [
//                       Image.asset(
//                         "assets/netflix.png",
//                         height: 170,
//                       ),
//                       Text(
//                         searchedMovie!.results[index].title,
//                         maxLines: 2,
//                         style: const TextStyle(
//                           fontSize: 14,
//                         ),
//                       )
//                     ],
//                   )
//                       : Column(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   MovieDetailScreen(
//                                       movieId: searchedMovie!
//                                           .results[index].id),
//                             ),
//                           );
//                         },
//                         child: CachedNetworkImage(
//                           imageUrl:
//                           '$imageUrl${searchedMovie?.results[index].backdropPath}',
//                           height: 170,
//                         ),
//                       ),
//                       Text(
//                         searchedMovie!.results[index].title,
//                         maxLines: 2,
//                         style: const TextStyle(
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               )
//               ],
//             ),
//       ),
//     );
//
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movflix/common/utils.dart';
import 'package:movflix/models/movie_recommendation_model.dart';
import 'package:movflix/models/search_model.dart';
import 'package:movflix/screens/movie_detailed_screen.dart';
import 'package:movflix/services/api_services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
        }
      },
      onError: (error) {
        setState(() => isListening = false);
      },
    );

    if (available) {
      setState(() => isListening = true);
      speech.listen(
        onResult: (result) {
          setState(() {
            searchController.text = result.recognizedWords;
            search(searchController.text);
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  CupertinoSearchTextField(
                    controller: searchController,
                    padding: const EdgeInsets.all(10.0),
                    prefixIcon: const Icon(
                      CupertinoIcons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: const Icon(
                      Icons.mic_none,
                      color: Colors.transparent, // Hide default mic
                    ),
                    style: const TextStyle(color: Colors.white),
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        search(searchController.text);
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: _startListening,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: searchController.text.isEmpty
                    ? FutureBuilder<MovieRecommendationsModel>(
                  future: popularMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data?.results;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Top Searches",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
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
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.network(
                                          '$imageUrl${data[index].posterPath}',
                                          fit: BoxFit.fitHeight,
                                        ),
                                        const SizedBox(width: 20),
                                        Text(data[index].title)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
                    : searchedMovie == null
                    ? const SizedBox.shrink()
                    : GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchedMovie?.results.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1.2 / 2,
                  ),
                  itemBuilder: (context, index) {
                    return searchedMovie!.results[index].backdropPath == null
                        ? Column(
                      children: [
                        Image.asset(
                          "assets/netflix.png",
                          height: 170,
                        ),
                        Text(
                          searchedMovie!.results[index].title,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    )
                        : Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(
                                  movieId: searchedMovie!.results[index].id,
                                ),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: '$imageUrl${searchedMovie?.results[index].backdropPath}',
                            height: 170,
                          ),
                        ),
                        Text(
                          searchedMovie!.results[index].title,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

