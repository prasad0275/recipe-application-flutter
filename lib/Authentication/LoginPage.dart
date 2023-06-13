import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/Authentication/RegistrationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  // this is error for message
  String message = '';
  bool success = false;
  bool passwordVisible = true;
  // User creadientials
  var username = TextEditingController();
  var password = TextEditingController();

  // Token authentications

  Future<bool> verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await login();
    print(token);
    token = token.toString();
    var body = {
      "token": '$token',
    };
    var response = await http.post(
        Uri.parse(prefs.getString('HOST').toString() + 'token/verify'),
        body: body);
    print('verify:' + response.statusCode.toString());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // This method post username and password ; returns access_token that token use to verify method
  Future<dynamic> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final host = prefs.getString('HOST');

    Map<String, dynamic> data = {
      "username": username.text.toString(),
      "password": password.text.toString()
    };

    var url = Uri.parse(host.toString() + 'token');
    print(url);
    var response = await http.post(url, body: data);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var access_token = json.decode(response.body)['access'];
      return access_token;
    } else {
      var access_token = '';
      return access_token;
    }
  }

  void start() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('HOST', 'http://localhost:8000/');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$message',
                style: !success
                    ? TextStyle(color: Colors.red, fontSize: 15)
                    : TextStyle(color: Colors.green, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
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
                controller: password,
                obscureText: passwordVisible,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusColor: Colors.amber[300],
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(
                        () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
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
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var isValid = await verify();
                  if (isValid) {
                    print('Login Successfully');
                    prefs.setBool('isUserLogin', true);
                    message = 'User Login Successfully';
                    success = true;
                  } else {
                    success = false;
                    print('Invalid credientials');
                    prefs.setBool('isUserLogin', false);
                    message = 'Invalid User Credentials';
                  }
                  setState(() {});
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationPage(),
                    ),
                  );
                },
                child: Text(
                  'New registration here',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ]),
      ),
    );
  }
}
