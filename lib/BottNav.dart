import 'package:flutter/material.dart';

import 'Main/HomePage.dart';
import 'Main/Search/SearchPage.dart';
import 'Main/Setting/SettingPage.dart';

class BottNav extends StatefulWidget {
  int currentIndex;
  BottNav({required this.currentIndex});

  @override
  State<BottNav> createState() => _BottNav();
}

class _BottNav extends State<BottNav> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(),
          ),
        );
      }
    });
  }

  var tabs = [
    HomePage(),
    SearchPage(),
    SettingPage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int _currentIndex = widget.currentIndex;
    print('current index is : $_currentIndex');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}
