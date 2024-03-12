import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/4_Community_Part/provider/challenge.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateChallengeScreen extends StatefulWidget {
  static const routeName = "/create-challenge";

  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final _nameFocus = FocusNode();
  final _categoryFocus = FocusNode();
  final _levelFocus = FocusNode();
  final _startFocus = FocusNode();
  final _endFocus = FocusNode();
  final _desFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  bool isValid;
  int _selectCategory = 0;
  int _selectLevel = 0;
  Map<String, dynamic> _info = {
    "name": "",
    "category": "",
    "level": "",
    "startDate": DateTime.now(),
    "endDate": DateTime.now().add(Duration(days: 1)),
    "des": ""
  };
  var _calendarController;
  var _calendarController2;
  var _isInit = true;
  var _isErr = false;
  int gid;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      gid = ModalRoute.of(context).settings.arguments as int;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _calendarController2 = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _calendarController2.dispose();
    _nameFocus.dispose();
    _categoryFocus.dispose();
    _levelFocus.dispose();
    _startFocus.dispose();
    _endFocus.dispose();
    _desFocus.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    _form.currentState.save();
    _isErr = false;
    if (_info['name'] == "" ||
        _info['category'] == "" ||
        _info["level"] == "" ||
        _info["startDate"] == null ||
        _info["endDate"] == null ||
        _info["des"] == "") {
      setState(() {
        _isErr = true;
      });
    } else {
      setState(() {
        _isErr = false;
      });
    }
  }

  Future<void> _createChallenge() async {
    final challenge = Provider.of<ChallengeProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    List<int> _theme = [1, 2, 3, 4, 5, 6];
    int random = Random().nextInt(_theme.length);

    await challenge.createChallenge(
      Challenge(
        cid: 0,
        group_gid: gid,
        user_uidCreator: user.loginUser,
        name: _info['name'],
        category: _info['category'],
        level: _info['level'],
        startD: _info['startDate'],
        endD: _info['endDate'],
        des: _info['des'],
        theme: _theme[random],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.amber[300],
              Colors.red,
              Colors.purple[300],
            ],
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            "CHALLENGE",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: Form(
        key: _form,
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/challenge.jpg'), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    SizedBox(width: 12),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Material(
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          height: MediaQuery.of(context).size.height * 0.045,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            onSaved: (value) {
                              _info = {
                                "name": value,
                                "category": _info['category'],
                                "level": _info['level'],
                                "startDate": _info['startDate'],
                                "endDate": _info['endDate'],
                                "des": _info['des']
                              };
                            },
                            focusNode: _nameFocus,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_categoryFocus);
                            },
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 12),
                            cursorColor: Colors.teal,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "name",
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                              labelStyle: TextStyle(color: Colors.teal),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectCategory == 1) {
                                  _selectCategory = 0;
                                  _info = {
                                    "name": _info['name'],
                                    "category": "",
                                    "level": _info['level'],
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                } else {
                                  _selectCategory = 1;
                                  _info = {
                                    "name": _info['name'],
                                    "category": "Eat",
                                    "level": _info['level'],
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Material(
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: _selectCategory == 1
                                        ? Colors.purple
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Eat",
                                    style: TextStyle(
                                        color: _selectCategory == 1
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectCategory == 2) {
                                  _selectCategory = 0;
                                  _info = {
                                    "name": _info['name'],
                                    "category": "",
                                    "level": _info['level'],
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                } else {
                                  _selectCategory = 2;
                                  _info = {
                                    "name": _info['name'],
                                    "category": "Sleep",
                                    "level": _info['level'],
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Material(
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: _selectCategory == 2
                                        ? Colors.purple
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Sleep",
                                    style: TextStyle(
                                        color: _selectCategory == 2
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectCategory == 3) {
                                  _selectCategory = 0;
                                  _info = {
                                    "name": _info['name'],
                                    "category": "",
                                    "level": _info['level'],
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                } else {
                                  _selectCategory = 3;
                                  _info = {
                                    "name": _info['name'],
                                    "category": "Exercise",
                                    "level": _info['level'],
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Material(
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: _selectCategory == 3
                                        ? Colors.purple
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Exercise",
                                    style: TextStyle(
                                        color: _selectCategory == 3
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Level",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectLevel == 1) {
                                  _selectLevel = 0;
                                  _info = {
                                    "name": _info['name'],
                                    "category": _info['category'],
                                    "level": "",
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                } else {
                                  _selectLevel = 1;
                                  _info = {
                                    "name": _info['name'],
                                    "category": _info['category'],
                                    "level": "Beginner",
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Material(
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: _selectLevel == 1
                                        ? Colors.blue
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Beginner",
                                    style: TextStyle(
                                        color: _selectLevel == 1
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectLevel == 2) {
                                  _selectLevel = 0;
                                  _info = {
                                    "name": _info['name'],
                                    "category": _info['category'],
                                    "level": "",
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                } else {
                                  _selectLevel = 2;
                                  _info = {
                                    "name": _info['name'],
                                    "category": _info['category'],
                                    "level": "Intermediate",
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Material(
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: _selectLevel == 2
                                        ? Colors.blue
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Intermediate",
                                    style: TextStyle(
                                        color: _selectLevel == 2
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_selectLevel == 3) {
                                  _selectLevel = 0;
                                  _info = {
                                    "name": _info['name'],
                                    "category": _info['category'],
                                    "level": "",
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                } else {
                                  _selectLevel = 3;
                                  _info = {
                                    "name": _info['name'],
                                    "category": _info['category'],
                                    "level": "Professional",
                                    "startDate": _info['startDate'],
                                    "endDate": _info['endDate'],
                                    "des": _info['des']
                                  };
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Material(
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: _selectLevel == 3
                                        ? Colors.blue
                                        : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Pro",
                                    style: TextStyle(
                                        color: _selectLevel == 3
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Start Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(width: 11),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        context: context,
                                        builder: (builder) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(30),
                                              ),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            child: TableCalendar(
                                              startDay: DateTime.now(),
                                              calendarController:
                                                  _calendarController,
                                              initialSelectedDay:
                                                  _info['startDate'],
                                              onDaySelected: (date, _, __) {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  _info = {
                                                    "name": _info['name'],
                                                    "category":
                                                        _info['category'],
                                                    "level": _info['level'],
                                                    "startDate": date,
                                                    "endDate": date,
                                                    "des": _info['des']
                                                  };
                                                });
                                              },
                                            ),
                                          );
                                        });
                                  },
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.045,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        DateFormat('dd MMM y')
                                            .format(_info['startDate']),
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("End Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(width: 11),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        context: context,
                                        builder: (builder) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(30),
                                              ),
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            child: TableCalendar(
                                              startDay: _info['startDate'],
                                              calendarController:
                                                  _calendarController2,
                                              initialSelectedDay:
                                                  _info['startDate'],
                                              onDaySelected: (date, _, __) {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  _info = {
                                                    "name": _info['name'],
                                                    "category":
                                                        _info['category'],
                                                    "level": _info['level'],
                                                    "startDate":
                                                        _info['startDate'],
                                                    "endDate": date,
                                                    "des": _info['des']
                                                  };
                                                });
                                              },
                                            ),
                                          );
                                        });
                                  },
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.045,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        DateFormat('dd MMM y')
                                            .format(_info['endDate']),
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Material(
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          height: MediaQuery.of(context).size.height * 0.12,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            onSaved: (value) {
                              _info = {
                                "name": _info['name'],
                                "category": _info['category'],
                                "level": _info['level'],
                                "startDate": _info['startDate'],
                                "endDate": _info['endDate'],
                                "des": value
                              };
                            },
                            focusNode: _desFocus,
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 12),
                            cursorColor: Colors.teal,
                            decoration: InputDecoration(
                              hintText: "description",
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
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.04,
                buttonColor: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black, width: 2)),
                child: RaisedButton(
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
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
                                        Image.asset("assets/Popup/racism.png",
                                            width: 90, height: 90),
                                        SizedBox(height: 20),
                                        Text("Noo!!",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 20),
                                        Text('The chanllenge is not starting!',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Text('Information incorrect',
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
                                            child: Text('Try Again',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                            )
                          : showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
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
                                        Image.asset(
                                            "assets/Popup/racing-flag.png",
                                            width: 90,
                                            height: 90),
                                        SizedBox(height: 20),
                                        Text("Whee!!",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 20),
                                        Text('The flag is ready!',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Text('Continue to create',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Text(_info["name"],
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
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
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            color: Colors.green,
                                            onPressed: () {
                                              _createChallenge().then((value) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
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
                    });
                  },
                  child: Text(
                    "CREATE",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
