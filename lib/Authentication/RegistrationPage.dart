import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe/Authentication/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({super.key});
  @override
  State<RegistrationPage> createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> {
  // for error message
  var error_message = '';
  var success_message = '';
  bool success = false;
  bool passwordNotVisible1 = true;
  bool passwordNotVisible2 = true;
  // all fields controllers
  var _username = TextEditingController();
  var _email = TextEditingController();
  var _first_name = TextEditingController();
  var _last_name = TextEditingController();
  var _password = TextEditingController();
  var _con_password = TextEditingController();

  Future<bool> register() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = _username.text.toString();
    var email = _email.text.toString();
    var first_name = _first_name.text.toString();
    var last_name = _last_name.text.toString();
    var password = _password.text.toString();

    var body = {
      "username": username,
      "first_name": first_name ,
      "last_name": last_name ,
      "email": email ,
      "password": password 
    };

    var headers = {'Content-Type': 'application/json'};
    print(body);
    var url = Uri.parse(pref.getString('HOST').toString() + 'user-utilitise');
    var response = await http.post(url,headers:headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 409) {
      error_message = 'Username already taken';
      return false;
    } else {
      print('Post request failed with status: ${response.statusCode}');
      print(response.body);
      return false;
    }
  }

  bool checkPassword() {
    setState(() {});
    print('password' + _password.text);
    print('con ' + _con_password.text);
    print(identical(_password.text.toString(), _con_password.text.toString()));
    if (identical(_password.text.toString(), _con_password.text.toString())) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$error_message',
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
              Text(
                '$success_message',
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _username,
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
                controller: _email,
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
                controller: _first_name,
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
                controller: _last_name,
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
                height: 15,
              ),
              TextField(
                controller: _password,
                obscureText: passwordNotVisible1,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusColor: Colors.amber[300],
                  suffixIcon: IconButton(
                    icon: Icon(passwordNotVisible1
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(
                        () {
                          passwordNotVisible1 = !passwordNotVisible1;
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _con_password,
                obscureText: passwordNotVisible2,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusColor: Colors.amber[300],
                  suffixIcon: IconButton(
                    icon: Icon(passwordNotVisible2
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(
                        () {
                          passwordNotVisible2 = !passwordNotVisible2;
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
                  bool checkPass = await checkPassword();
                  print(checkPass);
                  if (checkPass) {
                    if (await register()) {
                      error_message = '';
                      success_message = 'User register successfully';
                      success = true;
                    } else {
                      success_message = '';
                      error_message = 'Username already taken';
                    }
                  } else {
                    success_message = '';
                    error_message = 'Passwords does not matching';
                  }

                  setState(() {});
                },
                child: Text(
                  'Register',
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
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text(
                  'Login here',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ]),
      ),
    );
  }
}
