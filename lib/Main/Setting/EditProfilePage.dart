import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/Main/Setting/SettingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  var error_message = '';
  var success_message = '';
  var message = '';
  bool success = false;
  // all fields controllers
  var username = TextEditingController();
  var email = TextEditingController();
  var first_name = TextEditingController();
  var last_name = TextEditingController();

  var user_data = {};

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('USERNAME');
    var url = Uri.parse(prefs.getString('HOST').toString() +
        '/user-utilitise/' +
        user.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      user_data = jsonDecode(response.body);
      username = TextEditingController(text: user_data['username']);
      email = TextEditingController(text: user_data['email']);
      first_name = TextEditingController(text: user_data['first_name']);
      last_name = TextEditingController(text: user_data['last_name']);
      setState(() {});
      return;
    } else {
      print('Error : ' + response.statusCode.toString());
      return;
    }
  }

  Future<void> updateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(prefs.getString("HOST").toString() + '/user-utilitise');
    print(url);
    var headers = {
      'Content-Type': 'application/json',
    };
    var data = {
      "id": user_data['id'] as int,
      "email": email.text.toString(),
      "first_name": first_name.text.toString(),
      "last_name": last_name.text.toString(),
    };

    var body = jsonEncode(data);
    print(body);
    var response = await http.patch(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      success = true;
      message = 'Details Successfully Updated';
      setState(() {});
      return;
    } else {
      print('Error : ' + response.statusCode.toString());
      success = false;
      message = 'Invalid Details';
      setState(() {});
      return;
    }
  }

  bool validEmail() {
    String test = email.text.toString();
    var temp = '@';
    if (test.contains(RegExp(r'[A-z]'), 0)) {
      if (test.contains('@')) {
        return true;
      }
      else{
        return false;
      }
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              success
                  ? Text(
                      '$message',
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    )
                  : Text(
                      '$message',
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ),
              SizedBox(
                height: 10,
              ),
              TextField(
                readOnly: true,
                controller: username,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Username',
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
                controller: email,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
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
                controller: first_name,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.sentiment_very_satisfied_outlined),
                  hintText: 'First Name',
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
                controller: last_name,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.sentiment_very_satisfied_outlined),
                  hintText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusColor: Colors.amber[300],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                ),
                onPressed: () async {
                  if (email.text.toString().length > 0 ? validEmail() : true) {
                    updateUser();
                  } else {
                    success = false;
                    message = 'Invalid email format';
                  }

                  setState(() {});
                },
                child: Text(
                  'Update Details',
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
