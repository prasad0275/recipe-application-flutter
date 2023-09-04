import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe/Main/EntryPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/LoginPage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  State<MyApp> createState() => _MyApp();

  // Obtain shared preferences.
}

class _MyApp extends State<MyApp> {
  bool isLogin = false;
  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = await verify();
    setState(() {});
    return;
  }

  Future<bool> verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('USERNAME');
    var password = prefs.getString('PASSWORD');
    print(username);
    print(password);
    var headers = {'Content-Type': 'application/json'};
    var body = {"username": username, "password": password};
    if (username!.isNotEmpty && password!.isNotEmpty) {
      var response = await http.post(
          Uri.parse(prefs.getString('HOST').toString() + '/token'),headers: headers,
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var access_token = json.decode(response.body)['access'];
        prefs.setString('TOKEN', access_token);
        return true;
      } else {
        print('Error : ${response.statusCode}');
        return false;
      }
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isLogin = false;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: isLogin ? EntryPage() : LoginPage(),
    );
  }
}
