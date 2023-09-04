import 'package:flutter/material.dart';
import 'package:recipe/Main/Search/SearchPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './RecipeListPage.dart';

class SearchMain extends StatefulWidget {
  SearchMain({super.key});
  @override
  State<SearchMain> createState() => _SearchMain();
}

class _SearchMain extends State<SearchMain> {
  int currentIndex = 0;
  var tabs = [
    SearchPage(),
    RecipeListPage(
      selected_ingredients: [],
    ),
  ];

  void searchPageChange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('SearchMenu', 0);
    currentIndex = prefs.getInt('SearchMenu')!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchPageChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentIndex],
    );
  }
}
