import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logsy_app/0_Login_Part/screen/create_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart' as u;
import 'package:logsy_app/Question_Part/screen/question_screen.dart';
import 'package:logsy_app/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailFocus = FocusNode();
  final _passWordFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin fb = FacebookLogin();

  String email = "";
  String password = "";
  // List<u.User> _user = [];
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    // if (_isInit) {
    // final user = Provider.of<u.UserProvider>(context);
    // await user.getUsers().then((value) {
    //   _user = value;
    // });
    // }
    // _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passWordFocus.dispose();

    super.dispose();
  }

  Future<String> signInWithEmail(
      {@required String email, @required String password}) {
    setState(() {
      _isLoading = true;
    });

    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) async {
      final userP = Provider.of<u.UserProvider>(context, listen: false);
      List<u.User> _user = [];
      await userP.getUsers().then((value) {
        _user = value;
      });

      if (result.user.emailVerified) {
        int index =
            _user.indexWhere((element) => element.username == result.user.uid);
        if (index < 0) {
          Navigator.of(context).pushReplacementNamed(QuestionScreen.routeName,
              arguments: [result.user.uid, email]);
          setState(() {
            _isLoading = false;
          });
          return "nonUser";
        } else {
          final userP = Provider.of<u.UserProvider>(context, listen: false);

          userP.findUser(result.user.uid).then((value) {
            Navigator.of(context).pushReplacementNamed(TabScreen.routeName,
                arguments: result.user.uid);
          });
          setState(() {
            _isLoading = false;
          });
          return "User";
        }
      } else {
        //if not verified
        setState(() {
          _isLoading = false;
        });
        return "NotVerified";
      }
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      return e.code.toString();
    });
  }

  Future<String> _googleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final userP = Provider.of<u.UserProvider>(context, listen: false);
      List<u.User> _user = [];
      await userP.getUsers().then((value) {
        _user = value;
      });

      final user = userCredential.user;

      int index = _user.indexWhere((element) => element.username == user.uid);
      if (index < 0) {
        Navigator.of(context).pushReplacementNamed(QuestionScreen.routeName,
            arguments: [user.uid, user.email]);
        setState(() {
          _isLoading = false;
        });
        return "nonUser";
      } else {
        final userP = Provider.of<u.UserProvider>(context, listen: false);
        userP.findUser(user.uid).then((value) {
          Navigator.of(context).pushReplacementNamed(TabScreen.routeName);
        });
        setState(() {
          _isLoading = false;
        });
        return "User";
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      setState(() {
        _isLoading = false;
      });
      // if (e.code == 'account-exists-with-different-credential') {
      //   // handle the error here
      // } else if (e.code == 'invalid-credential') {
      //   // handle the error here
      // }
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
      // handle the error here
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _loginFacebook() async {
    setState(() {
      _isLoading = true;
    });

    final res = await fb.logIn(permissions: [
      FacebookPermission.email,
    ]);
    switch (res.status) {
      case FacebookLoginStatus.success:
        final email = await fb.getUserEmail();
        final FacebookAccessToken accessToken = res.accessToken;
        final facebookAuthCred =
            FacebookAuthProvider.credential(accessToken.token);
        final UserCredential userCredential =
            await _auth.signInWithCredential(facebookAuthCred);
        final userP = Provider.of<u.UserProvider>(context, listen: false);
        List<u.User> _user = [];
        await userP.getUsers().then((value) {
          _user = value;
        });
        final user = userCredential.user;

        int index = _user.indexWhere((element) => element.username == user.uid);
        if (index < 0) {
          Navigator.of(context).pushReplacementNamed(QuestionScreen.routeName,
              arguments: [user.uid, email]);
          setState(() {
            _isLoading = false;
          });
          return "nonUser";
        } else {
          final userP = Provider.of<u.UserProvider>(context, listen: false);
          userP.findUser(user.uid).then((value) {
            Navigator.of(context)
                .pushReplacementNamed(TabScreen.routeName, arguments: user.uid);
          });
          setState(() {
            _isLoading = false;
          });
          return "User";
        }

        break;
      case FacebookLoginStatus.cancel:
        // User cancel log in
        setState(() {
          _isLoading = false;
        });
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        setState(() {
          _isLoading = false;
        });
        print('Error while log in: ${res.error}');
        break;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _loginApple() async {
    setState(() {
      _isLoading = true;
    });
    bool avail = await AppleSignIn.isAvailable();
    if (avail) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print(credential);
      AuthCredential signInCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(signInCredential);
      final userP = Provider.of<u.UserProvider>(context);
      List<u.User> _user = [];
      await userP.getUsers().then((value) {
        _user = value;
      });
      final user = userCredential.user;
      int index = _user.indexWhere((element) => element.username == user.uid);
      if (index < 0) {
        Navigator.of(context).pushReplacementNamed(QuestionScreen.routeName,
            arguments: [user.uid, user.email]);
        setState(() {
          _isLoading = false;
        });
        return "nonUser";
      } else {
        final userP = Provider.of<u.UserProvider>(context, listen: false);
        userP.findUser(user.uid).then((value) {
          Navigator.of(context)
              .pushReplacementNamed(TabScreen.routeName, arguments: user.uid);
        });
        setState(() {
          _isLoading = false;
        });
        return "User";
      }
    } else {
      print("Unsupported sign in with apple");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _signInWithApple2() async {
    setState(() {
      _isLoading = true;
    });
    bool avail = await AppleSignIn.isAvailable();
    if (avail) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          AuthCredential credential = OAuthProvider("apple.com").credential(
            idToken: String.fromCharCodes(result.credential.identityToken),
            accessToken:
                String.fromCharCodes(result.credential.authorizationCode),
          );
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          final userP = Provider.of<u.UserProvider>(context);
          List<u.User> _user = [];
          await userP.getUsers().then((value) {
            _user = value;
          });
          final user = userCredential.user;
          int index =
              _user.indexWhere((element) => element.username == user.uid);
          if (index < 0) {
            Navigator.of(context).pushReplacementNamed(QuestionScreen.routeName,
                arguments: [user.uid, user.email]);
            setState(() {
              _isLoading = false;
            });
            return "nonUser";
          } else {
            final userP = Provider.of<u.UserProvider>(context, listen: false);
            userP.findUser(user.uid).then((value) {
              Navigator.of(context).pushReplacementNamed(TabScreen.routeName,
                  arguments: user.uid);
            });
            setState(() {
              _isLoading = false;
            });
            return "User";
          }

          break;
        case AuthorizationStatus.error:
          print("Error: " + result.error.localizedDescription);
          setState(() {
            _isLoading = false;
          });
          break;
        case AuthorizationStatus.cancelled:
          setState(() {
            _isLoading = false;
          });
          break;
      }
    } else {
      print("Unsupported sign in with apple");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: SpinKitHourGlass(
                color: Colors.teal[100],
                size: 50.0,
              ),
            )
          : Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hey,",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 35),
                          ),
                          Text(
                            "Login Here.",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 35),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "If you are new, ",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ButtonTheme(
                              buttonColor: Colors.amber,
                              height: 30,
                              // minWidth: double.infinity,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: RaisedButton(
                                elevation: 0.0,
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(CreateScreen.routeName);
                                },
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: Text(
                              "EMAIL",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Material(
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  onSaved: (value) {
                                    email = value;
                                  },
                                  focusNode: _emailFocus,
                                  onFieldSubmitted: (value) {
                                    email = value;
                                    FocusScope.of(context)
                                        .requestFocus(_passWordFocus);
                                  },
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 12),
                                  cursorColor: Colors.teal,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        new EdgeInsets.only(top: 0, bottom: 10),
                                    hintText: "email",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                    labelStyle: TextStyle(color: Colors.teal),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: Text("PASSWORD",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                                textAlign: TextAlign.end),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Material(
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  onSaved: (value) {
                                    password = value;
                                  },
                                  focusNode: _passWordFocus,
                                  onFieldSubmitted: (value) {
                                    password = value;
                                  },
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 12),
                                  cursorColor: Colors.teal,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        new EdgeInsets.only(top: 0, bottom: 10),
                                    hintText: "password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                    labelStyle: TextStyle(color: Colors.teal),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ButtonTheme(
                        minWidth: double.infinity,
                        height: 30,
                        buttonColor: Colors.teal[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: RaisedButton(
                          elevation: 0.0,
                          onPressed: () {
                            _form.currentState.save();

                            if (email == "" || password == "") {
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    content: Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                          Text("Oops!",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 20),
                                          Text("Please fill all information",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          SizedBox(height: 20),
                                          ButtonTheme(
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: RaisedButton(
                                              child: Text('Try again',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white)),
                                              color: Colors.red,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              signInWithEmail(
                                email: email,
                                password: password,
                              ).then((value) {
                                value == "NotVerified"
                                    ? showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            elevation: 4.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            content: Container(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Icon(
                                                              Icons.close)),
                                                    ],
                                                  ),
                                                  Image.asset(
                                                      "assets/Popup/crying.png",
                                                      width: 90,
                                                      height: 90),
                                                  SizedBox(height: 20),
                                                  Text("Oops!",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 20),
                                                  Text(
                                                      "Please Confirm your email",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12)),
                                                  SizedBox(height: 20),
                                                  ButtonTheme(
                                                    minWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: RaisedButton(
                                                      child: Text('Okay',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .white)),
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : value != "nonUser" && value != "User"
                                        ? showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                elevation: 4.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                content: Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Icon(
                                                                  Icons.close)),
                                                        ],
                                                      ),
                                                      Image.asset(
                                                          "assets/Popup/crying.png",
                                                          width: 90,
                                                          height: 90),
                                                      SizedBox(height: 20),
                                                      Text("Oops!",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(height: 20),
                                                      Text(value,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12)),
                                                      SizedBox(height: 20),
                                                      ButtonTheme(
                                                        minWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: RaisedButton(
                                                          child: Text(
                                                              'Try again',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white)),
                                                          color: Colors.red,
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Container();
                              });
                            }
                          },
                          child: Text("LOGIN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ),
                      // SizedBox(height: 10),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Forgot Password?",
                      //       style: TextStyle(fontSize: 15),
                      //     ),
                      //     SizedBox(width: 5),
                      //     GestureDetector(
                      //       onTap: () {},
                      //       child: Text(
                      //         "Reset",
                      //         style: TextStyle(
                      //             fontSize: 15, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 20),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Container(
                      //         color: Colors.grey[400],
                      //         height: 1,
                      //         width: 20,
                      //         child: Text(""),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //     Text("Or login with", style: TextStyle(fontSize: 15)),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //     Expanded(
                      //       child: Container(
                      //         color: Colors.grey[400],
                      //         height: 1,
                      //         width: 20,
                      //         child: Text(""),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         _loginFacebook();
                      //       },
                      //       child: Material(
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(30),
                      //         ),
                      //         elevation: 4.0,
                      //         child: CircleAvatar(
                      //           backgroundImage:
                      //               AssetImage("assets/facebook.png"),
                      //           radius: 15,
                      //           //child: Text("F"),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(width: 10),
                      //     GestureDetector(
                      //       onTap: () {
                      //         _googleSignIn();
                      //       },
                      //       child: Material(
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(30),
                      //         ),
                      //         elevation: 4.0,
                      //         child: CircleAvatar(
                      //           backgroundImage:
                      //               AssetImage("assets/google.png"),
                      //           backgroundColor: Colors.white,
                      //           radius: 15,
                      //           //child: Text("G"),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(width: 10),
                      //     GestureDetector(
                      //       onTap: () {
                      //         _loginApple();
                      //       },
                      //       child: Material(
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(30),
                      //         ),
                      //         elevation: 4.0,
                      //         child: CircleAvatar(
                      //           radius: 15,
                      //           backgroundImage: AssetImage("assets/apple.png"),
                      //           backgroundColor: Colors.white,

                      //           //child: Text("G"),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
               
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
