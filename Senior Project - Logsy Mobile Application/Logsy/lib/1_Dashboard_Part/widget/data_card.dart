import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/1_Dashboard_Part/provider/analyticsMsg.dart';
import 'package:logsy_app/1_Dashboard_Part/screen/lifestyle_summary.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class DataCard extends StatelessWidget {
  final AnalyticsMsg analyticsMsg;
  final String type;
  final DateTime startDay;
  final DateTime endDay;
  final int show;
  final String text;

  DataCard(this.analyticsMsg, this.type, this.startDay, this.endDay, this.show,
      this.text);

  @override
  Widget build(BuildContext context) {
    void _notifyUsage() async{
      final user = Provider.of<UserProvider>(context, listen: false);
      await user.postUsage(user.loginUser, DateTime.now(), "MoreDetail");
    }
    Widget _mainMsg(String msg) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                '${msg}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    Widget _subMsg(String msg) {
      return Row(
        children: [
          Expanded(
            child: Text(
              msg,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    if (analyticsMsg.uid == 0) {
      return Padding(
        padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromRGBO(151, 112, 213, 1)),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: Text(
                        '${type.toUpperCase()}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(),
                    _mainMsg(
                        "Logsy can’t wait to tell your ${type.toLowerCase()} weekly performance! The analysis of this week will be shown here the upcoming Sunday."),
                    Spacer(),
                    _subMsg(
                        "Don’t forget to log your daily activity or else Logsy can’t analyse your performance :) "),
                    Spacer(),
                    ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      buttonColor: Color.fromRGBO(255, 255, 255, 0.7),
                      height: 30,
                      child: RaisedButton(
                        elevation: 5.0,
                        onPressed: (){
                          _notifyUsage();
                          int index;
                          if (type == "Eat") {
                            index = 0;
                          } else if (type == "Sleep") {
                            index = 1;
                          } else if (type == "Exercise") {
                            index = 2;
                          }
                          Navigator.of(context).pushNamed(
                              LifeStyleSummary.routeName,
                              arguments: index);
                          show == 1
                              ? showOverlayNotification((context) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: ListTile(
                                            title: Text(
                                              'Wonder about ${type}?',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(text),
                                            trailing: IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  OverlaySupportEntry.of(
                                                          context)
                                                      .dismiss();
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }, duration: Duration(milliseconds: 4000))
                              : Container();
                        },
                        child: Text(
                          "More Detail",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
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
      );
    } else {
      Color color;
      if (type == "Eat") {
        if (analyticsMsg.eatColor == "red") {
          color = Color.fromRGBO(209, 111, 111, 1);
        } else if (analyticsMsg.eatColor == "yellow") {
          color = Color.fromRGBO(229, 186, 78, 1);
        } else if (analyticsMsg.eatColor == "green") {
          color = Color.fromRGBO(94, 177, 150, 1);
        }
      } else if (type == "Sleep") {
        if (analyticsMsg.sleepColor == "red") {
          color = Color.fromRGBO(209, 111, 111, 1);
        } else if (analyticsMsg.sleepColor == "yellow") {
          color = Color.fromRGBO(229, 186, 78, 1);
        } else if (analyticsMsg.sleepColor == "green") {
          color = Color.fromRGBO(94, 177, 150, 1);
        }
      } else if (type == "Exercise") {
        if (analyticsMsg.exerciseColor == "red") {
          color = Color.fromRGBO(209, 111, 111, 1);
        } else if (analyticsMsg.exerciseColor == "yellow") {
          color = Color.fromRGBO(229, 186, 78, 1);
        } else if (analyticsMsg.exerciseColor == "green") {
          color = Color.fromRGBO(94, 177, 150, 1);
        }
      }

      return Padding(
        padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: color),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: Text(
                        '${type.toUpperCase()}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Text(
                        '${DateFormat("dd MMMM yyyy").format(startDay)} - ${DateFormat("dd MMMM yyyy").format(endDay)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(),
                    _mainMsg(
                      type == "Eat"
                          ? analyticsMsg.eat
                          : type == "Sleep"
                              ? analyticsMsg.sleep
                              : analyticsMsg.exercise,
                    ),
                    Spacer(),
                    _subMsg(type == "Eat"
                        ? analyticsMsg.eatEdu
                        : type == "Sleep"
                            ? analyticsMsg.sleepEdu
                            : analyticsMsg.exerciseEdu),
                    Spacer(),
                    ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      buttonColor: Color.fromRGBO(255, 255, 255, 0.7),
                      height: 30,
                      child: RaisedButton(
                        elevation: 5.0,
                        onPressed: () {
                          _notifyUsage();
                          int index;
                          if (type == "Eat") {
                            index = 0;
                          } else if (type == "Sleep") {
                            index = 1;
                          } else if (type == "Exercise") {
                            index = 2;
                          }
                          Navigator.of(context).pushNamed(
                              LifeStyleSummary.routeName,
                              arguments: index);
                          show == 1
                              ? showOverlayNotification((context) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: ListTile(
                                            title: Text(
                                              'Wonder about ${type}?',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(text),
                                            trailing: IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  OverlaySupportEntry.of(
                                                          context)
                                                      .dismiss();
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }, duration: Duration(milliseconds: 4000))
                              : Container();
                        },
                        child: Text(
                          "More Detail",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
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
      );
    }
  }
}
