import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/1_Dashboard_Part/widget/eat_life.dart';
import 'package:logsy_app/1_Dashboard_Part/widget/exercise_life.dart';
import 'package:logsy_app/1_Dashboard_Part/widget/sleep_life.dart';
import 'package:table_calendar/table_calendar.dart';

class LifeStyleSummary extends StatefulWidget {
  static const routeName = "/life-style";

  @override
  _LifeStyleSummaryState createState() => _LifeStyleSummaryState();
}

class _LifeStyleSummaryState extends State<LifeStyleSummary> {
  var _calendarController;
  var dateSelect = DateTime.now().subtract(Duration(days:7));
  
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

  @override
  Widget build(BuildContext context) {
    int index = ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
      initialIndex: index,
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: [
                  IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
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
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: TableCalendar(
                                  endDay: DateTime.now(),
                                  calendarController: _calendarController,
                                  initialSelectedDay: dateSelect,
                                  onDaySelected: (date, _, __) {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      dateSelect = date;
                                    });
                                  },
                                ),
                              );
                            });
                      }),
                ],
                expandedHeight: 150.0,
                floating: false,
                pinned: true,
                title: Text(
                  "LIFESTYLE",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.amber,
                flexibleSpace: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.amber[100],
                        Colors.teal[400],
                      ],
                    ),
                  ),
                  child: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.teal[400],
                            Colors.amber[100],
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.12,
                            left: 20,
                            right: 20),
                        child: Column(
                          children: [
                            Text(
                              DateFormat('EEEE, dd MMMM y').format(dateSelect),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    dateSelect.weekday == 7
                                        ? DateFormat('dd MMMM y')
                                            .format(dateSelect)
                                        : DateFormat('dd MMMM y').format(
                                            dateSelect.subtract(
                                              Duration(
                                                  days: dateSelect.weekday),
                                            ),
                                          ),
                                    style: TextStyle(color: Colors.white)),
                                Text(" - ",
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                    dateSelect.weekday == 7
                                        ? DateFormat('dd MMMM y').format(
                                            dateSelect.add(Duration(days: 6)))
                                        : DateFormat('dd MMMM y').format(
                                            dateSelect.subtract(
                                              Duration(
                                                  days: dateSelect.weekday - 6),
                                            ),
                                          ),
                                    style: TextStyle(color: Colors.white)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(1),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TabBar(
                      labelColor: Colors.black,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      unselectedLabelColor: Colors.black45,
                      indicatorColor: Colors.teal,
                      indicatorWeight: 3.0,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(text: 'Eat'),
                        Tab(text: 'Sleep'),
                        Tab(text: 'Exercise'),
                      ],
                    ),
                  ]),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              EatLife(dateSelect),
              SleepLife(dateSelect),
              ExerciseLife(dateSelect),
            ],
          ),
        ),
      ),
    );
  }
}
