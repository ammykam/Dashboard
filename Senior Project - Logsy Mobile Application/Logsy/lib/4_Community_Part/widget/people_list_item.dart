import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:provider/provider.dart';

class PeopleListItem extends StatefulWidget {
  final String name;
  final int uid;
  final String imgUrl;
  final int currentUid;

  PeopleListItem(this.name, this.uid, this.imgUrl, this.currentUid);

  @override
  _PeopleListItemState createState() => _PeopleListItemState();
}

class _PeopleListItemState extends State<PeopleListItem> {
  var user;
  String status = "";
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      user = Provider.of<UserProvider>(context, listen: false);
      status = await user.userFriendStatus(widget.currentUid, widget.uid);
    }
    _isInit = false;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // @override
  // void didUpdateWidget(covariant PeopleListItem oldWidget) {
  //   user = Provider.of<UserProvider>(context, listen: false);
  //   status = user.userFriendStatus(widget.currentUid, widget.uid);
  //   setState(() {
      
  //   });
  //   super.didUpdateWidget(oldWidget);
  // }

  void _reItem() async {
    user = Provider.of<UserProvider>(context, listen: false);
    status = await user.userFriendStatus(widget.currentUid, widget.uid);
    setState(() {});
  }

  Future<void> _addFriend() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.sendFriendRequest(user.loginUser, widget.uid);
  }

  Future<void> _acceptFriend() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.acceptFriendRequest(user.loginUser, widget.uid);
  }

  Future<void> _deleteFriend() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.deleteFriendRequest(user.loginUser, widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return status == ""
        ? Container()
        : ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName,
                  arguments: [
                    widget.uid,
                    user.userFriendStatus(widget.currentUid, widget.uid)
                  ]).then((_) {
                _reItem();
              });
            },
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar/${widget.imgUrl}'),
              backgroundColor: Colors.teal[300],
            ),
            title: Text(
              widget.name,
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Bangkok, TH",
              style: TextStyle(color: Colors.teal[300], fontSize: 13),
            ),
            trailing: status == "blank"
                ? ButtonTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minWidth: MediaQuery.of(context).size.width * 0.25,
                    height: 30,
                    child: FlatButton(
                      color: Colors.teal[500],
                      child: Text("ADD",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button!
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Icon(Icons.close)),
                                      ],
                                    ),
                                    Image.asset("assets/Popup/happy-1.png",
                                        width: 90, height: 90),
                                    SizedBox(height: 20),
                                    Text("Yayy!!",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                                    Text('The face is very happy!',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                    Text('Continue to send friend request to',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                    Text(widget.name,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                                    ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: RaisedButton(
                                        child: Text('Continue',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        color: Colors.green,
                                        onPressed: () {
                                          _addFriend().then((_) {
                                            setState(() {
                                              status = "request";
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
                    ))
                : status == "friend"
                    ? ButtonTheme(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minWidth: MediaQuery.of(context).size.width * 0.25,
                        height: 30,
                        child: OutlineButton(
                          borderSide:
                              BorderSide(width: 1.0, color: Colors.transparent),
                          child: Text("FRIEND",
                              style:
                                  TextStyle(color: Colors.teal, fontSize: 12)),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ProfileScreen.routeName, arguments: [
                              widget.uid,
                              user.userFriendStatus(
                                  widget.currentUid, widget.uid)
                            ]).then((_) {
                              _reItem();
                            });
                          },
                        ))
                    : status == "pending"
                        ? ButtonTheme(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minWidth: MediaQuery.of(context).size.width * 0.25,
                            height: 30,
                            child: FlatButton(
                              color: Colors.amber[300],
                              child: Text("ACCEPT",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Icon(Icons.close)),
                                              ],
                                            ),
                                            Image.asset(
                                                "assets/Popup/tongue-2.png",
                                                width: 90,
                                                height: 90),
                                            SizedBox(height: 20),
                                            Text("Yess!!",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 20),
                                            Text('The face was overjoyed!',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12)),
                                            Text(
                                                'Continue to accept friend request',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12)),
                                            Text(widget.name,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
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
                                                  _acceptFriend().then((value) {
                                                    setState(() {
                                                      status = "friend";
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
                            ))
                        : status == "request"
                            ? ButtonTheme(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.25,
                                height: 30,
                                child: FlatButton(
                                  color: Colors.teal[100],
                                  child: Text("PENDING",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
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
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            Icon(Icons.close)),
                                                  ],
                                                ),
                                                Image.asset(
                                                    "assets/Popup/surprised-2.png",
                                                    width: 90,
                                                    height: 90),
                                                SizedBox(height: 20),
                                                Text("Nooo!!",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 20),
                                                Text('The face was shocked!',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12)),
                                                Text(
                                                    'Continue to cancel your friend request',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12)),
                                                Text(widget.name,
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
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: RaisedButton(
                                                    child: Text('Continue',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      _deleteFriend()
                                                          .then((value) {
                                                        setState(() {
                                                          status = "blank";
                                                        });
                                                      });
                                                      Navigator.of(context)
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
                                ))
                            : SizedBox(width: 1),
          );
  }
}
