import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './RecipeListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});
  @override
  State<SearchPage> createState() => _StatePage();
}

class _StatePage extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  List<dynamic> ingredients = [];
  List<dynamic> ingredients_found = [];
  List<dynamic> selected_ingredients = [];
  var token = 'abc';
  late FocusNode _focusNode;
  bool _isTextFieldSelected = false;
  bool _showIngredientList = true;
  Future<List<dynamic>> get_ingredients(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('TOKEN');
    print(token);
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    var url = Uri.parse('http://localhost:8000/get-ingredients?q=$query');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      ingredients = json.decode(response.body);
      print(_isTextFieldSelected);
      return ingredients;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void _onSearchTextChanged(String text) {
    get_ingredients(text).then((ingredients) {
      setState(() {
        ingredients_found = ingredients;
      });
    });
  }

  void _onFocusChange() {
    setState(() {
      _isTextFieldSelected = _focusNode.hasFocus;
      // _showIngredientList = _focusNode.hasFocus;
    });
  }

  @override
  initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(_onFocusChange);
    // get_token();
    get_ingredients('').then((ingredients) {
      setState(() {
        ingredients_found = ingredients;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchTextChanged,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusColor: Colors.amber[300],
                prefixIcon: Icon(Icons.emoji_food_beverage),
                suffixIcon: _isTextFieldSelected
                    ? IconButton(
                        onPressed: () {
                          setState(
                            () {
                              _searchController.clear();
                              _showIngredientList = false;
                            },
                          );
                        },
                        icon: Icon(Icons.close))
                    : Icon(Icons.search),
              ),
              focusNode: _focusNode,
              onTap: () {
                setState(() {
                  _showIngredientList = true;
                });
              },
            ),
          ),
          _showIngredientList
              ? Expanded(
                  child: ListView.builder(
                    itemCount: ingredients_found?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:
                            Text(ingredients_found![index]['name'].toString()),
                        // subtitle: Text(data[index]['ingredient'].toString()),
                        subtitle: Text(''),
                        selectedTileColor: Colors.amber,
                        trailing: !selected_ingredients.contains(
                                ingredients_found![index]['name'].toString())
                            ? IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    if (selected_ingredients.contains(
                                        ingredients_found![index]['name']
                                            .toString())) {
                                      selected_ingredients.remove(
                                          ingredients_found![index]['name']
                                              .toString());
                                      print(selected_ingredients);
                                      return;
                                    }
                                    selected_ingredients.add(
                                        ingredients_found![index]['name']
                                            .toString());
                                    print(selected_ingredients);
                                    _showIngredientList = false;
                                    // _onFocusChange();
                                    // _focusNode.addListener(_onFocusChange);
                                  });
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (selected_ingredients.contains(
                                        ingredients_found![index]['name']
                                            .toString())) {
                                      selected_ingredients.remove(
                                          ingredients_found![index]['name']
                                              .toString());
                                      print(selected_ingredients);
                                      return;
                                    }
                                  });
                                },
                              ),
                      );
                    },
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  height: 400,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 100,
                      mainAxisExtent: 50,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: selected_ingredients?.length ?? 0,
                    itemBuilder: (context, index) {
                      // return ListTile(
                      //   title: Text(selected_ingredients[index].toString()),
                      // );
                      return Chip(
                        label: Text(selected_ingredients[index].toString()),
                        deleteIcon: Icon(Icons.cancel),
                        onDeleted: () {
                          selected_ingredients
                              .remove(selected_ingredients![index].toString());
                          setState(() {});
                        },
                        // deleteIconColor: Colors.black,
                        backgroundColor: Colors.grey[350],
                      );
                    },
                  ),
                ),

          // Search Button
          _showIngredientList
              ? Container()
              : ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                  ),
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setInt('SearchMenu', 1);
                    setState(() {});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeListPage(
                            selected_ingredients: selected_ingredients),
                      ),
                    );
                  },
                  child: Text(
                    'Search',
                    style: TextStyle(fontSize: 20),
                  )),
        ],
      ),
    );
  }
}
