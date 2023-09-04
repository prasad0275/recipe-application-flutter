import 'package:flutter/material.dart';
import 'package:recipe/Authentication/LoginPage.dart';
import 'package:recipe/Main/Setting/EditProfilePage.dart';
import 'package:recipe/Main/Setting/YourRecipeListPage.dart';
import 'package:recipe/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'PostRecipePage.dart';

class SettingPage extends StatefulWidget {
  SettingPage({super.key});
  @override
  State<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {

  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('USERNAME');
    var url = Uri.parse(prefs.getString("HOST").toString() +
        '/user-utilitise/' +
        user.toString());
    print(url);
    var headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      setState(() {});
      return;
    } else {
      print('Error : ' + response.statusCode.toString());
      setState(() {});
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // CircleAvatar(
              //   radius: 100,

              //   // backgroundColor: Colors.amber,
              //   backgroundImage: AssetImage('assets/images/Chef.jpg'),
              // ),
              Image.asset(
                'assets/images/Chef.jpg',
                height: 250,
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Edit Profile', style: TextStyle(fontSize: 20)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.send),
                  title:
                      Text('Post New Recipe', style: TextStyle(fontSize: 20)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostRecipePage(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.data_saver_off),
                  title: Text('Your Recipes', style: TextStyle(fontSize: 20)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YourRecipeListPage(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('USERNAME', '');
                  prefs.setString('PASSWORD', '');
                  print('Logout');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Delete Profile',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
                onTap: () async {
                  await deleteUser();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('USERNAME', '');
                  prefs.setString('PASSWORD', '');
                  print('Logout');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
