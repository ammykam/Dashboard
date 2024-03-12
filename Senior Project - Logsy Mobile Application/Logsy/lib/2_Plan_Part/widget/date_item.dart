import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateItem extends StatefulWidget {

  @override
  _DateItemState createState() => _DateItemState();
}

class _DateItemState extends State<DateItem> {
  int _selected = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //day 1
          GestureDetector(
            onTap: () {
              setState(() {
                _selected = DateTime.now().subtract(Duration(days: 3)).day;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE')
                      .format(DateTime.now().subtract(Duration(days: 3)))
                      .toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                _selected == DateTime.now().subtract(Duration(days: 3)).day
                    ? Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 13.0,
                          ),
                          Text(
                            DateFormat('dd').format(
                                DateTime.now().subtract(Duration(days: 3))),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.teal[200]),
                          ),
                        ],
                      )
                    : Text(
                        DateFormat('dd')
                            .format(DateTime.now().subtract(Duration(days: 3))),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      ),
              ],
            ),
          ),
          //day 2
          GestureDetector(
            onTap: () {
              setState(() {
                _selected = DateTime.now().subtract(Duration(days: 2)).day;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE')
                      .format(DateTime.now().subtract(Duration(days: 2)))
                      .toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                _selected == DateTime.now().subtract(Duration(days: 2)).day
                    ? Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 13.0,
                          ),
                          Text(
                            DateFormat('dd').format(
                                DateTime.now().subtract(Duration(days: 2))),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.teal[200]),
                          ),
                        ],
                      )
                    : Text(
                        DateFormat('dd')
                            .format(DateTime.now().subtract(Duration(days: 2))),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      )
              ],
            ),
          ),
          //day 3
          GestureDetector(
            onTap: () {
              setState(() {
                _selected = DateTime.now().subtract(Duration(days: 1)).day;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE')
                      .format(DateTime.now().subtract(Duration(days: 1)))
                      .toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                _selected == DateTime.now().subtract(Duration(days: 1)).day
                    ? Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 13.0,
                          ),
                          Text(
                            DateFormat('dd').format(
                                DateTime.now().subtract(Duration(days: 1))),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.teal[200]),
                          ),
                        ],
                      )
                    : Text(
                        DateFormat('dd')
                            .format(DateTime.now().subtract(Duration(days: 1))),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      )
              ],
            ),
          ),
          //day 4
          GestureDetector(
            onTap: () {
              setState(() {
                _selected = DateTime.now().day;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE').format(DateTime.now()).toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                _selected == DateTime.now().day
                    ? Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 13.0,
                          ),
                          Text(
                            DateFormat('dd').format(DateTime.now()),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.teal[200]),
                          ),
                        ],
                      )
                    : Text(
                        DateFormat('dd').format(DateTime.now()),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      )
              ],
            ),
          ),
          //day 5
          GestureDetector(
            onTap: () {
              setState(() {
                _selected = DateTime.now().add(Duration(days: 1)).day;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE')
                      .format(DateTime.now().add(Duration(days: 1)))
                      .toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                _selected == DateTime.now().add(Duration(days: 1)).day
                    ? Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 13.0,
                          ),
                          Text(
                            DateFormat('dd')
                                .format(DateTime.now().add(Duration(days: 1))),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.teal[200]),
                          ),
                        ],
                      )
                    : Text(
                        DateFormat('dd')
                            .format(DateTime.now().add(Duration(days: 1))),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      )
              ],
            ),
          ),
          //day 6
          GestureDetector(
            onTap: () {
              setState(() {
                _selected = DateTime.now().add(Duration(days: 2)).day;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE')
                      .format(DateTime.now().add(Duration(days: 2)))
                      .toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                _selected == DateTime.now().add(Duration(days: 2)).day
                    ? Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 13.0,
                          ),
                          Text(
                            DateFormat('dd')
                                .format(DateTime.now().add(Duration(days: 2))),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.teal[200]),
                          ),
                        ],
                      )
                    : Text(
                        DateFormat('dd')
                            .format(DateTime.now().add(Duration(days: 2))),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      )
              ],
            ),
          ),
          //day 7
          GestureDetector(
            onTap: () {
              setState(() {
                _selected = DateTime.now().add(Duration(days: 3)).day;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE')
                      .format(DateTime.now().add(Duration(days: 3)))
                      .toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.white),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                _selected == DateTime.now().add(Duration(days: 3)).day
                    ? Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 13.0,
                          ),
                          Text(
                            DateFormat('dd')
                                .format(DateTime.now().add(Duration(days: 3))),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: Colors.teal[200]),
                          ),
                        ],
                      )
                    : Text(
                        DateFormat('dd')
                            .format(DateTime.now().add(Duration(days: 3))),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
