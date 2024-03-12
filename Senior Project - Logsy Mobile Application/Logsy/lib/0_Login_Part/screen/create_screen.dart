import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  static const routeName = '/create-credential-screen';

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _emailFocus = FocusNode();
  final _passWordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  String email = "";
  String password = "";
  String reconfirm = "";
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailFocus.dispose();
    _passWordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<String> registerWithEmail({@required email, @required password}) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((data) {
      data.user.sendEmailVerification();
      print("Registation Success: ${data.user.uid}");

      return "true";
    }).catchError((e) {
      print(e);
      print("Error: " + e.code);
      return e.code.toString();
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
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
                      "Sign Up Here.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Enter your information below to create",
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                Text(
                  "account with Logsy.",
                  style: TextStyle(color: Colors.black, fontSize: 13),
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          height: MediaQuery.of(context).size.height * 0.04,
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          height: MediaQuery.of(context).size.height * 0.04,
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
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordFocus);
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
                SizedBox(height: 20),
                // Row(
                //   children: [
                //     Container(
                //       width: MediaQuery.of(context).size.width * 0.22,
                //       child: Text("RETYPE PASSWORD",
                //           style: TextStyle(
                //               color: Colors.grey[700],
                //               fontWeight: FontWeight.bold,
                //               fontSize: 15),
                //           textAlign: TextAlign.end),
                //     ),
                //     SizedBox(width: 20),
                //     Expanded(
                //       child: Material(
                //         elevation: 3.0,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(15),
                //         ),
                //         child: Container(
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.all(Radius.circular(15)),
                //           ),
                //           height: MediaQuery.of(context).size.height * 0.04,
                //           padding: EdgeInsets.symmetric(horizontal: 10),
                //           child: TextFormField(
                //             obscureText: true,
                //             enableSuggestions: false,
                //             autocorrect: false,
                //             onSaved: (value) {
                //               reconfirm = value;
                //             },
                //             focusNode: _confirmPasswordFocus,
                //             onFieldSubmitted: (value) {
                //               reconfirm = value;
                //             },
                //             style: TextStyle(
                //                 color: Colors.grey[700], fontSize: 12),
                //             cursorColor: Colors.teal,
                //             keyboardType: TextInputType.text,
                //             decoration: InputDecoration(
                //               contentPadding:
                //                   new EdgeInsets.only(top: 0, bottom: 10),
                //               hintText: "password",
                //               hintStyle: TextStyle(
                //                 color: Colors.grey[500],
                //                 fontSize: 12,
                //               ),
                //               labelStyle: TextStyle(color: Colors.teal),
                //               enabledBorder: InputBorder.none,
                //               focusedBorder: InputBorder.none,
                //               border: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(25.0),
                //                 borderSide: BorderSide.none,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 20),
                ButtonTheme(
                  minWidth: double.infinity,
                  height: 30,
                  buttonColor: Colors.amber,
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
                                    Text("Oops!",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                                    Text("Please fill all information",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                    SizedBox(height: 20),
                                    ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
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
                        registerWithEmail(
                          email: email,
                          password: password,
                        ).then((value) {
                          if (value == "true") {
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
                                        Image.asset("assets/Popup/tongue-2.png",
                                            width: 90, height: 90),
                                        SizedBox(height: 20),
                                        Text("Yayy!",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 20),
                                        Text('Your account has been created!',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Text('Continue to login!',
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
                                            child: Text('Continue',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white)),
                                            color: Colors.green,
                                            onPressed: () {
                                              signOut();
                                              Navigator.of(context).pop();
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
                                        Text(value,
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
                          }
                        });
                      }
                    },
                    child: Text("SIGN UP",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
