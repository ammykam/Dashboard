import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/badges.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/edit_profile_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/view_friend_screen.dart';
import 'package:provider/provider.dart';

enum status { Owner, Blank, Requested, Friend, Wait }

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  var people;
  int numFriend;
  var frdStatus;
  int uid;
  User person;
  List<String> _interest = [];
  List<Badge> _badge = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      people = ModalRoute.of(context).settings.arguments as List<dynamic>;
      setState(() {
        uid = people[0];
      });

      //status
      if (await people[1] == "pending") {
        frdStatus = status.Requested;
      } else if (await people[1] == "blank") {
        frdStatus = status.Blank;
      } else if (await people[1] == "Owner") {
        frdStatus = status.Owner;
      } else if (await people[1] == "friend") {
        frdStatus = status.Friend;
      } else if (await people[1] == "request") {
        frdStatus = status.Wait;
      }
      final user = Provider.of<UserProvider>(context, listen: false);
      final badge = Provider.of<BadgeProvider>(context, listen: false);

      await badge.getAllBadge(uid).then((value) {
        _badge = value;
      });
      await user.getUser(uid).then(
        (value) {
          _isLoading = false;
          person = value;
        },
      );
      await user.getInterest(uid).then((value) {
        _interest = value;
      });
      await user.userFriendNum(uid).then((value) {
        setState(() {
          numFriend = value;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void fetchAndSetData() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.getUser(uid).then(
      (value) {
        _isLoading = false;
        person = value as User;
      },
    );
    await user.getInterest(uid).then((value) {
      _interest = value;
    });
    await user.userFriend(uid).then((value) {
      setState(() {
        numFriend = value.length;
      });
    });
  }

  Future<void> _addFriend() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.sendFriendRequest(user.loginUser, uid);
  }

  Future<void> _acceptFriend() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.acceptFriendRequest(user.loginUser, uid);
  }

  Future<void> _deleteFriend() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.deleteFriendRequest(user.loginUser, uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          person == null ? '' : '${person.firstName} ${person.lastName}',
          style: TextStyle(
              fontSize: 18,
              color: Colors.teal[500],
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          // borderRadius:
                          //     BorderRadius.vertical(bottom: Radius.circular(30)),

                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomCenter,
                            colors: [Colors.teal[300], Colors.amber[100]],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 15,
                            left: 15,
                            bottom: 15,
                            top: MediaQuery.of(context).size.height * 0.07),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        person == null
                                            ? ''
                                            : '${person.firstName} ${person.lastName}',
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Bangkok, TH",
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //check if the current user is owner to show frd list || buttons
                                frdStatus != status.Owner
                                    //this is not owner --> so this is friend
                                    ? Column(
                                        children: [
                                          //check if that friend requested already or not
                                          frdStatus == status.Requested
                                              ? Row(
                                                  children: [
                                                    ButtonTheme(
                                                      minWidth: 150,
                                                      height: 30,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: FlatButton(
                                                        color: Colors.amber,
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false, // user must tap button!
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            30),
                                                                  ),
                                                                ),
                                                                content:
                                                                    Container(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
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
                                                                          "assets/Popup/tongue-2.png",
                                                                          width:
                                                                              90,
                                                                          height:
                                                                              90),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          "Yess!!",
                                                                          style: TextStyle(
                                                                              color: Colors.green,
                                                                              fontSize: 25,
                                                                              fontWeight: FontWeight.bold)),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          'The face was overjoyed!',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12)),
                                                                      Text(
                                                                          'Continue to accept friend request',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12)),
                                                                      Text(
                                                                          '${person.firstName} ${person.lastName}',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12)),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      ButtonTheme(
                                                                        minWidth:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.4,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            RaisedButton(
                                                                          child: Text(
                                                                              'Continue',
                                                                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                                                                          color:
                                                                              Colors.green,
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              _acceptFriend().then((value) {
                                                                                setState(() {
                                                                                  frdStatus = status.Friend;
                                                                                });
                                                                              });
                                                                            });
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
                                                        },
                                                        child: Text(
                                                          "Accept Request",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          frdStatus == status.Blank
                                              ? Row(
                                                  children: [
                                                    ButtonTheme(
                                                      minWidth: 150,
                                                      height: 30,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: FlatButton(
                                                        color: Colors.teal,
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false, // user must tap button!
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            30),
                                                                  ),
                                                                ),
                                                                content:
                                                                    Container(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
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
                                                                          "assets/Popup/happy-1.png",
                                                                          width:
                                                                              90,
                                                                          height:
                                                                              90),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          "Yayy!!",
                                                                          style: TextStyle(
                                                                              color: Colors.green,
                                                                              fontSize: 25,
                                                                              fontWeight: FontWeight.bold)),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          'The face is very happy!',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12)),
                                                                      Text(
                                                                          'Continue to send friend request to',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12)),
                                                                      Text(
                                                                          '${person.firstName} ${person.lastName}',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold)),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      ButtonTheme(
                                                                        minWidth:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.4,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            RaisedButton(
                                                                          child: Text(
                                                                              'Continue',
                                                                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                                                                          color:
                                                                              Colors.green,
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              _addFriend().then((_) {
                                                                                setState(() {
                                                                                  frdStatus = status.Wait;
                                                                                });
                                                                              });
                                                                            });
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
                                                        },
                                                        child: Text(
                                                          "Add Friend",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          frdStatus == status.Wait
                                              ? Row(
                                                  children: [
                                                    ButtonTheme(
                                                      minWidth: 150,
                                                      height: 30,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: OutlineButton(
                                                        borderSide: BorderSide(
                                                            color: Colors.teal),
                                                        color: Colors.teal,
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false, // user must tap button!
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            30),
                                                                  ),
                                                                ),
                                                                content:
                                                                    Container(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
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
                                                                          "assets/Popup/surprised-2.png",
                                                                          width:
                                                                              90,
                                                                          height:
                                                                              90),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          "Nooo!!",
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 25,
                                                                              fontWeight: FontWeight.bold)),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          'The face is sad!',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12)),
                                                                      Text(
                                                                          'Continue to cancel friend request',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12)),
                                                                      Text(
                                                                          '${person.firstName} ${person.lastName}',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12)),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      ButtonTheme(
                                                                        minWidth:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.4,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            RaisedButton(
                                                                          child: Text(
                                                                              'Continue',
                                                                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                                                                          color:
                                                                              Colors.red,
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              _deleteFriend().then(
                                                                                (value) => setState(() {
                                                                                  frdStatus = status.Blank;
                                                                                }),
                                                                              );
                                                                            });
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
                                                        },
                                                        child: Text(
                                                          "Requested",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.teal),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          frdStatus == status.Friend
                                              ? Row(
                                                  children: [
                                                    ButtonTheme(
                                                      minWidth: 150,
                                                      height: 30,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: OutlineButton(
                                                        borderSide: BorderSide(
                                                            color: Colors.teal),
                                                        color: Colors.teal,
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false, // user must tap button!
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            30),
                                                                  ),
                                                                ),
                                                                content:
                                                                    Container(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
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
                                                                          "assets/Popup/sad.png",
                                                                          width:
                                                                              90,
                                                                          height:
                                                                              90),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          "Nahh!!",
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 25,
                                                                              fontWeight: FontWeight.bold)),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          'The face is sad!',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12)),
                                                                      Text(
                                                                          'Continue to remove friend request',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 12)),
                                                                      Text(
                                                                          '${person.firstName} ${person.lastName}',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12)),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      ButtonTheme(
                                                                        minWidth:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.4,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            RaisedButton(
                                                                          child: Text(
                                                                              'Continue',
                                                                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                                                                          color:
                                                                              Colors.red,
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              _deleteFriend().then(
                                                                                (value) => setState(() {
                                                                                  frdStatus = status.Blank;
                                                                                }),
                                                                              );
                                                                            });
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
                                                        },
                                                        child: Text(
                                                          "Friend",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.teal),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      )
                                    //show list of friends
                                    : Row(
                                        children: [
                                          ButtonTheme(
                                            minWidth: 150,
                                            height: 30,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: RaisedButton(
                                              elevation: 0.0,
                                              color: Colors.teal,
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushNamed(
                                                        EditProfileScreen
                                                            .routeName,
                                                        arguments: person.uid)
                                                    .then((_) {
                                                  fetchAndSetData();
                                                });
                                              },
                                              child: Text(
                                                "Edit Profile",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          ButtonTheme(
                                            minWidth: 150,
                                            height: 30,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: OutlineButton(
                                              borderSide: BorderSide(
                                                color: Colors.teal[200],
                                              ),
                                              color: Colors.teal,
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushNamed(
                                                        ViewFriendScreen
                                                            .routeName,
                                                        arguments: uid)
                                                    .then((value) =>
                                                        fetchAndSetData());
                                              },
                                              child: Text(
                                                "$numFriend Friends",
                                                style: TextStyle(
                                                    color: Colors.teal),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              child: Text(
                                person == null ? "" : person.des,
                                style: TextStyle(
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.teal[50],
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "INTERESTS",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                alignment: WrapAlignment.start,
                                direction: Axis.horizontal,
                                children: _interest
                                    .map(
                                      (e) => Container(
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.teal[200],
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(6),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              color: Colors.teal,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 2,
                        color: Colors.teal[400],
                        thickness: 2,
                      ),
                      Container(
                        color: Colors.teal[50],
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "BADGES",
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                alignment: WrapAlignment.start,
                                direction: Axis.horizontal,
                                children: _badge
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                ),
                                                content: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Image.asset(
                                                            "assets/Badge/${e.imgUrl}",
                                                            height: 100,
                                                            width: 100),
                                                        Text(
                                                          e.name,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          "${e.des}",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 15,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          margin: EdgeInsets.only(
                                              bottom: 0, left: 5, right: 5),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(_badge == null
                                                    ? "https://www.porcelaingres.com/img/collezioni/JUST-GREY/big/just_grey_light_grey.jpg"
                                                    : "assets/Badge/${e.imgUrl}"),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 2,
                        color: Colors.teal[400],
                        thickness: 2,
                      ),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.width * 0.35,
                      margin: EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/avatar/${person.imgUrl}"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
