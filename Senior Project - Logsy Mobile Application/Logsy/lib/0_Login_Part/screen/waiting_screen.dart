import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logsy_app/0_Login_Part/screen/login_screen.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart' as u;
import 'package:logsy_app/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart' as u;

class WaitingScreen extends StatefulWidget {
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  bool _isInit = true;
  String endUrl =
      "http://ec2-13-228-29-184.ap-southeast-1.compute.amazonaws.com:3000";

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Timer(Duration(seconds: 3), () {
        FirebaseAuth.instance.authStateChanges().listen((User user) async {
          if (user == null) {
            print('User is currently signed out!');
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          } else {
            print('User ${user.uid} is signed in!');
            //await FirebaseAuth.instance.signOut();
            await getUsers(await user.getIdToken()).then((value) async {
             
              int index =
                  value.indexWhere((element) => element.username == user.uid);
              int uid = value[index].uid;
              final userP = Provider.of<u.UserProvider>(context, listen: false);
              userP.setLoginUser(uid);
              Navigator.of(context).pushReplacementNamed(TabScreen.routeName);
            });
          }
        });
      });
    }
    super.didChangeDependencies();
  }

  Future<List<u.User>> getUsers(String token) async {
    final url = "$endUrl/userList";

    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});

      final extractData = json.decode(response.body) as List<dynamic>;
      final List<u.User> loadedUser = [];
      if (extractData == null) {
        return null;
      }
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedUser.add(
          u.User(
              uid: data['uid'],
              username: data['username'],
              pwd: data['pwd'],
              email: data['email'],
              firstName: data['firstName'],
              lastName: data['lastName'],
              age: data['age'],
              weight: data['weight'],
              height: data['height'],
              physicalActivity: data['physicalActivity'],
              idealWeight: data['idealWeight'],
              gender: data['gender'],
              goal: data['goal'],
              des: data['des'],
              imgUrl: data['imgUrl'],
              exerciseGoal: data['exerciseGoal'],
              sleepGoal: data['sleepGoal'],
              stepGoal: data['stepGoal']),
        );
      });
      return loadedUser;
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          // child: CircularProgressIndicator(
          //   color: Colors.teal[100],
          // ),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/Logo.png',
            width: 100,
          ),
          Text(
            'Logsy',
            style: TextStyle(
                color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          SizedBox(height: 20),
          SpinKitFadingGrid(
            color: Colors.teal[100],
            size: 50.0,
          )
        ],
      )),
    );
  }
}
