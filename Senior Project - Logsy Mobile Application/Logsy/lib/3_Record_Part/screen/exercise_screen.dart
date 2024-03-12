import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logsy_app/3_Record_Part/provider/exercise.dart';
import 'package:logsy_app/3_Record_Part/provider/exerciseRecord.dart';
import 'package:logsy_app/3_Record_Part/widget/exercise_item.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class ExerciseScreen extends StatefulWidget {
  static const routeName = '/exercise-screen';

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _form = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isErr = false;
  String _select = "";

  List<Exercise> _realExercise = [];
  List<Exercise> _exercise = [];
  Map<String, dynamic> _info = {"name": "", "time": 0, "eid": 0};

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final exercise = Provider.of<ExerciseProvider>(context, listen: false);
      await exercise.getExercise().then((value) {
        setState(() {
          _realExercise = value;
          _exercise = _realExercise;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    _form.currentState.save();
    _isErr = false;
    if (_info["name"] == "" || _info["time"] == 0 || _info["eid"] == 0) {
      setState(() {
        _isErr = true;
      });
    } else {
      final _exerciseRecord =
          Provider.of<ExerciseRecordProvider>(context, listen: false);
      final user = Provider.of<UserProvider>(context, listen: false);
      await _exerciseRecord.addExerciseRecord(
        ExerciseRecord(
          exerciseRecID: 0,
          user_uid: user.loginUser,
          exercise_eid: _info["eid"],
          duration: int.parse(_info["time"]),
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Colors.white,
      //   iconTheme: IconThemeData(color: Colors.teal),
      // ),
      body: Container(
        color: Color.fromRGBO(232, 230, 198, 100),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topRight,
        //     end: Alignment.bottomLeft,
        //     colors: [Colors.green, Colors.white],
        //   ),
        // ),
        child: Form(
          key: _form,
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Exercise',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.teal[500],
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height:20),
                    Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 4.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.only(
                            //       topLeft: Radius.circular(50),
                            //       topRight: Radius.circular(50),
                            //     ),
                            //     color: Colors.white,
                            //   ),
                            //   width: double.infinity,
                            //   height: MediaQuery.of(context).size.height * 0.08,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Center(
                            //         child: Text(
                            //           'Exercise',
                            //           style: TextStyle(
                            //             color: Colors.grey[700],
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 20,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                                child: Center(
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    onChanged: (text) {
                                      if (text == "") {
                                        setState(() {
                                          _exercise = _realExercise;
                                        });
                                      } else {
                                        List<Exercise> searchExercise =
                                            _exercise
                                                .where((element) => element.name
                                                    .toLowerCase()
                                                    .contains(
                                                        text.toLowerCase()))
                                                .toList();
                                        setState(() {
                                          _exercise = searchExercise;
                                        });
                                      }
                                    },
                                    style: TextStyle(color: Colors.teal),
                                    cursorColor: Colors.teal,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Exercise",
                                      hintStyle: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                      suffixIcon: Icon(Icons.search),
                                      border: InputBorder.none,
                                      focusColor: Colors.teal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: _exercise
                                      .map(
                                        (e) => GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (_select == e.name) {
                                                _select = "";
                                                _info["name"] = "";
                                                _info["eid"] = 0;
                                              } else {
                                                _select = e.name;
                                                _info["name"] = e.name;
                                                _info["eid"] = e.eid;
                                              }
                                            });
                                          },
                                          child: ExerciseItem(e.name, _select),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.08,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                textAlign: TextAlign.center,
                                onChanged: (text) {
                                  setState(() {
                                    _info["time"] = text;
                                  });
                                },
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 20),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "amount of time (min)",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                  ),
                                  suffixText: "min",
                                   contentPadding: const EdgeInsets.symmetric(horizontal: 50.0),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              child: ButtonTheme(
                                height: 30,
                                child: FlatButton(
                                  onPressed: () {
                                    _saveForm().then((_) {
                                      _isErr
                                          ? showDialog(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
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
                                                                child: Icon(Icons
                                                                    .close)),
                                                          ],
                                                        ),
                                                        Image.asset(
                                                            "assets/Popup/skate.png",
                                                            width: 90,
                                                            height: 90),
                                                        SizedBox(height: 20),
                                                        Text("Oops!!",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(height: 20),
                                                        Text(
                                                            'The man is falling!',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12)),
                                                        Text(
                                                          'Please try again as some',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          'information is inaccurate.',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
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
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: RaisedButton(
                                                            child: Text(
                                                                'Try Again',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
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
                                          : showDialog(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
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
                                                                child: Icon(Icons
                                                                    .close)),
                                                          ],
                                                        ),
                                                        Image.asset(
                                                            "assets/Popup/skate-2.png",
                                                            width: 90,
                                                            height: 90),
                                                        SizedBox(height: 20),
                                                        Text("Yayy!!",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(height: 20),
                                                        Text(
                                                            'The exercise equipment is ready!',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12)),
                                                        Text(
                                                          'Continue to go ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          '${_info["name"]}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              ' for ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              '${_info["time"]}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              ' min',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: RaisedButton(
                                                            child: Text(
                                                                'Continue',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            color: Colors.green,
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
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
                                            );
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.amber,
                                  child: Text(
                                    "Record",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
