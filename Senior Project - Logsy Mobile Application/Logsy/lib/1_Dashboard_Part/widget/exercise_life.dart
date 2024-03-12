import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/1_Dashboard_Part/widget/exer_item.dart';
import 'package:logsy_app/3_Record_Part/provider/exerciseRecord.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ExerciseLife extends StatefulWidget {
  final DateTime dateSelect;

  ExerciseLife(this.dateSelect);
  @override
  _ExerciseLifeState createState() => _ExerciseLifeState();
}

class _ExerciseLifeState extends State<ExerciseLife> {
  List<Map<String, dynamic>> weekData = [];
  double _avg;
  double _stepGoal;
  List<ExerciseRecord> exerData = [];
  bool _init = true;
  int steps = 0;
  Map<String, dynamic> _summary = {"workouts": 0, "time": 0, "calories": 0};
  List<HealthDataPoint> _healthDataList = [];

  @override
  void didChangeDependencies() async {
    if (_init) {
      final user = Provider.of<UserProvider>(context, listen: false);
      final _exerRec =
          Provider.of<ExerciseRecordProvider>(context, listen: false);

      DateTime startDate = widget.dateSelect.weekday == 7
          ? widget.dateSelect
          : widget.dateSelect
              .subtract(Duration(days: widget.dateSelect.weekday));
      DateTime endDate = widget.dateSelect.weekday == 7
          ? widget.dateSelect.add(Duration(days: 6))
          : widget.dateSelect.subtract(
              Duration(days: widget.dateSelect.weekday - 6),
            );
      HealthFactory health = HealthFactory();
      List<HealthDataType> types = [HealthDataType.STEPS];
      bool accessWasGranted = await health.requestAuthorization(types);
      if (accessWasGranted) {
        try {
          List<HealthDataPoint> healthData =
              await health.getHealthDataFromTypes(startDate, endDate, types);
          _healthDataList.addAll(healthData);
        } catch (e) {
          print("Caught exception in getHealthDataFromTypes: $e");
        }

        _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
        double sun = 0;
        double mon = 0;
        double tue = 0;
        double wed = 0;
        double thu = 0;
        double fri = 0;
        double sat = 0;

        print(_healthDataList);

        for (final element in _healthDataList) {
          print(element);
          if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
              "SUN") {
            sun = sun + element.value;
          } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
              "MON") {
            mon = mon + element.value;
          } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
              "TUE") {
            tue = tue + element.value;
          } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
              "WED") {
            wed = wed + element.value;
          } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
              "THU") {
            thu = thu + element.value;
          } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
              "FRI") {
            fri = fri + element.value;
          } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
              "SAT") {
            sat = sat + element.value;
          }
        }

        weekData = [
          {"day": "SUN", "value": sun},
          {"day": "MON", "value": mon},
          {"day": "TUE", "value": tue},
          {"day": "WED", "value": wed},
          {"day": "THU", "value": thu},
          {"day": "FRI", "value": fri},
          {"day": "SAT", "value": sat},
        ];

        _avg = (sun + mon + tue + wed + thu + fri + sat) / 7;
      } else {
        print("Authorization not granted");
      }

      await user
          .getUser(user.loginUser)
          .then((value) => {_stepGoal = value.stepGoal.toDouble()});
      await _exerRec
          .getExerciseRecordRange(user.loginUser, startDate, endDate)
          .then((value) {
        setState(() {
          exerData = value;
          _summary["workouts"] = exerData.length;
          for (final data in exerData) {
            _summary["time"] = data.duration + _summary["time"];
            _summary["calories"] = data.calBurnt + _summary["calories"];
          }
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  Future<void> fetchData() async {
    DateTime startDate = widget.dateSelect.weekday == 7
        ? widget.dateSelect
        : widget.dateSelect.subtract(Duration(days: widget.dateSelect.weekday));
    DateTime endDate = widget.dateSelect.weekday == 7
        ? widget.dateSelect.add(Duration(days: 6))
        : widget.dateSelect.subtract(
            Duration(days: widget.dateSelect.weekday - 6),
          );
    HealthFactory health = HealthFactory();
    List<HealthDataType> types = [HealthDataType.STEPS];
    bool accessWasGranted = await health.requestAuthorization(types);
    if (accessWasGranted) {
      try {
        setState(() {
          _healthDataList = [];
        });
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(startDate, endDate, types);
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
      double sun = 0;
      double mon = 0;
      double tue = 0;
      double wed = 0;
      double thu = 0;
      double fri = 0;
      double sat = 0;

      for (final element in _healthDataList) {
        if (DateFormat("EEE").format(element.dateFrom).toUpperCase() == "SUN") {
          sun = sun + element.value;
        } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
            "MON") {
          mon = mon + element.value;
        } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
            "TUE") {
          tue = tue + element.value;
        } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
            "WED") {
          wed = wed + element.value;
        } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
            "THU") {
          thu = thu + element.value;
        } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
            "FRI") {
          fri = fri + element.value;
        } else if (DateFormat("EEE").format(element.dateFrom).toUpperCase() ==
            "SAT") {
          sat = sat + element.value;
        }
      }

      setState(() {
        weekData = [
          {"day": "SUN", "value": sun},
          {"day": "MON", "value": mon},
          {"day": "TUE", "value": tue},
          {"day": "WED", "value": wed},
          {"day": "THU", "value": thu},
          {"day": "FRI", "value": fri},
          {"day": "SAT", "value": sat},
        ];
        _avg = (sun + mon + tue + wed + thu + fri + sat) / 7;
      });
    } else {
      print("Authorization not granted");
    }
  }

  @override
  void didUpdateWidget(covariant ExerciseLife oldWidget) {
    final user = Provider.of<UserProvider>(context, listen: false);
    final _exerRec =
        Provider.of<ExerciseRecordProvider>(context, listen: false);

    DateTime startDate = widget.dateSelect.weekday == 7
        ? widget.dateSelect
        : widget.dateSelect.subtract(Duration(days: widget.dateSelect.weekday));
    DateTime endDate = widget.dateSelect.weekday == 7
        ? widget.dateSelect.add(Duration(days: 6))
        : widget.dateSelect.subtract(
            Duration(days: widget.dateSelect.weekday - 6),
          );
    fetchData();
    _exerRec
        .getExerciseRecordRange(user.loginUser, startDate, endDate)
        .then((value) {
      setState(() {
        exerData = value;
        _summary["workouts"] = exerData.length;
        for (final data in exerData) {
          _summary["time"] = data.duration + _summary["time"];
          _summary["calories"] = data.calBurnt + _summary["calories"];
        }
      });
    });
    setState(() {
      _summary = {"workouts": 0, "time": 0, "calories": 0};
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _avg == null
          ? LinearProgressIndicator(
              color: Colors.teal[500],
              minHeight: 0.1,
            )
          : Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: weekData
                          .map(
                            (data) => CircularPercentIndicator(
                              radius: 30.0,
                              lineWidth: 4.5,
                              percent: data['value'] / _stepGoal > 1
                                  ? 1
                                  : data['value'] / _stepGoal,
                              animation: true,
                              animationDuration: 1200,
                              progressColor: data['value'] / _stepGoal >= 1
                                  ? Colors.green
                                  : data['value'] / _stepGoal < 0.5
                                      ? Colors.red
                                      : Colors.amber,
                              footer: Column(
                                children: [
                                  Text(
                                    data['day'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    data['value'].round().toString(),
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              backgroundColor: data['value'] / _stepGoal == 1
                                  ? Colors.green[100]
                                  : data['value'] / _stepGoal < 0.5
                                      ? Colors.red[100]
                                      : Colors.amber[100],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 200.0,
                    lineWidth: 15.0,
                    percent: _avg / _stepGoal >= 1 ? 1 : _avg / _stepGoal,
                    animation: true,
                    animationDuration: 1200,
                    progressColor: _avg / _stepGoal >= 1
                        ? Colors.green
                        : _avg / _stepGoal < 0.5
                            ? Colors.red
                            : Colors.amber,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _avg.toInt().toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 45),
                        ),
                        Text(
                          "Average Steps",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: _avg / _stepGoal >= 1
                        ? Colors.green[100]
                        : _avg / _stepGoal < 0.5
                            ? Colors.red[100]
                            : Colors.amber[100],
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         alignment: Alignment.centerLeft,
                  //         child: Text(
                  //           'Integrated with Apple health',
                  //           style: TextStyle(fontSize: 10),
                  //         ),
                  //       ),
                  //       SizedBox(width:10),
                  //       Container(
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(3),
                  //             border: Border.all(
                  //               color: Colors.grey[400],
                  //               width: 0.5,
                  //             ),
                  //           ),
                  //           child: Image.asset("assets/healthApple.png",
                  //               height: 15))
                  //     ],
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Workouts",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Workouts",
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                  Text("Time",
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                  Text("Calories",
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_summary["workouts"].toString(),
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                  Text("${_summary["time"]} min",
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                  Text("${_summary["calories"]} KCAL",
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: exerData
                        .map(
                          (data) => ExerItem(
                              Icons.directions_bike,
                              data.exercise_eid,
                              data.calBurnt.toString(),
                              "${data.duration} min",
                              data.timestamp),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
    );
  }
}
