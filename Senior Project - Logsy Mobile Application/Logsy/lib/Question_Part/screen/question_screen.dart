import 'package:emojis/emojis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/tab_screen.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatefulWidget {
  static const routeName = '/question-screen';
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool _isInit = true;

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _userNameFocus = FocusNode();
  final _passWordFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _ageFocus = FocusNode();
  final _heightFocus = FocusNode();
  final _weightFocus = FocusNode();
  final _idealWeightFocus = FocusNode();
  final _exerciseGoalFocus = FocusNode();
  final _stepGoalFocus = FocusNode();
  final _form = GlobalKey<FormState>();

  final List<Map<String, dynamic>> interest = [
    {'name': "Fast Food", "click": false},
    {'name': "Thai Food", "click": false},
    {'name': "Thai Dessert", "click": false},
    {'name': "Noodles", "click": false},
    {'name': "Coffee & Tea", "click": false},
    {'name': "Non-Alcoholic", "click": false},
    {'name': "Soup", "click": false},
    {'name': "Rice Dish", "click": false},
    {'name': "Japanese Food", "click": false},
    {'name': "Fruit", "click": false},
    {'name': "Blended Drink", "click": false},
    {'name': "Bread & Bun", "click": false},
    {'name': "Dessert", "click": false},
    {'name': "Juice", "click": false},
    {'name': "Steak", "click": false},
    {'name': "Sauce", "click": false},
  ];
  final List<Map<String, dynamic>> sleep = [
    {'name': "Morning Person", "click": false},
    {'name': "Night Owl", "click": false},
    {'name': "8 hrs sleep", "click": false},
  ];
  final List<Map<String, dynamic>> exercise = [
    {'name': "Weight Lifting", "click": false},
    {'name': "Yoga", "click": false},
    {'name': "Swimming", "click": false},
    {'name': "Cycling", "click": false},
    {'name': "Running", "click": false},
    {'name': "Jogging", "click": false},
    {'name': "Volleyball", "click": false},
    {'name': "Basketball", "click": false},
    {'name': "Football", "click": false},
    {'name': "Circuit Training", "click": false},
    {'name': "Pilates", "click": false},
    {'name': "Badminton", "click": false},
    {'name': "HIIT", "click": false},
    {'name': "Eliptical", "click": false},
    {'name': "Kickboxing", "click": false},
    {'name': "Fitness Gaming", "click": false},
  ];
  String _goal = "";
  int _activityLevel = 0;
  bool _recommend = false;
  String _recommendText = "";
  bool _isErr = false;
  int _avatar = 0;

  Map<String, dynamic> _info = {
    "uid": 0,
    "username": "",
    "password": "",
    "desc": "",
    "firstName": "",
    "lastName": "",
    "email": "",
    "age": 0,
    "weight": "",
    "height": "",
    "physicalActivity": "",
    "idealWeight": 0,
    "gender": "",
    "goal": "",
    "eatInterest": [],
    "sleepInterest": [],
    "exerciseInterest": [],
    "exerciseGoal": "",
    "sleepGoal": 8,
    "imgUrl": "",
    "stepGoal": ""
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final data = ModalRoute.of(context).settings.arguments as List;
      String username = data[0];
      String email = data[1];
      setState(() {
        _info["username"] = username;
        _info["email"] = email;
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _userNameFocus.dispose();
    _passWordFocus.dispose();
    _descriptionFocus.dispose();
    _ageFocus.dispose();
    _heightFocus.dispose();
    _weightFocus.dispose();
    _idealWeightFocus.dispose();
    _exerciseGoalFocus.dispose();
    _stepGoalFocus.dispose();
    super.dispose();
  }

  void _addEatInterest(String data) {
    int index = _info['eatInterest'].indexWhere((element) => element == data);
    if (index < 0) {
      _info['eatInterest'].add(data);
    } else {
      _info['eatInterest'].remove(data);
    }
  }

  void _addSleepInterest(String data) {
    int index = _info['sleepInterest'].indexWhere((element) => element == data);
    if (index < 0) {
      _info['sleepInterest'].add(data);
    } else {
      _info['sleepInterest'].remove(data);
    }
  }

  void _addExerciseInterest(String data) {
    int index =
        _info['exerciseInterest'].indexWhere((element) => element == data);
    if (index < 0) {
      _info['exerciseInterest'].add(data);
    } else {
      _info['exerciseInterest'].remove(data);
    }
  }

  void _checkBMI(String weight, String height) {
    double numWeight = double.parse(weight);
    double numHeight = double.parse(height);
    numHeight = numHeight / 100;
    double bmi = numWeight / (numHeight * numHeight);
    if (bmi < 18.5) {
      setState(() {
        _recommendText = "Gain";
      });
    } else if (bmi >= 18.5 && bmi <= 22.9) {
      setState(() {
        _recommendText = "Maintain";
      });
    } else if (bmi >= 23) {
      setState(() {
        _recommendText = "lose";
      });
    }
  }

  Widget _topRow(String number, String topic) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.teal[300],
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white,
            child: Text(
              number,
              style: TextStyle(
                  color: Colors.teal[300], fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(width: 20),
        Text(
          topic,
          style: TextStyle(
              color: Colors.teal[300],
              fontWeight: FontWeight.bold,
              fontSize: 12),
        )
      ],
    );
  }

  Widget _longForm(String formName, FocusNode focusNode, FocusNode nextFocus,
      String hint, String info) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            formName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            child: Material(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                height: MediaQuery.of(context).size.height * 0.04,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  onSaved: (value) {
                    _info[info] = value;
                  },
                  focusNode: focusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(nextFocus);
                    _info[info] = value;
                  },
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  cursorColor: Colors.teal,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: hint,
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
        ),
      ],
    );
  }

  Widget _longFormPassword(String formName, FocusNode focusNode,
      FocusNode nextFocus, String hint, String info) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            formName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            child: Material(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                height: MediaQuery.of(context).size.height * 0.04,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  onSaved: (value) {
                    _info[info] = value;
                  },
                  focusNode: focusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(nextFocus);
                    _info[info] = value;
                  },
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  cursorColor: Colors.teal,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: hint,
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
        ),
      ],
    );
  }

  Widget _longFormDesc(String formName, FocusNode focusNode,
      FocusNode nextFocus, String hint, String info) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            formName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            child: Material(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  onSaved: (value) {
                    _info[info] = value;
                  },
                  focusNode: focusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(nextFocus);
                    _info[info] = value;
                  },
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    hintText: hint,
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
        ),
      ],
    );
  }

  Widget _shortForm(String formName, FocusNode focusNode, FocusNode nextFocus,
      String hint, String unit, String info) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.13,
          child: Text(
            formName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.15,
          child: Material(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              height: MediaQuery.of(context).size.height * 0.04,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                onSaved: (value) {
                  _info[info] = value;
                },
                focusNode: focusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(nextFocus);
                  _info[info] = value;
                },
                style: TextStyle(color: Colors.grey[700], fontSize: 12),
                cursorColor: Colors.teal,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                decoration: InputDecoration(
                  hintText: hint,
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
        Container(
          width: MediaQuery.of(context).size.width * 0.12,
          child: Center(
            child: Text(
              unit,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropDown() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.13,
          child: Text(
            "Gender",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Material(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              height: MediaQuery.of(context).size.height * 0.043,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonFormField(
                onChanged: (value) {
                  _info['gender'] = value;
                },
                //value: person.gender,
                items: ["Female", "Male"]
                    .map(
                      (gen) => DropdownMenuItem(
                        value: gen,
                        child: Text(gen),
                      ),
                    )
                    .toList(),
                style: TextStyle(color: Colors.grey[700], fontSize: 12),
                decoration: InputDecoration(
                  hintText: "gender",
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
    );
  }

  Widget _smallItem(String data, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          interest[index]['click'] = !interest[index]['click'];
        });
        _addEatInterest(data);
      },
      child: Material(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  interest[index]['click'] ? Colors.transparent : Colors.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: interest[index]['click'] ? Colors.teal[300] : Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              data,
              style: TextStyle(
                color: interest[index]['click'] ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _smallItem2(String data, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          sleep[index]['click'] = !sleep[index]['click'];
        });
        _addSleepInterest(data);
      },
      child: Material(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: sleep[index]['click'] ? Colors.transparent : Colors.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: sleep[index]['click'] ? Colors.teal[300] : Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              data,
              style: TextStyle(
                color: sleep[index]['click'] ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _smallItem3(String data, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          exercise[index]['click'] = !exercise[index]['click'];
        });
        _addExerciseInterest(data);
      },
      child: Material(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  exercise[index]['click'] ? Colors.transparent : Colors.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: exercise[index]['click'] ? Colors.teal[300] : Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              data,
              style: TextStyle(
                color: exercise[index]['click'] ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _activity(int activity, String des) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _activityLevel = activity;
        });
        _info['physicalActivity'] = activity;
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color:
                _activityLevel == activity ? Colors.transparent : Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: _activityLevel == activity
              ? Colors.teal[300]
              : Colors.transparent,
        ),
        padding: EdgeInsets.all(5),
        width: double.infinity,
        child: Text(
          des,
          style: TextStyle(
              color: _activityLevel == activity ? Colors.white : Colors.black,
              fontSize: 12),
        ),
      ),
    );
  }

  Widget _goalSelect(String data) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _goal = data;
        });
        _info['goal'] = data;
      },
      child: Material(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _goal == data ? Colors.transparent : Colors.grey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: _goal == data ? Colors.teal[300] : Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Text(
              data,
              style: TextStyle(
                color: _goal == data ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    final validate = _form.currentState.validate();
    if (validate == false) {
      return;
    }
    _form.currentState.save();
    _isErr = false;
    if (_info["username"] == "" ||
        _info["firstName"] == "" ||
        _info["lastName"] == "" ||
        _info["email"] == "" ||
        _info["desc"] == "" ||
        _info["age"] == "" ||
        _info["weight"] == "" ||
        _info["height"] == "" ||
        _info["physicalActivity"] == "" ||
        _info["idealWeight"] == "" ||
        _info["gender"] == "" ||
        _info["goal"] == "" ||
        _info["eatInterest"].length == 0 ||
        _info["sleepInterest"].length == 0 ||
        _info["exerciseInterest"].length == 0 ||
        _info["exerciseGoal"] == "" ||
        _info["stepGoal"] == "") {
      setState(() {
        _isErr = true;
      });
    } else {
      final user = Provider.of<UserProvider>(context, listen: false);
      await user.addUser(_info);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Please answer a few question',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.teal[400],
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _topRow('1', 'Personal Information'),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          width: 32,
                          alignment:
                              Alignment.center, // where to position the child
                          child: Container(
                            width: 2.0,
                            color: Colors.teal[100],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            _longForm("First Name", _firstNameFocus,
                                _lastNameFocus, "firstname", "firstName"),
                            SizedBox(height: 6),
                            _longForm("Last Name", _lastNameFocus,
                                _descriptionFocus, "lastname", "lastName"),
                            SizedBox(height: 6),
                            // _longForm("Email", _emailFocus, _userNameFocus,
                            //     "email", "email"),
                            // SizedBox(height: 6),
                            // _longForm("Username", _userNameFocus,
                            //     _passWordFocus, "username", "username"),
                            // SizedBox(height: 6),
                            // _longFormPassword("Password", _passWordFocus,
                            //     _descriptionFocus, "password", "password"),
                            // SizedBox(height: 6),
                            _longFormDesc("Description", _descriptionFocus,
                                _ageFocus, "description", "desc"),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                _shortForm("Age", _ageFocus, _heightFocus,
                                    "age", "year", "age"),
                                _shortForm("Height", _heightFocus, _weightFocus,
                                    "height", "cm", "height")
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                _shortForm("Weight", _weightFocus, _weightFocus,
                                    "weight", "kg", "weight"),
                                _dropDown()
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _topRow('2', 'Interest'),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          width: 32,
                          alignment:
                              Alignment.center, // where to position the child
                          child: Container(
                            width: 2.0,
                            color: Colors.teal[100],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            IntrinsicWidth(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Eat ${Emojis.cooking} ${Emojis.broccoli} ${Emojis.cookedRice} ${Emojis.roastedSweetPotato}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  SizedBox(height: 6),
                                  Wrap(
                                    runSpacing: 6.0,
                                    spacing: 5.0,
                                    alignment: WrapAlignment.start,
                                    direction: Axis.horizontal,
                                    children: interest
                                        .map(
                                          (data) => _smallItem(
                                            data['name'],
                                            interest.indexWhere((element) =>
                                                element['name'] ==
                                                data['name']),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sleep ${Emojis.firstQuarterMoonFace} ${Emojis.sleepingFace} ${Emojis.zzz}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  SizedBox(height: 6),
                                  Wrap(
                                    runSpacing: 6.0,
                                    spacing: 5.0,
                                    alignment: WrapAlignment.spaceEvenly,
                                    direction: Axis.horizontal,
                                    children: sleep
                                        .map(
                                          (data) => _smallItem2(
                                            data['name'],
                                            sleep.indexWhere((element) =>
                                                element['name'] ==
                                                data['name']),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6),
                            IntrinsicWidth(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Exercise ${Emojis.personInLotusPositionMediumSkinTone} ${Emojis.manBouncingBallMediumSkinTone} ${Emojis.trophy} ${Emojis.soccerBall}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  SizedBox(height: 6),
                                  Wrap(
                                    runSpacing: 6.0,
                                    spacing: 5.0,
                                    alignment: WrapAlignment.start,
                                    direction: Axis.horizontal,
                                    children: exercise
                                        .map(
                                          (data) => _smallItem3(
                                            data['name'],
                                            exercise.indexWhere((element) =>
                                                element['name'] ==
                                                data['name']),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _topRow('3', 'Physical Activity'),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          width: 32,
                          alignment:
                              Alignment.center, // where to position the child
                          child: Container(
                            width: 2.0,
                            color: Colors.teal[100],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _activity(1, "Little or no exercise"),
                            SizedBox(height: 6),
                            _activity(2, "Exercise 1-3 times/week"),
                            SizedBox(height: 6),
                            _activity(3, "Exercise 4-5 times/week"),
                            SizedBox(height: 6),
                            _activity(4,
                                "Daily exercise or intense exercise 3-4 times/week"),
                            SizedBox(height: 6),
                            _activity(5, "Intense exercise 6-7 times/week"),
                            SizedBox(height: 6),
                            _activity(6,
                                "Very intense exercise daily, or physical job"),
                            SizedBox(height: 6),
                            Text(
                              "Note",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[300],
                              ),
                            ),
                            SizedBox(height: 6),
                            Expanded(
                              child: Text(
                                "Exercise: 15-30 minutes of elevated heart rate activity. Intense exercise: 45-120 minutes of elevated heart rate activity.Very intense exercise: 2+ hours of elevated heart rate activity.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.teal[300],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _topRow('4', 'Weight Goal'),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          width: 32,
                          alignment:
                              Alignment.center, // where to position the child
                          child: Container(
                            width: 2.0,
                            color: Colors.teal[100],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Text(
                                    "Goal",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 12),
                                _goalSelect("Loss"),
                                SizedBox(width: 12),
                                _goalSelect("Maintain"),
                                SizedBox(width: 12),
                                _goalSelect("Gain")
                              ],
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  // width: MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Ideal Weight",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        onSaved: (value) {
                                          _info['idealWeight'] = value;
                                        },
                                        focusNode: _idealWeightFocus,
                                        onFieldSubmitted: (value) {
                                          _info['idealWeight'] = value;
                                          FocusScope.of(context)
                                              .requestFocus(_exerciseGoalFocus);
                                        },
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                        cursorColor: Colors.teal,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: true, decimal: true),
                                        decoration: InputDecoration(
                                          hintText: "weight",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.teal),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  // width: MediaQuery.of(context).size.width * 0.12,
                                  child: Center(
                                    child: Text(
                                      "kg",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            _recommend
                                ? Expanded(
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          "Logsy recommend you to $_recommendText your current weight.",
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                        child: ButtonTheme(
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          buttonColor: Colors.teal[200],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: RaisedButton(
                                            onPressed: () {
                                              _form.currentState.save();

                                              if (_info['weight'] == "" ||
                                                  _info['height'] == "") {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible:
                                                      false, // user must tap button!
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
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
                                                                    child: Icon(
                                                                        Icons
                                                                            .close)),
                                                              ],
                                                            ),
                                                            Image.asset(
                                                                "assets/Popup/weight.png",
                                                                width: 90,
                                                                height: 90),
                                                            SizedBox(
                                                                height: 20),
                                                            SizedBox(
                                                                height: 20),
                                                            Text(
                                                              'Please enter\nweight, and height',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                                height: 20),
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
                                                              child:
                                                                  RaisedButton(
                                                                child: Text(
                                                                    'Try Again',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                color:
                                                                    Colors.red,
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
                                                );
                                              } else {
                                                setState(() {
                                                  _recommend = true;
                                                });
                                                _checkBMI(
                                                  _info['weight'],
                                                  _info['height'],
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Recommendataion?",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),
                    ],
                  ),
                ),
                _topRow('5', "Exercise Goal"),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          width: 32,
                          alignment:
                              Alignment.center, // where to position the child
                          child: Container(
                            width: 2.0,
                            color: Colors.teal[100],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Text(
                                    "Exercise Goal",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: TextFormField(
                                        onSaved: (value) {
                                          _info['exerciseGoal'] = value;
                                        },
                                        focusNode: _exerciseGoalFocus,
                                        onFieldSubmitted: (value) {
                                          _info['exerciseGoal'] = value;
                                        },
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                        cursorColor: Colors.teal,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: true, decimal: true),
                                        decoration: InputDecoration(
                                          hintText: "goal",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.teal),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  // width: MediaQuery.of(context).size.width * 0.12,
                                  child: Center(
                                    child: Text(
                                      "min/ week",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: Container(
                                child: Center(
                                  child: Text(
                                    "Logsy recommend you to exercise at least 150 min per week",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Text(
                                    "Step Goal",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: TextFormField(
                                        onSaved: (value) {
                                          _info['stepGoal'] = value;
                                        },
                                        focusNode: _stepGoalFocus,
                                        onFieldSubmitted: (value) {
                                          _info['stepGoal'] = value;
                                        },
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                        cursorColor: Colors.teal,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: true, decimal: true),
                                        decoration: InputDecoration(
                                          hintText: "goal",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                          labelStyle:
                                              TextStyle(color: Colors.teal),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  // width: MediaQuery.of(context).size.width * 0.12,
                                  child: Center(
                                    child: Text(
                                      "steps/ day",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _topRow('6', 'Avatar'),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          width: 32,
                          alignment:
                              Alignment.center, // where to position the child
                          child: Container(
                            width: 2.0,
                            color: Colors.teal[100],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 5,
                          children: List.generate(
                            50,
                            (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  _avatar = index;
                                  _info['imgUrl'] = "${index + 1}_Avatar.png";
                                });
                              },
                              child: _avatar == index
                                  ? CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/avatar/${index + 1}_Avatar.png"),
                                      child: IconShadowWidget(
                                        Icon(Icons.check,
                                            size: 30, color: Colors.white),
                                        shadowColor: Colors.black,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/avatar/${index + 1}_Avatar.png"),
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 6),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.04,
                  buttonColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RaisedButton(
                    onPressed: () {
                      _saveForm().then((value) {
                        _isErr
                            ? showDialog(
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
                                          Text('The face is crying!',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          Text('Please try again as some',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          Text('information are incorrect',
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
                              )
                            : showDialog(
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
                                          Image.asset(
                                              "assets/Popup/happy-2.png",
                                              width: 90,
                                              height: 90),
                                          SizedBox(height: 20),
                                          Text("Yayy!",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 20),
                                          Text('The face is smiling!',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          Text(
                                              'Continue to save the information.',
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
                                                final userP =
                                                    Provider.of<UserProvider>(
                                                        context,
                                                        listen: false);
                                                userP
                                                    .findUser(_info["username"])
                                                    .then((value) {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          TabScreen.routeName,
                                                          arguments: _info[
                                                              "username"]);
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
                      "LET'S START",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
