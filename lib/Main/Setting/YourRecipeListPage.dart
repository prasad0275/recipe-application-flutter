import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/Main/RecipeDetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourRecipeListPage extends StatefulWidget {
  YourRecipeListPage({super.key});
  @override
  State<YourRecipeListPage> createState() => _YourRecipeListPage();
}

class _YourRecipeListPage extends State<YourRecipeListPage> {
  List<dynamic> recipeList = [];
  Future<void> fetchRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String host = prefs.getString('HOST').toString();
    var user = prefs.getString('USERNAME').toString();
    var url = Uri.parse(host + '/post-recipe-by-user/$user');
    var headers = {'Content-Type': 'application/json'};
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      recipeList = jsonDecode(response.body);
    } else {
      print('Error : ' + response.statusCode.toString());
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Recipes'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView.builder(
          itemCount: recipeList.length,
          itemBuilder: (context, index) {
            var data = recipeList[index];
            return InkWell(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(Icons.dinner_dining_outlined),
                    title: Text(
                      data['name'].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: data['description'].toString().length < 50
                        ? Text(
                            data['description'].toString(),
                            style: TextStyle(fontSize: 15),
                          )
                        : Text(
                            data['description'].toString().substring(0, 50) +
                                "...",
                            style: TextStyle(fontSize: 15),
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) =>
                        RecipeDetailsPage(recipe: recipeList, index: index)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
