import 'package:flutter/material.dart';
import 'package:recipe/Main/Search/SearchMain.dart';
import 'package:recipe/Main/Search/SearchPage.dart';

import 'HomePage.dart';
import 'Setting/SettingPage.dart';

class EntryPage extends StatefulWidget {
  @override
  EntryPage({super.key});

  State<EntryPage> createState() => _EntryPage();
}

class _EntryPage extends State<EntryPage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  var tabs = [
    HomePage(),
    SearchPage(),
    // SearchMain(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe App'),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
