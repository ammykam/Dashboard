import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/edit-profile";

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _userFocus = FocusNode();
  final _firstFocus = FocusNode();
  final _lastFocus = FocusNode();
  final _mailFocus = FocusNode();
  final _ageFocus = FocusNode();
  final _heightFocus = FocusNode();
  final _weightFocus = FocusNode();
  final _idealFocus = FocusNode();
  final _descFocus = FocusNode();
  final _exerciseGoalFocus = FocusNode();
  final _stepGoalFocus = FocusNode();

  @override
  void dispose() {
    _userFocus.dispose();
    _firstFocus.dispose();
    _lastFocus.dispose();
    _mailFocus.dispose();
    _ageFocus.dispose();
    _heightFocus.dispose();
    _weightFocus.dispose();
    _idealFocus.dispose();
    _descFocus.dispose();
    _exerciseGoalFocus.dispose();
    _stepGoalFocus.dispose();

    super.dispose();
  }

  var _isInit = true;
  var _isLoading = false;
  User person;
  bool isValid;
  var _isLoading2 = false;
  int _selectAvatar;
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
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final uid = ModalRoute.of(context).settings.arguments as int;
      final user = Provider.of<UserProvider>(context);
      await user.getUser(uid).then((value) {
        person = value as User;
        _info = {
          "uid": person.uid,
          "username": person.username,
          "password": person.pwd,
          "desc": person.des,
          "firstName": person.firstName,
          "lastName": person.lastName,
          "email": person.email,
          "age": person.age,
          "weight": person.weight,
          "height": person.height,
          "physicalActivity": person.physicalActivity,
          "idealWeight": person.idealWeight,
          "gender": person.gender,
          "goal": person.goal,
          "eatInterest": [],
          "sleepInterest": [],
          "exerciseInterest": [],
          "exerciseGoal": person.exerciseGoal,
          "sleepGoal": person.sleepGoal,
          "imgUrl": person.imgUrl,
          "stepGoal": person.stepGoal
        };
      });
      if (_info["imgUrl"].length == 12) {
        _selectAvatar = int.parse(_info["imgUrl"].substring(0, 1)) - 1;
      } else {
        _selectAvatar = int.parse(_info["imgUrl"].substring(0, 2)) - 1;
      }

      await user.getInterestCategory(uid).then((value) {
        setState(() {
          List<String> _eat = [];
          List<String> _sleep = [];
          List<String> _exercise = [];

          for (final element in value) {
            if (element['type'] == "eat") {
              _eat.add(element["interest"]);
            } else if (element['type'] == "sleep") {
              _sleep.add(element["interest"]);
            } else if (element['type'] == "exercise") {
              _exercise.add(element["interest"]);
            }
          }
          _info["eatInterest"] = _eat;
          for (final element in interest) {
            int index = _eat.indexWhere((data) => data == element['name']);
            if (index != -1) {
              element['click'] = true;
            }
          }
          _info["sleepInterest"] = _sleep;
          for (final element in sleep) {
            int index = _sleep.indexWhere((data) => data == element['name']);
            if (index != -1) {
              element['click'] = true;
            }
          }
          _info["exerciseInterest"] = _exercise;
          for (final element in exercise) {
            int index = _exercise.indexWhere((data) => data == element['name']);
            if (index != -1) {
              element['click'] = true;
            }
          }
        });
      });
    }
    _isInit = false;
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
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

  void _saveForm() async {
    _form.currentState.save();
    print(_info);

    isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading2 = true;
    });
    await Provider.of<UserProvider>(context, listen: false).updateUser({
      "uid": _info["uid"],
      "username": person.username,
      "password": person.pwd,
      "desc": _info["desc"],
      "firstName": _info["firstName"],
      "lastName": _info["lastName"],
      "email": _info["email"],
      "age": _info["age"],
      "weight": _info["weight"],
      "height": _info["height"],
      "physicalActivity": _info["physicalActivity"],
      "idealWeight": _info["idealWeight"],
      "gender": _info["gender"],
      "goal": _info["goal"],
      "eatInterest": _info["eatInterest"],
      "sleepInterest": _info["sleepInterest"],
      "exerciseInterest": _info["exerciseInterest"],
      "exerciseGoal": _info["exerciseGoal"],
      "sleepGoal": _info["sleepGoal"],
      "imgUrl": _info["imgUrl"],
      "stepGoal": _info["stepGoal"]
    }).then(
      (_) {
        setState(() {
          _isLoading2 = false;
        });
      },
    );
  }

  void _changeAvater(int index) {
    setState(() {
      _selectAvatar = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "EDIT PROFILE",
          style: TextStyle(
            fontSize: 18,
            color: Colors.teal[500],
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: person == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.width * 0.35,
                            margin: EdgeInsets.only(bottom: 0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/avatar/${_selectAvatar + 1}_Avatar.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonTheme(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 30,
                          child: RaisedButton(
                            elevation: 0.0,
                            color: Colors.teal[400],
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      content: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.62,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Wrap(
                                                spacing: 10,
                                                runSpacing: 5,
                                                children: List.generate(
                                                  50,
                                                  (index) => GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _selectAvatar = index;
                                                        _changeAvater(index);
                                                      });
                                                    },
                                                    child: _selectAvatar ==
                                                            index
                                                        ? CircleAvatar(
                                                            backgroundImage:
                                                                AssetImage(
                                                                    "assets/avatar/${index + 1}_Avatar.png"),
                                                            child:
                                                                IconShadowWidget(
                                                              Icon(Icons.check,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .white),
                                                              shadowColor:
                                                                  Colors.black,
                                                            ),
                                                          )
                                                        : CircleAvatar(
                                                            backgroundImage:
                                                                AssetImage(
                                                                    "assets/avatar/${index + 1}_Avatar.png"),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ButtonTheme(
                                              height: 30,
                                              child: FlatButton(
                                                color: Colors.amber,
                                                onPressed: () {
                                                  setState(() {
                                                    _info = {
                                                      "uid": _info["uid"],
                                                      "username":
                                                          _info['username'],
                                                      "password":
                                                          _info['password'],
                                                      "desc": _info["desc"],
                                                      "firstName":
                                                          _info["firstName"],
                                                      "lastName":
                                                          _info["lastName"],
                                                      "email": _info["email"],
                                                      "age": _info["age"],
                                                      "weight": _info["weight"],
                                                      "height": _info["height"],
                                                      "physicalActivity": _info[
                                                          "physicalActivity"],
                                                      "idealWeight":
                                                          _info["idealWeight"],
                                                      "gender": _info["gender"],
                                                      "goal": _info["goal"],
                                                      "eatInterest":
                                                          _info["eatInterest"],
                                                      "sleepInterest": _info[
                                                          "sleepInterest"],
                                                      "exerciseInterest": _info[
                                                          "exerciseInterest"],
                                                      "exerciseGoal":
                                                          _info["exerciseGoal"],
                                                      "sleepGoal":
                                                          _info["sleepGoal"],
                                                      "imgUrl":
                                                          "${_selectAvatar + 1}_Avatar.png",
                                                      "stepGoal":
                                                          _info["stepGoal"]
                                                    };
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("save",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                            child: Text(
                              "Change Profile Picture",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(thickness: 2.0, color: Colors.teal[300]),

                    //First Name
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "First Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(width: 12),
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
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.045,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  onSaved: (value) {
                                    _info = {
                                      "uid": _info["uid"],
                                      "username": _info['username'],
                                      "password": _info['password'],
                                      "desc": _info["desc"],
                                      "firstName": value,
                                      "lastName": _info["lastName"],
                                      "email": _info["email"],
                                      "age": _info["age"],
                                      "weight": _info["weight"],
                                      "height": _info["height"],
                                      "physicalActivity":
                                          _info["physicalActivity"],
                                      "idealWeight": _info["idealWeight"],
                                      "gender": _info["gender"],
                                      "goal": _info["goal"],
                                      "eatInterest": _info["eatInterest"],
                                      "sleepInterest": _info["sleepInterest"],
                                      "exerciseInterest":
                                          _info["exerciseInterest"],
                                      "exerciseGoal": _info["exerciseGoal"],
                                      "sleepGoal": _info["sleepGoal"],
                                      "imgUrl": _info["imgUrl"],
                                      "stepGoal": _info["stepGoal"]
                                    };
                                  },
                                  initialValue: person.firstName,
                                  focusNode: _firstFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_lastFocus);
                                  },
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                  cursorColor: Colors.teal,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "first name",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 15,
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
                    //Last Name
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Last Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(width: 12),
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
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.045,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  onSaved: (value) {
                                    _info = {
                                      "uid": _info["uid"],
                                      "username": _info['username'],
                                      "password": _info['password'],
                                      "desc": _info["desc"],
                                      "firstName": _info["firstName"],
                                      "lastName": value,
                                      "email": _info["email"],
                                      "age": _info["age"],
                                      "weight": _info["weight"],
                                      "height": _info["height"],
                                      "physicalActivity":
                                          _info["physicalActivity"],
                                      "idealWeight": _info["idealWeight"],
                                      "gender": _info["gender"],
                                      "goal": _info["goal"],
                                      "eatInterest": _info["eatInterest"],
                                      "sleepInterest": _info["sleepInterest"],
                                      "exerciseInterest":
                                          _info["exerciseInterest"],
                                      "exerciseGoal": _info["exerciseGoal"],
                                      "sleepGoal": _info["sleepGoal"],
                                      "imgUrl": _info["imgUrl"],
                                      "stepGoal": _info["stepGoal"]
                                    };
                                  },
                                  initialValue: person.lastName,
                                  focusNode: _lastFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_mailFocus);
                                  },
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 12),
                                  cursorColor: Colors.teal,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "last name",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 15,
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
                    //Email
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Material(
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.045,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  person.email,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                ),
                                // child: TextFormField(
                                //   enabled: false,
                                //   //readOnly: true,
                                //   onSaved: (value) {
                                //     _info = {
                                //       "uid": _info["uid"],
                                //       "username": _info['username'],
                                //       "password": _info['password'],
                                //       "desc": _info["desc"],
                                //       "firstName": _info["firstName"],
                                //       "lastName": _info["lastName"],
                                //       "email": value,
                                //       "age": _info["age"],
                                //       "weight": _info["weight"],
                                //       "height": _info["height"],
                                //       "physicalActivity":
                                //           _info["physicalActivity"],
                                //       "idealWeight": _info["idealWeight"],
                                //       "gender": _info["gender"],
                                //       "goal": _info["goal"],
                                //       "eatInterest": _info["eatInterest"],
                                //       "sleepInterest": _info["sleepInterest"],
                                //       "exerciseInterest":
                                //           _info["exerciseInterest"],
                                //       "exerciseGoal": _info["exerciseGoal"],
                                //       "sleepGoal": _info["sleepGoal"],
                                //       "imgUrl": _info["imgUrl"],
                                //       "stepGoal": _info["stepGoal"]
                                //     };
                                //   },
                                //   initialValue: person.email,
                                //   focusNode: _mailFocus,
                                //   onFieldSubmitted: (_) {
                                //     FocusScope.of(context)
                                //         .requestFocus(_ageFocus);
                                //   },
                                //   style: TextStyle(
                                //       color: Colors.grey[700], fontSize: 12),
                                //   cursorColor: Colors.teal,
                                //   keyboardType: TextInputType.text,
                                //   decoration: InputDecoration(
                                //     hintText: "email",
                                //     hintStyle: TextStyle(
                                //       color: Colors.grey[500],
                                //       fontSize: 15,
                                //     ),
                                //     labelStyle: TextStyle(color: Colors.teal),
                                //     enabledBorder: InputBorder.none,
                                //     focusedBorder: InputBorder.none,
                                //     border: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(25.0),
                                //       borderSide: BorderSide.none,
                                //     ),
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Age, Weight
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Age",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Weight",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
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
                                              0.045,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        onSaved: (value) {
                                          _info = {
                                            "uid": _info["uid"],
                                            "username": _info['username'],
                                            "password": _info['password'],
                                            "desc": _info["desc"],
                                            "firstName": _info["firstName"],
                                            "lastName": _info["lastName"],
                                            "email": _info["email"],
                                            "age": value,
                                            "weight": _info["weight"],
                                            "height": _info["height"],
                                            "physicalActivity":
                                                _info["physicalActivity"],
                                            "idealWeight": _info["idealWeight"],
                                            "gender": _info["gender"],
                                            "goal": _info["goal"],
                                            "eatInterest": _info["eatInterest"],
                                            "sleepInterest":
                                                _info["sleepInterest"],
                                            "exerciseInterest":
                                                _info["exerciseInterest"],
                                            "exerciseGoal":
                                                _info["exerciseGoal"],
                                            "sleepGoal": _info["sleepGoal"],
                                            "imgUrl": _info["imgUrl"],
                                            "stepGoal": _info["stepGoal"]
                                          };
                                        },
                                        initialValue: person.age.toString(),
                                        focusNode: _ageFocus,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(_heightFocus);
                                        },
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                        cursorColor: Colors.teal,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: true, decimal: true),
                                        decoration: InputDecoration(
                                          hintText: "age",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 15,
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
                                SizedBox(height: 16),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
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
                                              0.045,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        onSaved: (value) {
                                          _info = {
                                            "uid": _info["uid"],
                                            "username": _info['username'],
                                            "password": _info['password'],
                                            "desc": _info["desc"],
                                            "firstName": _info["firstName"],
                                            "lastName": _info["lastName"],
                                            "email": _info["email"],
                                            "age": _info["age"],
                                            "weight": value,
                                            "height": _info["height"],
                                            "physicalActivity":
                                                _info["physicalActivity"],
                                            "idealWeight": _info["idealWeight"],
                                            "gender": _info["gender"],
                                            "goal": _info["goal"],
                                            "eatInterest": _info["eatInterest"],
                                            "sleepInterest":
                                                _info["sleepInterest"],
                                            "exerciseInterest":
                                                _info["exerciseInterest"],
                                            "exerciseGoal":
                                                _info["exerciseGoal"],
                                            "sleepGoal": _info["sleepGoal"],
                                            "imgUrl": _info["imgUrl"],
                                            "stepGoal": _info["stepGoal"]
                                          };
                                        },
                                        initialValue: person.weight.toString(),
                                        focusNode: _weightFocus,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(_idealFocus);
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
                                            fontSize: 15,
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
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("year", style: TextStyle(fontSize: 12)),
                                SizedBox(
                                  height: 16,
                                ),
                                Text("kg", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Height",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Ideal\nWeight",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
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
                                              0.045,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        onSaved: (value) {
                                          _info = {
                                            "uid": _info["uid"],
                                            "username": _info['username'],
                                            "password": _info['password'],
                                            "desc": _info["desc"],
                                            "firstName": _info["firstName"],
                                            "lastName": _info["lastName"],
                                            "email": _info["email"],
                                            "age": _info["age"],
                                            "weight": _info["weight"],
                                            "height": value,
                                            "physicalActivity":
                                                _info["physicalActivity"],
                                            "idealWeight": _info["idealWeight"],
                                            "gender": _info["gender"],
                                            "goal": _info["goal"],
                                            "eatInterest": _info["eatInterest"],
                                            "sleepInterest":
                                                _info["sleepInterest"],
                                            "exerciseInterest":
                                                _info["exerciseInterest"],
                                            "exerciseGoal":
                                                _info["exerciseGoal"],
                                            "sleepGoal": _info["sleepGoal"],
                                            "imgUrl": _info["imgUrl"],
                                            "stepGoal": _info["stepGoal"]
                                          };
                                        },
                                        initialValue: person.height.toString(),
                                        focusNode: _heightFocus,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(_weightFocus);
                                        },
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12),
                                        cursorColor: Colors.teal,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: true, decimal: true),
                                        decoration: InputDecoration(
                                          hintText: "height",
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 15,
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
                                SizedBox(height: 16),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
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
                                              0.045,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: TextFormField(
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        onSaved: (value) {
                                          _info = {
                                            "uid": _info["uid"],
                                            "username": _info['username'],
                                            "password": _info['password'],
                                            "desc": _info["desc"],
                                            "firstName": _info["firstName"],
                                            "lastName": _info["lastName"],
                                            "email": _info["email"],
                                            "age": _info["age"],
                                            "weight": _info["weight"],
                                            "height": _info["height"],
                                            "physicalActivity":
                                                _info["physicalActivity"],
                                            "idealWeight": value,
                                            "gender": _info["gender"],
                                            "goal": _info["goal"],
                                            "eatInterest": _info["eatInterest"],
                                            "sleepInterest":
                                                _info["sleepInterest"],
                                            "exerciseInterest":
                                                _info["exerciseInterest"],
                                            "exerciseGoal":
                                                _info["exerciseGoal"],
                                            "sleepGoal": _info["sleepGoal"],
                                            "imgUrl": _info["imgUrl"],
                                            "stepGoal": _info["stepGoal"]
                                          };
                                        },
                                        initialValue:
                                            person.idealWeight.toString(),
                                        focusNode: _idealFocus,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(_descFocus);
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
                                            fontSize: 15,
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
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "cm",
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "kg",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Gender
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                "Gender",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Material(
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: DropdownButtonFormField(
                                      onChanged: (value) {
                                        _info = {
                                          "uid": _info["uid"],
                                          "username": _info['username'],
                                          "password": _info['password'],
                                          "desc": _info["desc"],
                                          "firstName": _info["firstName"],
                                          "lastName": _info["lastName"],
                                          "email": _info["email"],
                                          "age": _info["age"],
                                          "weight": _info["weight"],
                                          "height": _info["height"],
                                          "physicalActivity":
                                              _info["physicalActivity"],
                                          "idealWeight": _info["idealWeight"],
                                          "gender": value,
                                          "goal": _info["goal"],
                                          "eatInterest": _info["eatInterest"],
                                          "sleepInterest":
                                              _info["sleepInterest"],
                                          "exerciseInterest":
                                              _info["exerciseInterest"],
                                          "exerciseGoal": _info["exerciseGoal"],
                                          "sleepGoal": _info["sleepGoal"],
                                          "imgUrl": _info["imgUrl"],
                                          "stepGoal": _info["stepGoal"]
                                        };
                                      },
                                      value: person.gender,
                                      items: ["Female", "Male"]
                                          .map(
                                            (gen) => DropdownMenuItem(
                                              value: gen,
                                              child: Text(gen),
                                            ),
                                          )
                                          .toList(),
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12),
                                      decoration: InputDecoration(
                                        hintText: "gender",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 15,
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
                            ],
                          ),
                        ),
                        //Goal
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                "Goal",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Material(
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: DropdownButtonFormField(
                                      onChanged: (value) {
                                        _info = {
                                          "uid": _info["uid"],
                                          "username": _info['username'],
                                          "password": _info['password'],
                                          "desc": _info["desc"],
                                          "firstName": _info["firstName"],
                                          "lastName": _info["lastName"],
                                          "email": _info["email"],
                                          "age": _info["age"],
                                          "weight": _info["weight"],
                                          "height": _info["height"],
                                          "physicalActivity":
                                              _info["physicalActivity"],
                                          "idealWeight": _info["idealWeight"],
                                          "gender": _info["gender"],
                                          "goal": value,
                                          "eatInterest": _info["eatInterest"],
                                          "sleepInterest":
                                              _info["sleepInterest"],
                                          "exerciseInterest":
                                              _info["exerciseInterest"],
                                          "exerciseGoal": _info["exerciseGoal"],
                                          "sleepGoal": _info["sleepGoal"],
                                          "imgUrl": _info["imgUrl"],
                                          "stepGoal": _info["stepGoal"]
                                        };
                                      },
                                      value: person.goal,
                                      items: ["Loss", "Maintain", "Gain"]
                                          .map(
                                            (gen) => DropdownMenuItem(
                                              value: gen,
                                              child: Text(gen),
                                            ),
                                          )
                                          .toList(),
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12),
                                      decoration: InputDecoration(
                                        hintText: "goal",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 15,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    //des
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.68,
                            child: Material(
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  onSaved: (value) {
                                    _info = {
                                      "uid": _info["uid"],
                                      "username": _info['username'],
                                      "password": _info['password'],
                                      "desc": value,
                                      "firstName": _info["firstName"],
                                      "lastName": _info["lastName"],
                                      "email": _info["email"],
                                      "age": _info["age"],
                                      "weight": _info["weight"],
                                      "height": _info["height"],
                                      "physicalActivity":
                                          _info["physicalActivity"],
                                      "idealWeight": _info["idealWeight"],
                                      "gender": _info["gender"],
                                      "goal": _info["goal"],
                                      "eatInterest": _info["eatInterest"],
                                      "sleepInterest": _info["sleepInterest"],
                                      "exerciseInterest":
                                          _info["exerciseInterest"],
                                      "exerciseGoal": _info["exerciseGoal"],
                                      "sleepGoal": _info["sleepGoal"],
                                      "imgUrl": _info["imgUrl"],
                                      "stepGoal": _info["stepGoal"]
                                    };
                                  },
                                  initialValue: person.des,
                                  focusNode: _descFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_exerciseGoalFocus);
                                  },
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 12),
                                  cursorColor: Colors.teal,
                                  decoration: InputDecoration(
                                    hintText: "desc",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 15,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: Text(
                              "Exercise Goal",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Material(
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  initialValue: person.exerciseGoal.toString(),
                                  onSaved: (value) {
                                    _info = {
                                      "uid": _info["uid"],
                                      "username": _info['username'],
                                      "password": _info['password'],
                                      "desc": _info["desc"],
                                      "firstName": _info["firstName"],
                                      "lastName": _info["lastName"],
                                      "email": _info["email"],
                                      "age": _info["age"],
                                      "weight": _info["weight"],
                                      "height": _info["height"],
                                      "physicalActivity":
                                          _info["physicalActivity"],
                                      "idealWeight": _info["idealWeight"],
                                      "gender": _info["gender"],
                                      "goal": _info["goal"],
                                      "eatInterest": _info["eatInterest"],
                                      "sleepInterest": _info["sleepInterest"],
                                      "exerciseInterest":
                                          _info["exerciseInterest"],
                                      "exerciseGoal": value,
                                      "sleepGoal": _info["sleepGoal"],
                                      "imgUrl": _info["imgUrl"],
                                      "stepGoal": _info["stepGoal"]
                                    };
                                  },
                                  focusNode: _exerciseGoalFocus,
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 12),
                                  cursorColor: Colors.teal,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  decoration: InputDecoration(
                                    hintText: "goal",
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            child: Text(
                              "Step Goal",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          SizedBox(width: 5),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Material(
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  initialValue: person.stepGoal.toString(),
                                  onSaved: (value) {
                                    _info = {
                                      "uid": _info["uid"],
                                      "username": _info['username'],
                                      "password": _info['password'],
                                      "desc": _info["desc"],
                                      "firstName": _info["firstName"],
                                      "lastName": _info["lastName"],
                                      "email": _info["email"],
                                      "age": _info["age"],
                                      "weight": _info["weight"],
                                      "height": _info["height"],
                                      "physicalActivity":
                                          _info["physicalActivity"],
                                      "idealWeight": _info["idealWeight"],
                                      "gender": _info["gender"],
                                      "goal": _info["goal"],
                                      "eatInterest": _info["eatInterest"],
                                      "sleepInterest": _info["sleepInterest"],
                                      "exerciseInterest":
                                          _info["exerciseInterest"],
                                      "exerciseGoal": _info["exerciseGoal"],
                                      "sleepGoal": _info["sleepGoal"],
                                      "imgUrl": _info["imgUrl"],
                                      "stepGoal": value
                                    };
                                  },
                                  focusNode: _stepGoalFocus,
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 12),
                                  cursorColor: Colors.teal,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  decoration: InputDecoration(
                                    hintText: "goal",
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                IntrinsicWidth(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    //Button
                    ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.04,
                      buttonColor: Colors.teal[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: RaisedButton(
                        onPressed: () {
                          _saveForm();
                          if (!_isLoading2) {
                            Center(child: CircularProgressIndicator());
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
                                        Image.asset("assets/Popup/happy-2.png",
                                            width: 90, height: 90),
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
                          }
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ),
    );
  }
}
