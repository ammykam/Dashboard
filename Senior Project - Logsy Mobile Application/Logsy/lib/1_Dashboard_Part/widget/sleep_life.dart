import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/3_Record_Part/provider/sleepRecord.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class SleepLife extends StatefulWidget {
  final DateTime dateSelect;

  SleepLife(this.dateSelect);
  @override
  _SleepLifeState createState() => _SleepLifeState();
}

class _SleepLifeState extends State<SleepLife> {
  bool _isInit = true;
  List<Map<String, dynamic>> _sleepRecord = [];
  int _sleepAverage;
  int _sleepMax;
  Color _sleepColors;
  Color _sleepColorsBg;
  SleepGoal _sleepGoal;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final sleepRec = Provider.of<SleepRecordProvider>(context, listen: false);
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

      await sleepRec
          .getSleepAverage(user.loginUser, startDate, endDate)
          .then((value) {
        _sleepAverage = value;
      });
      await sleepRec.getSleepGoal(user.loginUser).then((value) {
        _sleepGoal = value;
        _sleepMax = value.maxGreen;

        if (_sleepAverage >= value.minLowerYellow &&
            _sleepAverage <= value.maxLowerYellow) {
          _sleepColors = Colors.amber[100];
          _sleepColorsBg = Colors.amber[300];
        } else if (_sleepAverage >= value.minGreen &&
            _sleepAverage <= value.maxGreen) {
          _sleepColors = Colors.green[100];
          _sleepColorsBg = Colors.green[300];
        } else if (_sleepAverage >= value.minUpperYellow &&
            _sleepAverage <= value.maxUpperYellow) {
          _sleepColors = Colors.amber[100];
          _sleepColorsBg = Colors.amber[300];
        } else {
          _sleepColors = Colors.red[100];
          _sleepColorsBg = Colors.red[300];
        }
      });
      await sleepRec
          .getGraphData(user.loginUser, startDate, endDate)
          .then((value) {
        setState(() {
          _sleepRecord = value;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant SleepLife oldWidget) {
    final sleepRec = Provider.of<SleepRecordProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    DateTime startDate = widget.dateSelect.weekday == 7
        ? widget.dateSelect
        : widget.dateSelect.subtract(Duration(days: widget.dateSelect.weekday));
    DateTime endDate = widget.dateSelect.weekday == 7
        ? widget.dateSelect.add(Duration(days: 6))
        : widget.dateSelect.subtract(
            Duration(days: widget.dateSelect.weekday - 6),
          );

    sleepRec.getSleepAverage(user.loginUser, startDate, endDate).then((value) {
      _sleepAverage = value;
    });
    sleepRec.getSleepGoal(user.loginUser).then((value) {
      _sleepMax = value.maxGreen;

      if (_sleepAverage >= value.minLowerYellow &&
          _sleepAverage <= value.maxLowerYellow) {
        _sleepColors = Colors.amber[100];
        _sleepColorsBg = Colors.amber[300];
      } else if (_sleepAverage >= value.minGreen &&
          _sleepAverage <= value.maxGreen) {
        _sleepColors = Colors.green[100];
        _sleepColorsBg = Colors.green[300];
      } else if (_sleepAverage >= value.minUpperYellow &&
          _sleepAverage <= value.maxUpperYellow) {
        _sleepColors = Colors.amber[100];
        _sleepColorsBg = Colors.amber[300];
      } else {
        _sleepColors = Colors.red[100];
        _sleepColorsBg = Colors.red[300];
      }
    });
    sleepRec.getGraphData(user.loginUser, startDate, endDate).then((value) {
      setState(() {
        _sleepRecord = value;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  LineChartData sampleData1() {
    return LineChartData(
      betweenBarsData: [
        BetweenBarsData(
          fromIndex: 0,
          toIndex: 1,
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.7)
          ],
        )
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            // 2 lines
            LineBarSpot nightTime = touchedBarSpots[0];
            // LineBarSpot morningTime = touchedBarSpots[1];

            //DateTime date;
            DateTime nightDateTime;
            DateTime morningDateTime;

            int _xValue = nightTime.x.toInt();
            var nTime = _sleepRecord[_xValue]["bT"].round().toString();
            var mTime = _sleepRecord[_xValue]["wT"].round().toString();

            // print(nTime);
            // print(mTime);

            if (nTime == "10" && mTime == "10") {
              return [
                LineTooltipItem(
                  'No Record',
                  TextStyle(color: Colors.amber),
                ),
                LineTooltipItem(
                  'This day',
                  TextStyle(color: Colors.amber),
                ),
              ];
            } else {
              if (nTime.length == 3) {
                //01:30
                final sub = int.parse(nTime.substring(0, 1));
                final end = int.parse(nTime.substring(1));
                nightDateTime = DateTime(1998, 11, 17, sub, end);
              } else if (nTime.length == 2) {
                nightDateTime = DateTime(1998, 11, 16, 24, int.parse(nTime));
              } else {
                final sub = int.parse(nTime.substring(0, 2));
                final end = int.parse(nTime.substring(2));
                nightDateTime = DateTime(1998, 11, 16, sub, end);
              }

              if (mTime.length == 3) {
                final sub = int.parse(mTime.substring(0, 1));
                final end = int.parse(mTime.substring(1));
                morningDateTime = DateTime(1998, 11, 17, sub, end);
              } else {
                final sub = int.parse(mTime.substring(0, 2));
                final end = int.parse(mTime.substring(2));
                morningDateTime = DateTime(1998, 11, 17, sub, end);
              }

              print(morningDateTime);
              print(nightDateTime);
              return [
                LineTooltipItem(
                  '${DateFormat("HH:mm").format(nightDateTime)} - ${DateFormat("HH:mm").format(morningDateTime)}',
                  TextStyle(color: Colors.amber),
                ),
                LineTooltipItem(
                    '${morningDateTime.difference(nightDateTime).inHours.toString()} hrs',
                    TextStyle(color: Colors.amber)),
              ];
            }
          },
          tooltipRoundedRadius: 15,
          tooltipBgColor: Colors.blueGrey,
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        drawVerticalLine: true,
        drawHorizontalLine: false,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white38,
            strokeWidth: 1,
          );
        },
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          rotateAngle: 270,
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 10,
          getTitles: (value) {
            //FIX case to fit with changing sleep date range
            switch (value.toInt()) {
              case 0:
                return DateFormat('d MMM')
                    .format(_sleepRecord[0]["timestamp"])
                    .toString()
                    .toUpperCase();
              case 1:
                return DateFormat('d MMM')
                    .format(_sleepRecord[1]["timestamp"])
                    .toString()
                    .toUpperCase();
              case 2:
                return DateFormat('d MMM')
                    .format(_sleepRecord[2]["timestamp"])
                    .toString()
                    .toUpperCase();
              case 3:
                return DateFormat('d MMM')
                    .format(_sleepRecord[3]["timestamp"])
                    .toString()
                    .toUpperCase();
              case 4:
                return DateFormat('d MMM')
                    .format(_sleepRecord[4]["timestamp"])
                    .toString()
                    .toUpperCase();
              case 5:
                return DateFormat('d MMM')
                    .format(_sleepRecord[5]["timestamp"])
                    .toString()
                    .toUpperCase();
              case 6:
                return DateFormat('d MMM')
                    .format(_sleepRecord[6]["timestamp"])
                    .toString()
                    .toUpperCase();
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '18:00';
              case 4:
                return '22:00';
              case 8:
                return '02:00';
              case 12:
                return '06:00';
              case 16:
                return '10:00';
            }
            return '';
          },
          margin: 20,
          reservedSize: 40,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 2,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 6,
      maxY: 18,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(0, _sleepRecord[0]["bedTime"]),
        FlSpot(1, _sleepRecord[1]["bedTime"]),
        FlSpot(2, _sleepRecord[2]["bedTime"]),
        FlSpot(3, _sleepRecord[3]["bedTime"]),
        FlSpot(4, _sleepRecord[4]["bedTime"]),
        FlSpot(5, _sleepRecord[5]["bedTime"]),
        FlSpot(6, _sleepRecord[6]["bedTime"]),
      ],
      isCurved: true,
      colors: [
        Colors.deepPurple[700],
        Colors.deepPurple[400],
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(0, _sleepRecord[0]["wakeTime"]),
        FlSpot(1, _sleepRecord[1]["wakeTime"]),
        FlSpot(2, _sleepRecord[2]["wakeTime"]),
        FlSpot(3, _sleepRecord[3]["wakeTime"]),
        FlSpot(4, _sleepRecord[4]["wakeTime"]),
        FlSpot(5, _sleepRecord[5]["wakeTime"]),
        FlSpot(6, _sleepRecord[6]["wakeTime"]),
      ],
      isCurved: true,
      colors: [Colors.indigo[700], Colors.indigo[400]],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      // belowBarData: BarAreaData(show: true, colors: [
      //   Colors.white,
      // ]),
    );

    return [
      lineChartBarData1,
      lineChartBarData2,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _sleepRecord.length == 0 ||
              _sleepAverage == null ||
              _sleepMax == null
          ? LinearProgressIndicator(
              color: Colors.teal[500],
              minHeight: 0.1,
            )
          : Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _sleepAverage.toString(),
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "hrs",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Average",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text("Time in Bed",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 8,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: _sleepColors,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: _sleepAverage >= _sleepMax
                                  ? 1
                                  : _sleepAverage / _sleepMax,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _sleepColorsBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      child: Image.asset("assets/levitate.gif", height: 200),
                    ),

                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Note",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 20,
                                height: 8,
                                child: Text(""),
                              ),
                              SizedBox(width: 5),
                              Text(
                                  "Recommended: ${_sleepGoal.minGreen} to ${_sleepGoal.maxGreen} hrs")
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 20,
                                height: 8,
                                child: Text(""),
                              ),
                              SizedBox(width: 5),
                              Text(_sleepGoal.minLowerYellow ==
                                          _sleepGoal.maxLowerYellow &&
                                      _sleepGoal.minUpperYellow ==
                                          _sleepGoal.maxUpperYellow
                                  ? "May be appropriate: ${_sleepGoal.minLowerYellow} to ${_sleepGoal.minUpperYellow} hrs"
                                  : _sleepGoal.minUpperYellow ==
                                          _sleepGoal.maxUpperYellow
                                      ? "May be appropriate: ${_sleepGoal.minLowerYellow}-${_sleepGoal.minLowerYellow} to ${_sleepGoal.minUpperYellow} hrs"
                                      : _sleepGoal.minLowerYellow ==
                                              _sleepGoal.maxLowerYellow
                                          ? "May be appropriate: ${_sleepGoal.minLowerYellow} to ${_sleepGoal.minUpperYellow}-${_sleepGoal.maxUpperYellow} hrs"
                                          : "May be appropriate: ${_sleepGoal.minLowerYellow}-${_sleepGoal.maxLowerYellow} to ${_sleepGoal.minUpperYellow}-${_sleepGoal.maxUpperYellow} hrs")
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 20,
                                height: 8,
                                child: Text(""),
                              ),
                              SizedBox(width: 5),
                              Text("Not recommended: others")
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Text("Sleep Trend",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Graph
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          color: Colors.deepPurple[200],
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 6.0, bottom: 16, top: 16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: LineChart(
                                          sampleData1(),
                                          swapAnimationDuration:
                                              const Duration(milliseconds: 250),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
