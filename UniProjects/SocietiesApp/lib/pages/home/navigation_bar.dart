import 'package:flutter/material.dart';
import 'package:society_app/pages/home/news_feed_page.dart';
import 'package:society_app/pages/home/calendar_page.dart';
import 'package:society_app/pages/home/search_page.dart';
import 'package:society_app/pages/home/my_societies_page.dart';

// Navigation bar to switch between pages of the applications pages, at bottom
// of every page
// Author -

class Navigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  //Nav bar pages
  final List<Widget> _children = [
    NewsFeed(),
    Calendar(),
    SearchPage(),
    MySocieties(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Build navbar and selected page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'My Societies',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
