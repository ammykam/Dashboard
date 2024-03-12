import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/3_Record_Part/provider/sleepRecord.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SleepScreen extends StatefulWidget {
  static const routeName = '/sleep-screen';

  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final _form = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isErr = false;
  var _calendarController;
  Map<String, dynamic> _info = {
    "date": DateTime.now(),
    "startTime": "",
    "endTime": "",
  };

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    _form.currentState.save();
    _isErr = false;
    if (_info["date"] == "" ||
        _info["startTime"] == "" ||
        _info["endTime"] == "") {
      setState(() {
        _isErr = true;
      });
    } else {
      final sleepRec = Provider.of<SleepRecordProvider>(context, listen: false);
      final user = Provider.of<UserProvider>(context, listen: false);
      String day = DateFormat("yyyy-MM-dd").format(_info["date"]);

      await sleepRec.addSleepRecord(SleepRecord(
        sleepRecID: 0,
        user_uid: user.loginUser,
        date: _info["date"],
        bedTime: DateTime.parse("${day} ${_info["startTime"]}"),
        wakeTime: DateTime.parse("${day} ${_info["endTime"]}"),
      ));
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
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topRight,
        //     end: Alignment.bottomLeft,
        //     colors: [Colors.deepPurple, Colors.white],
        //   ),
        // ),
        color: Color.fromRGBO(232, 230, 198, 100),
        child: Form(
          key: _form,
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sleep',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.teal[500],
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          context: context,
                          builder: (builder) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.45,
                              child: TableCalendar(
                                endDay: DateTime.now(),
                                calendarController: _calendarController,
                                initialSelectedDay: _info["date"],
                                onDaySelected: (date, _, __) {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _info["date"] = date;
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                DateFormat("dd MMM y")
                                    .format(_info["date"])
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.teal[700],
                                  fontSize: 20,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 30,
                                color: Colors.teal[700],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                "Sleep",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                DatePicker.showTimePicker(context,
                                    showTitleActions: true,
                                    showSecondsColumn: false,
                                    onConfirm: (time) {
                                  setState(() {
                                    _info["startTime"] =
                                        DateFormat("HH:mm").format(time);
                                  });
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                              child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: Center(
                                      child: Text(
                                    _info["startTime"],
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                "Wake Up",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                DatePicker.showTimePicker(context,
                                    showTitleActions: true,
                                    showSecondsColumn: false,
                                    onConfirm: (time) {
                                  setState(() {
                                    _info["endTime"] =
                                        DateFormat("HH:mm").format(time);
                                  });
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                              child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: Center(
                                      child: Text(
                                    _info["endTime"],
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ButtonTheme(
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Icon(Icons.close)),
                                                ],
                                              ),
                                              Image.asset(
                                                  "assets/Popup/surprised.png",
                                                  width: 90,
                                                  height: 90),
                                              SizedBox(height: 20),
                                              Text("Oops!!",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 20),
                                              Text('The face was surprised!',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12)),
                                              Text(
                                                'Please select the time.',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                                textAlign: TextAlign.center,
                                              ),
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Icon(Icons.close)),
                                                ],
                                              ),
                                              Image.asset(
                                                  "assets/Popup/sleeping.png",
                                                  width: 90,
                                                  height: 90),
                                              SizedBox(height: 20),
                                              Text("Yayy!!",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 20),
                                              Text('The bed is ready!',
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
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
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
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.amber,
                        child: Text(
                          "RECORD",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
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
