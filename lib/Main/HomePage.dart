import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/Main/RecipeDetailsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List<dynamic> recipes = [];
  Future<List<dynamic>> fetchAllRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var host = prefs.getString('HOST');
    // print('${host.toString()}/get-recipe-by-category');
    var url = Uri.parse('${host.toString()}/get-recipe-by-category');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      recipes = json.decode(response.body);
      return recipes;
    } else {
      print('Error : ${response.statusCode}');
      return recipes;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchAllRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FutureBuilder<List<dynamic>>(
              future: fetchAllRecipes(),
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
                    return Center(
                      child: Text(
                        'No Recipe Found',
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data?.length ?? 0,
                    itemBuilder: (context, index) {
                      List<dynamic>? recipes = data![index]['recipe'];
                      if (recipes == null || recipes.isEmpty) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data![index]['name'].toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('No recipes found'),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        );
                      }
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data![index]['name'].toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 200, // Adjust the height as needed
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: recipes.length,
                                itemBuilder: (context, i) {
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RecipeDetailsPage(
                                                    recipe: recipes,
                                                    index: i),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.network(
                                            'http://localhost:8000' +
                                                recipes[i]['image_url']
                                                    .toString(),
                                            width:
                                                120, // Adjust the width as needed
                                            height:
                                                120, // Adjust the height as needed
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(height: 10),
                                          recipes[i]['name'].length <= 18
                                              ? Text(
                                                  recipes[i]['name'].toString(),
                                                  textAlign: TextAlign.center,
                                                )
                                              : Text(
                                                  recipes[i]['name']
                                                          .toString()
                                                          .substring(0, 18) +
                                                      '...',
                                                  textAlign: TextAlign.center,
                                                ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),

      // FutureBuilder<List<dynamic>>(
      //   future: fetchAllRecipes(),
      //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (snapshot.hasError) {
      //       return Center(
      //         child: Text('Error: ${snapshot.error}'),
      //       );
      //     } else {
      //       List<dynamic>? data = snapshot.data;
      //       if (data?.length == 0) {
      //         return Center(
      //           child: Text(
      //             'No Recipe Found',
      //             style: TextStyle(fontSize: 30),
      //           ),
      //         );
      //       }
      //       return ListView.builder(
      //         itemCount: data?.length ?? 0,
      //         itemBuilder: (context, index) {
      //           List<dynamic> recipes = data![index]['recipe'];
      //           // String ingredientNames = '';

      //           // for (var ingredient in ingredients) {
      //           //   ingredientNames += ingredient['name'] + ', ';
      //           // }

      //           return Column(
      //             children: [
      //               Text(data![index]['name'].toString()),
      //               Expanded(
      //                 child: ListView.builder(
      //                   itemCount: recipes?.length ?? 0,
      //                   itemBuilder: (context, i) {
      //                     return SingleChildScrollView(
      //                       scrollDirection: Axis.horizontal,
      //                       child: Row(
      //                         children: [
      //                           Expanded(
      //                             child: Text(recipes![i]['name'].toString()),
      //                           )
      //                         ],
      //                       ),
      //                     );
      //                   },
      //                 ),
      //               )
      //             ],
      //           );
      //           // return InkWell(
      //           //   onTap: () {
      //           //     // print(data![index]);
      //           //     Navigator.push(
      //           //       context,
      //           //       MaterialPageRoute(
      //           //         builder: ((context) => RecipeDetailsPage(
      //           //               recipe: data,
      //           //               index: index,
      //           //             )),
      //           //       ),
      //           //     );
      //           //   },
      //           //   child: Container(
      //           //     // height: 300,
      //           //     margin: EdgeInsets.all(20),
      //           //     padding:
      //           //         EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      //           //     decoration: BoxDecoration(
      //           //       borderRadius: BorderRadius.circular(10),
      //           //       color: Colors.grey[200],
      //           //     ),
      //           //     child: Column(
      //           //       children: [
      //           //         Image.network(
      //           //           'http://localhost:8000' + data![index]['image_url'],
      //           //           height: 200,
      //           //         ),
      //           //         SizedBox(
      //           //           height: 20,
      //           //         ),
      //           //         Text(
      //           //           data![index]['name'].toString(),
      //           //           style: TextStyle(
      //           //             fontSize: 20,
      //           //           ),
      //           //         ),
      //           //       ],
      //           //     ),
      //           //   ),
      //           // );
      //         },
      //       );
      //     }
      //   },
      // ),
    );
  }
}
