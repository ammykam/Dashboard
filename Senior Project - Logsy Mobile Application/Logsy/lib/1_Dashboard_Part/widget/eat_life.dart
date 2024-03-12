import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:logsy_app/1_Dashboard_Part/widget/eat_date_item.dart';
import 'package:logsy_app/1_Dashboard_Part/widget/eat_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:logsy_app/3_Record_Part/provider/foodRecord.dart';
import 'package:logsy_app/3_Record_Part/provider/waterRecord.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class EatLife extends StatefulWidget {
  final DateTime dateSelect;

  EatLife(this.dateSelect);
  @override
  _EatLifeState createState() => _EatLifeState();
}

class _EatLifeState extends State<EatLife> {
  int touchedIndex;
  bool _isInit = true;
  Map<String, int> _skippedMeal;
  Map<String, dynamic> _summaryNutrients;
  int _waterGlass;
  List<Map<String, dynamic>> _graphData = [];
  DailyIntake daily;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final foodRec = Provider.of<FoodRecordProvider>(context, listen: false);
      final waterRec = Provider.of<WaterRecordProvider>(context, listen: false);
      final user = Provider.of<UserProvider>(context, listen: false);
      DateTime startDate = widget.dateSelect.weekday == 7
          ? widget.dateSelect
          : widget.dateSelect
              .subtract(Duration(days: widget.dateSelect.weekday));
      DateTime endDate = widget.dateSelect.weekday == 7
          ? widget.dateSelect.add(Duration(days: 6))
          : widget.dateSelect.subtract(
              Duration(days: widget.dateSelect.weekday - 6),
            );
      await user.getDailyIntakes(user.loginUser).then((value) {
        daily = value;
      });
      await waterRec
          .getTotalSummary(user.loginUser, startDate, endDate)
          .then((value) {
        _waterGlass = value;
        print(_waterGlass);
      });
      await foodRec
          .getTotalSummary(user.loginUser, startDate, endDate)
          .then((value) {
        _summaryNutrients = value;
      });
      await foodRec
          .getGraphData(user.loginUser, startDate, endDate)
          .then((value) {
        _graphData = value;
      });
      await foodRec
          .getSkippedMeal(user.loginUser, startDate, endDate)
          .then((value) {
        setState(() {
          _skippedMeal = value;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant EatLife oldWidget) {
    final foodRec = Provider.of<FoodRecordProvider>(context, listen: false);
    final waterRec = Provider.of<WaterRecordProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    DateTime startDate = widget.dateSelect.weekday == 7
        ? widget.dateSelect
        : widget.dateSelect.subtract(Duration(days: widget.dateSelect.weekday));
    DateTime endDate = widget.dateSelect.weekday == 7
        ? widget.dateSelect.add(Duration(days: 6))
        : widget.dateSelect.subtract(
            Duration(days: widget.dateSelect.weekday - 6),
          );
    user.getDailyIntakes(user.loginUser).then((value) {
      setState(() {
        daily = value;
      });
    });
    foodRec.getTotalSummary(user.loginUser, startDate, endDate).then((value) {
      setState(() {
        _summaryNutrients = value;
      });
    });
    foodRec.getSkippedMeal(user.loginUser, startDate, endDate).then((value) {
      setState(() {
        _skippedMeal = value;
      });
    });
    foodRec.getGraphData(user.loginUser, startDate, endDate).then((value) {
      setState(() {
        _graphData = value;
      });
    });
    waterRec.getTotalSummary(user.loginUser, startDate, endDate).then((value) {
      setState(() {
        _waterGlass = value;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y > daily.maxCalories.toDouble()
              ? isTouched
                  ? daily.maxCalories.toDouble() + 50
                  : daily.maxCalories.toDouble()
              : isTouched
                  ? y + 50
                  : y,
          //  isTouched ? y + 50 : y,
          colors: [
            y < daily.minCalories.toDouble()
                ? Colors.red[300]
                : y > daily.maxCalories.toDouble()
                    ? Colors.red[300]
                    : Colors.lightGreen[600]
          ],
          width: 22,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: daily.maxCalories.toDouble(),
            colors: [Colors.white60],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, _graphData[0]['value'].toDouble(),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, _graphData[1]['value'].toDouble(),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, _graphData[2]['value'].toDouble(),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, _graphData[3]['value'].toDouble(),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, _graphData[4]['value'].toDouble(),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, _graphData[5]['value'].toDouble(),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, _graphData[6]['value'].toDouble(),
                isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
         
              return BarTooltipItem('${_graphData[groupIndex]['value']} cal',
                  TextStyle(color: Colors.yellow));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          rotateAngle: 270,
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return DateFormat('d MMM')
                    .format(_graphData[0]['timestamp'])
                    .toString()
                    .toUpperCase();
              case 1:
                return DateFormat('d MMM')
                    .format(_graphData[1]['timestamp'])
                    .toString()
                    .toUpperCase();
              case 2:
                return DateFormat('d MMM')
                    .format(_graphData[2]['timestamp'])
                    .toString()
                    .toUpperCase();
              case 3:
                return DateFormat('d MMM')
                    .format(_graphData[3]['timestamp'])
                    .toString()
                    .toUpperCase();
              case 4:
                return DateFormat('d MMM')
                    .format(_graphData[4]['timestamp'])
                    .toString()
                    .toUpperCase();
              case 5:
                return DateFormat('d MMM')
                    .format(_graphData[5]['timestamp'])
                    .toString()
                    .toUpperCase();
              case 6:
                return DateFormat('d MMM')
                    .format(_graphData[6]['timestamp'])
                    .toString()
                    .toUpperCase();
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _skippedMeal == null ||
              _summaryNutrients == null ||
              _waterGlass == null ||
              daily == null
          ? LinearProgressIndicator(
              color: Colors.teal[500],
              minHeight: 0.1,
            )
          : Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Container(
                      child: Text("Know More About Your Day",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10),
                    EatDateItem(widget.dateSelect),
                    SizedBox(height: 15),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SKIPPED\nMEAL",
                            style: TextStyle(
                                color: Colors.red[400],
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Breakfast",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _skippedMeal['breakfast'].toString(),
                                style: TextStyle(
                                    color: _skippedMeal['breakfast'] > 0
                                        ? Colors.red[300]
                                        : Colors.grey[800],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lunch",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _skippedMeal['lunch'].toString(),
                                style: TextStyle(
                                    color: _skippedMeal['lunch'] > 0
                                        ? Colors.red[300]
                                        : Colors.grey[800],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Dinner",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _skippedMeal['dinner'].toString(),
                                style: TextStyle(
                                    color: _skippedMeal['dinner'] > 0
                                        ? Colors.red[300]
                                        : Colors.grey[800],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: Text("Daily Average Nutrients Intakes",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10),
                    EatItem(
                        "Calories",
                        _summaryNutrients['TotalCalories'].toDouble(),
                        daily.maxCalories.toDouble(),
                        Colors.green[400],
                        Colors.green[100]),
                    SizedBox(height: 10),
                    EatItem(
                        "Carbohydrates",
                        _summaryNutrients['TotalCarbohydrate'].toDouble(),
                        daily.maxCarb.toDouble(),
                        Colors.amber[400],
                        Colors.amber[100]),
                    SizedBox(height: 10),
                    EatItem(
                        "Protein",
                        _summaryNutrients['TotalProtein'].toDouble(),
                        daily.maxProtein.toDouble(),
                        Colors.blue[400],
                        Colors.blue[100]),
                    SizedBox(height: 10),
                    EatItem(
                        "Fats",
                        _summaryNutrients['TotalFat'].toDouble(),
                        daily.maxFat.toDouble(),
                        Colors.deepPurple[400],
                        Colors.deepPurple[100]),
                    // SizedBox(height: 10),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(
                                _waterGlass > 4 ? 4 : _waterGlass,
                                (index) => Image.asset(
                                  'assets/full.png',
                                  height: 40,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: List.generate(
                                _waterGlass > 4
                                    ? _waterGlass > 8
                                        ? 4
                                        : _waterGlass - 4
                                    : 0,
                                (index) => Image.asset(
                                  'assets/full.png',
                                  height: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Text(_waterGlass.toString(),
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 50)),
                            SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Average of",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  "Glasses / Day",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: Text("Calories Consumption",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 20),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        color: Colors.blueGrey[200],
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: BarChart(
                                        mainBarData(),
                                        swapAnimationDuration:
                                            Duration(milliseconds: 250),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20)
                                ],
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
    );
  }
}
