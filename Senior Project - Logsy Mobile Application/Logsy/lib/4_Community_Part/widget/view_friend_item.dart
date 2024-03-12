import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class ViewFriendItem extends StatefulWidget {
  final int uid;
  final Future<String> friendStatus;

  ViewFriendItem(this.uid, this.friendStatus);

  @override
  _ViewFriendItemState createState() => _ViewFriendItemState();
}

class _ViewFriendItemState extends State<ViewFriendItem> {
  bool _isInit = true;
  User person;
  String status;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final user = Provider.of<UserProvider>(context, listen: false);
      await user.getUser(widget.uid).then((value) {
        person = value;
      });
      await widget.friendStatus.then((value) {
        setState(() {
          status = value;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ViewFriendItem oldWidget) {
    final user = Provider.of<UserProvider>(context);
    user.getUser(widget.uid).then((value) {
      person = value;
    });
    widget.friendStatus.then((value) {
      status = value;
    });
    super.didUpdateWidget(oldWidget);
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

  Widget _buttonAdd() {
    return ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minWidth: MediaQuery.of(context).size.width * 0.25,
        height: 30,
        child: FlatButton(
          color: Colors.teal[500],
          child:
              Text("ADD", style: TextStyle(color: Colors.white, fontSize: 12)),
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
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Continue to send friend request to',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('${person.firstName} ${person.lastName}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.4,
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
        ));
  }

  Widget _buttonFriend() {
    return ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minWidth: MediaQuery.of(context).size.width * 0.25,
        height: 30,
        child: OutlineButton(
          borderSide: BorderSide(width: 1.0, color: Colors.transparent),
          child: Text("FRIEND",
              style: TextStyle(color: Colors.teal, fontSize: 12)),
          onPressed: () {},
        ));
  }

  Widget _buttonPending() {
    return ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minWidth: MediaQuery.of(context).size.width * 0.25,
        height: 30,
        child: FlatButton(
          color: Colors.amber[300],
          child: Text("ACCEPT",
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
                        Image.asset("assets/Popup/tongue-2.png",
                            width: 90, height: 90),
                        SizedBox(height: 20),
                        Text("Yess!!",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        Text('The face was overjoyed!',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Continue to accept friend request',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('${person.firstName} ${person.lastName}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        SizedBox(height: 20),
                        ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.4,
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
                              _acceptFriend().then((value) => setState(() {
                                    setState(() {
                                      status = "friend";
                                    });
                                  }));
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
        ));
  }

  Widget _buttonRequest() {
    return ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minWidth: MediaQuery.of(context).size.width * 0.25,
        height: 30,
        child: FlatButton(
          color: Colors.teal[100],
          child: Text("PENDING",
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
                        Image.asset("assets/Popup/surprised-2.png",
                            width: 90, height: 90),
                        SizedBox(height: 20),
                        Text("Nooo!!",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        Text('The face was shocked!',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Continue to cancel your friend request',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('${person.firstName} ${person.lastName}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        SizedBox(height: 20),
                        ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: RaisedButton(
                            child: Text('Continue',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            color: Colors.red,
                            onPressed: () {
                              _deleteFriend().then(
                                (value) => setState(() {
                                  status = "blank";
                                }),
                              );
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return person == null
        ? LinearProgressIndicator(
            minHeight: 0.1, backgroundColor: Colors.teal[500])
        : ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal[300],
              backgroundImage: AssetImage('assets/avatar/${person.imgUrl}'),
            ),
            title: Text(
              "${person.firstName} ${person.lastName}",
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              person.des,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: Colors.teal),
            ),
            trailing: status == "blank"
                ? _buttonAdd()
                : status == "friend"
                    ? _buttonFriend()
                    : status == "pending"
                        ? _buttonPending()
                        : status == "request"
                            ? _buttonRequest()
                            : status == "Owner"
                                ? SizedBox(width: 1)
                                : SizedBox(width: 1),
          );
  }
}
