import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RecipeDetailsPage extends StatefulWidget {
  List<dynamic> recipe = [];
  int index = 0;
  RecipeDetailsPage({required this.recipe, required this.index});
  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPage();
}

class _RecipeDetailsPage extends State<RecipeDetailsPage> {
  List<dynamic> recipe = [];
  int index = 0;
  String host = '';

  void fetchHost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    host = prefs.getString('HOST')!.toString();
    print(host);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchHost();
    recipe = widget.recipe;
    index = widget.index;
    // print(recipe[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(recipe[index]['name'])),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Image.network('http://localhost:8000${recipe[index]['image_url'].toString()}'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(recipe[index]['description']),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(recipe[index]['instructions']),
              ],
            ),
          ),
        ));
  }
}
