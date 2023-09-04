import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/Main/RecipeDetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../BottNav.dart';
import '../../Model/RecipeModel.dart';

class RecipeListPage extends StatefulWidget {
  List<dynamic> selected_ingredients;
  RecipeListPage({required this.selected_ingredients});
  @override
  State<RecipeListPage> createState() => _RecipeListPage();
}

class _RecipeListPage extends State<RecipeListPage> {
  List<dynamic> selected_ingredients = [];
  List<dynamic> recipes = [];
  Future<List<dynamic>> fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var body = {"data": selected_ingredients};
    print(body);
    var url = Uri.parse(
        pref.getString("HOST").toString() + '/get-recipe-by-ingredients');
    var response = await http.post(url, body: json.encode(body));
    print("api calls");
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("data got");
      // for (Map<String, dynamic> i in data) {
      //   print(RecipeModel.fromJson(i));
      //   recipes.add(RecipeModel.fromJson(i));
      // }
      // print(recipes["name"].toString());
      recipes = data;
      return recipes;
    } else {
      print("no data");
      return recipes;
    }
  }

  int _currentIndex = 1;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected_ingredients = widget.selected_ingredients;
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<dynamic>? data = snapshot.data;
              if (data?.length == 0) {
                return Center(child:Text('No Recipe Found',style: TextStyle(fontSize: 30),),);
              }
              return ListView.builder(
                itemCount: data?.length ?? 0,
                itemBuilder: (context, index) {
                  List<dynamic> ingredients = data![index]['ingredient'];
                  String ingredientNames = '';

                  for (var ingredient in ingredients) {
                    ingredientNames += ingredient['name'] + ', ';
                  }

                  // return ListTile(
                  //   title: Text(data![index]['name'].toString()),
                  //   // subtitle: Text(data[index]['ingredient'].toString()),
                  //   subtitle: Image.network(
                  //     'http://localhost:8000'+data![index]['image_url'],
                  //     height: 200,
                  //   ),
                  // );
                  return InkWell(
                    onTap: () {
                      // print(data![index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => RecipeDetailsPage(
                                recipe: data,
                                index: index,
                              )),
                        ),
                      );
                    },
                    child: Container(
                      // height: 300,
                      margin: EdgeInsets.all(20),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: Column(
                        children: [
                          Image.network(
                            'http://localhost:8000' + data![index]['image_url'],
                            height: 200,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            data![index]['name'].toString(),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
