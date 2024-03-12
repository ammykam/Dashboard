import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/4_Community_Part/provider/challenge.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class ChallengePostItem extends StatefulWidget {
  final Challenge challenge;
  final String type;
  final Future<String> status;
  final Function update;

  ChallengePostItem(this.challenge, this.type, this.status, this.update);

  @override
  _ChallengePostItemState createState() => _ChallengePostItemState();
}

class _ChallengePostItemState extends State<ChallengePostItem> {
  Color color1;
  Color color2;
  Color textColor;
  String image;
  User _user;
  List<Map<String, dynamic>> _joinUser;
  bool _isInit = true;
  //status
  bool _isJoined = false;
  bool _isDone = false;
  bool _isUpcoming = false;
  bool _isExpired = false;
  bool _isShowed = false;
  String status = "";

  @override
  void didChangeDependencies() async {
    if (widget.challenge.theme == 1) {
      color1 = Colors.deepPurple[200];
      color2 = Colors.deepPurple[300];
      image = "assets/cha-1.png";
    } else if (widget.challenge.theme == 2) {
      color1 = Colors.indigo[200];
      color2 = Colors.indigo[300];
      image = "assets/cha-2.png";
    } else if (widget.challenge.theme == 3) {
      color1 = Colors.lightGreen[400];
      color2 = Colors.lightGreen[500];
      image = "assets/cha-3.png";
    } else if (widget.challenge.theme == 4) {
      color1 = Colors.brown[300];
      color2 = Colors.brown[400];
      image = "assets/cha-4.png";
    } else if (widget.challenge.theme == 5) {
      color1 = Colors.teal[200];
      color2 = Colors.teal[300];
      image = "assets/cha-5.png";
    } else if (widget.challenge.theme == 6) {
      color1 = Colors.red[200];
      color2 = Colors.red[300];
      image = "assets/cha-6.png";
    }

    //check is joined, is done

    if (_isInit) {
      final user = Provider.of<UserProvider>(context, listen: false);
      final challenge = Provider.of<ChallengeProvider>(context, listen: false);

      List<dynamic> _joinedList = [];
      await challenge.getJoinListChallenge(widget.challenge.cid).then((value) {
        _joinedList = value;
      });
      await user.getUserListInfo(_joinedList).then((value) {
        _joinUser = value;
      });

      await user.getUser(widget.challenge.user_uidCreator).then((value) {
        _user = value;
      });

      status = await widget.status;

      if (widget.type == "upcoming") {
        _isUpcoming = true;
      } else if (widget.type == "current") {
        if (status == "blank") {
          _isJoined = false;
        } else {
          if (status == "completed") {
            _isJoined = true;
            _isDone = true;
            textColor = Colors.black;
            color1 = Colors.white;
            color2 = Colors.white;
          } else {
            _isJoined = true;
            textColor = Colors.white;
          }
        }
      } else if (widget.type == "expired") {
        _isExpired = true;
        if (status == "completed") {
          _isDone = true;
          color1 = Colors.white;
          color2 = Colors.white;
        }
      }
      setState(() {});
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _challengeJoin() async {
    final challenge = Provider.of<ChallengeProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await challenge.joinChallenge(
        user.loginUser, widget.challenge.cid, DateTime.now(), "incomplete");
  }

  Future<void> _challengeComplete() async {
    final challenge = Provider.of<ChallengeProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await challenge.completeChallenge(user.loginUser, widget.challenge.cid);
  }

  Future<void> _reItem() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    final challenge = Provider.of<ChallengeProvider>(context, listen: false);

    List<dynamic> _joinedList = [];
    await challenge.getJoinListChallenge(widget.challenge.cid).then((value) {
      _joinedList = value;
    });
    await user.getUserListInfo(_joinedList).then((value) {
      _joinUser = value;
    });

    await user.getUser(widget.challenge.user_uidCreator).then((value) {
      _user = value;
    });

    status = await widget.status;

    if (widget.type == "upcoming") {
      _isUpcoming = true;
    } else if (widget.type == "current") {
      if (status == "blank") {
        _isJoined = false;
      } else {
        if (status == "completed") {
          _isJoined = true;
          _isDone = true;
          textColor = Colors.black;
          color1 = Colors.white;
          color2 = Colors.white;
        } else {
          _isJoined = true;
          textColor = Colors.white;
        }
      }
    } else if (widget.type == "expired") {
      _isExpired = true;
      if (status == "completed") {
        _isDone = true;
        color1 = Colors.white;
        color2 = Colors.white;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return status == ""
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [color1, color2],
                  ),
                  border: _isDone
                      ? Border.all(color: Colors.black, width: 2)
                      : Border.all(width: 0, color: Colors.transparent)),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(image, width: 80, height: 130),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.challenge.name,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              _user == null
                                  ? "Challenge By"
                                  : 'Challenge By ${_user.firstName} ${_user.lastName}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.category,
                                    color: textColor, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  widget.challenge.category,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.leaderboard,
                                    color: textColor, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  widget.challenge.level,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: textColor, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  '${DateFormat('d MMM y').format(widget.challenge.startD).toString()} - ${DateFormat('d MMM y').format(widget.challenge.endD).toString()}',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.challenge.des,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 10),
                  _isUpcoming
                      ? Center(
                          child: Text(
                            "Upcoming",
                            style: TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : _isExpired
                          ? _isDone
                              ? Center(
                                  child: Text(
                                    "Done",
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    "Expired",
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                          : _isJoined
                              ? _isDone
                                  ? Center(
                                      child: Text(
                                        "Done",
                                        style: TextStyle(
                                            color: textColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      buttonColor: Colors.black38,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: RaisedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
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
                                                                  Icons.close)),
                                                        ],
                                                      ),
                                                      Image.asset(
                                                          "assets/Popup/finish.png",
                                                          width: 90,
                                                          height: 90),
                                                      SizedBox(height: 20),
                                                      Text("Gooo!!",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(height: 20),
                                                      Text(
                                                          'The finish line is waiting!',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12)),
                                                      Text(
                                                          'Continue to complete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12)),
                                                      Text(
                                                          widget.challenge.name,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12)),
                                                      SizedBox(height: 20),
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
                                                                  .circular(20),
                                                        ),
                                                        child: RaisedButton(
                                                          child: Text(
                                                              'Continue',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          color: Colors.green,
                                                          onPressed: () {
                                                            _challengeComplete()
                                                                .then((value) {
                                                              setState(() {
                                                                _isDone = true;
                                                                textColor =
                                                                    Colors
                                                                        .black;
                                                                color1 = Colors
                                                                    .white;
                                                                color2 = Colors
                                                                    .white;
                                                                widget.update();
                                                                _reItem();
                                                              });
                                                            });
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
                                        },
                                        child: Text(
                                          "Complete",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))
                              : ButtonTheme(
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  buttonColor: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: RaisedButton(
                                    onPressed: () {
                                      showDialog(
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Icon(
                                                              Icons.close)),
                                                    ],
                                                  ),
                                                  Image.asset(
                                                      "assets/Popup/start-line.png",
                                                      width: 90,
                                                      height: 90),
                                                  SizedBox(height: 20),
                                                  Text("Gooo!!",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 20),
                                                  Text(
                                                      'The race is about to start!',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12)),
                                                  Text('Continue to join',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12)),
                                                  Text(widget.challenge.name,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12)),
                                                  SizedBox(height: 20),
                                                  ButtonTheme(
                                                    minWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: RaisedButton(
                                                      child: Text('Continue',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      color: Colors.green,
                                                      onPressed: () {
                                                        _challengeJoin()
                                                            .then((value) {
                                                          _isJoined = true;
                                                          widget.update();
                                                          _reItem();
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
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
                                    },
                                    child: Text(
                                      "Join",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isShowed = !_isShowed;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[700],
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Join List',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isShowed = !_isShowed;
                                  });
                                },
                                child: _isShowed
                                    ? Icon(Icons.expand_more,
                                        color: Colors.white, size: 20)
                                    : Icon(Icons.expand_less,
                                        color: Colors.white, size: 20))
                          ],
                        ),
                      ),
                    ),
                  ),
                  _isShowed
                      ? Column(
                          children: _joinUser
                              .map(
                                (e) => Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                          'assets/avatar/${e["imgUrl"]}'),
                                    ),
                                    title: Text(
                                      e["name"],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: e["isCompleted"] == "completed"
                                        ? Text(
                                            "Completed",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.teal[300]),
                                          )
                                        : DateTime.now()
                                                .isAfter(widget.challenge.endD)
                                            ? Text(
                                                "Expired",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              )
                                            : Text(
                                                "In Process",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : Container(),
                ],
              ),
            ),
          );
  }
}
