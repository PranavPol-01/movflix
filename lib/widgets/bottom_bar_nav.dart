import 'package:flutter/material.dart';
import 'package:movflix/screens/download_screen.dart';
import 'package:movflix/screens/homescreen.dart';
import 'package:movflix/screens/news_and_hot.dart';
import 'package:movflix/screens/search_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.black,
          height: 70,
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.search),
                text: "Search",
              ),
              Tab(
                icon: Icon(Icons.photo_library_outlined),
                text: "New & Hot",
              ),
              // Tab(
              //   icon: Icon(Icons.download),
              //   text: "Downloads",
              // ),
            ],
            unselectedLabelColor: Color(0xFF999999),
            labelColor: Colors.white,
             indicatorColor: Colors.transparent,
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            SearchScreen(),
            MoreScreen(),
            // DownloadScreen()
          ],
        ),
      ),
    );
  }
}