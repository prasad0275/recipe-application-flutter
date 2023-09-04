import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:recipe/Authentication/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostRecipePage extends StatefulWidget {
  PostRecipePage({super.key});
  @override
  State<PostRecipePage> createState() => _PostRecipePage();
}

class _PostRecipePage extends State<PostRecipePage> {
  var name = TextEditingController();
  var instructions = TextEditingController();
  var cooking_time = TextEditingController();
  var description = TextEditingController();
  var user = TextEditingController();
  var image_url = TextEditingController();

  String message = '';
  bool success = false;


  Future<bool> postRecipe() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var body = {
      "name": name.text.toString(),
      "instructions": instructions.text.toString(),
      "cooking_time": cooking_time.text.toString(),
      "description": description.text.toString(),
      "user": pref.getString('USERNAME').toString()
    };

    var headers = {'Content-Type': 'application/json'};

    var url =
        Uri.parse(pref.getString('HOST').toString() + '/post-recipe-by-user');

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 409) {
      return false;
    } else {
      print('Post request failed with status: ${response.statusCode}');
      print(response.body);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Recipe'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              success
                  ? Text(
                      '$message',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                      ),
                    )
                  : Text(
                      '$message',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.abc),
                  hintText: 'Name of recipe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusColor: Colors.amber[300],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: description,
                minLines: 5,
                maxLines: 7,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.note),
                  hintText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusColor: Colors.amber[300],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: instructions,
                minLines: 5,
                maxLines: 7,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.notes),
                  hintText: 'Instructions',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusColor: Colors.amber[300],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: cooking_time,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.watch_later_rounded),
                  hintText: 'Cooking Time in Minutes',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusColor: Colors.amber[300],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                ),
                onPressed: () async {
                  if (await postRecipe()) {
                    success = true;
                    message = 'Recipe posted successfully';
                  } else {
                    success = false;
                    message = 'Invalid post request';
                  }
                  setState(() {});
                },
                child: Text(
                  'Post',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ]),
      ),
    );
  }
}
