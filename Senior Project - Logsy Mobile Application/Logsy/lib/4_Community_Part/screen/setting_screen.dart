import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logsy_app/0_Login_Part/screen/login_screen.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = "/setting-screen";

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin fb = FacebookLogin();
  Future<void> _signOut() async {
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    await fb.logOut();

    await FirebaseAuth.instance.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "SETTINGS",
          style: TextStyle(
              fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      content: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(Icons.close)),
                              ],
                            ),
                            Image.asset("assets/Popup/crying.png",
                                width: 90, height: 90),
                            SizedBox(height: 20),
                            Text("Noo!",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Text('The face is crying!',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            Text('Are you sure to DELETE this account?',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12)),
                            SizedBox(height: 20),
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width * 0.4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: RaisedButton(
                                child: Text('Continue',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                color: Colors.red,
                                onPressed: () async {
                                  final userP = Provider.of<UserProvider>(
                                      context,
                                      listen: false);
                                  await userP
                                      .deleteUser(userP.loginUser)
                                      .then((value) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushReplacementNamed(
                                        LoginScreen.routeName);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: ListTile(
                  tileColor: Colors.white,
                  leading: Image.asset(
                    "assets/delete.png",
                    width: 20,
                  ),
                  title: Text(
                    "Delete account",
                    style: TextStyle(color: Colors.teal),
                  )),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      content: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(Icons.close)),
                              ],
                            ),
                            Image.asset("assets/Popup/crying.png",
                                width: 90, height: 90),
                            SizedBox(height: 20),
                            Text("Noo!",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Text('The face is crying!',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            Text('Are you sure to sign out?',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            SizedBox(height: 20),
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width * 0.4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: RaisedButton(
                                child: Text('Continue',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                color: Colors.red,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  _signOut().then((value) {
                                    Navigator.of(context).pushReplacementNamed(
                                        LoginScreen.routeName);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: ListTile(
                  tileColor: Colors.white,
                  leading: Image.asset(
                    "assets/logout.png",
                    width: 20,
                  ),
                  title: Text(
                    "Log out",
                    style: TextStyle(color: Colors.teal),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
