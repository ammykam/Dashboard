import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class FriendReItem extends StatefulWidget {
  final int uid;
  final String name;
  final String des;
  final String imgUrl;

  FriendReItem(this.uid, this.name, this.des, this.imgUrl);

  @override
  _FriendReItemState createState() => _FriendReItemState();
}

class _FriendReItemState extends State<FriendReItem> {
  String frdRequest;

  Future<void> _deleteFriend() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.deleteFriendRequest(user.loginUser, widget.uid);
  }

  Future<void> _acceptFriend() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.acceptFriendRequest(user.loginUser, widget.uid);
  }

  @override
  void didUpdateWidget(covariant FriendReItem oldWidget) {
    frdRequest = "";
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return frdRequest == "Delete" || frdRequest == "Accept"
        ? Container()
        : ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal[200],
              backgroundImage: AssetImage('assets/avatar/${widget.imgUrl}'),
            ),
            title: Text(
              "${widget.name}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            subtitle: Text(
              "${widget.des}",
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Accept Button
                ButtonTheme(
                  height: MediaQuery.of(context).size.height * 0.04,
                  minWidth: 5,
                  child: FlatButton(
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
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  Text('Continue to accept friend request',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  Text(widget.name,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                  SizedBox(height: 20),
                                  ButtonTheme(
                                    minWidth:
                                        MediaQuery.of(context).size.width * 0.4,
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
                                        _acceptFriend().then(
                                          (value) => setState(
                                            () {
                                              frdRequest = "Accept";
                                            },
                                          ),
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
                    child: Text(
                      "ACCEPT",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                //Delete Button
                ButtonTheme(
                  height: MediaQuery.of(context).size.height * 0.04,
                  minWidth: 10,
                  child: FlatButton(
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
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  Text('Continue to delete friend request',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  Text(widget.name,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                  SizedBox(height: 20),
                                  ButtonTheme(
                                    minWidth:
                                        MediaQuery.of(context).size.width * 0.4,
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
                                            frdRequest = "Delete";
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
                    child: Text(
                      "DELETE",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    color: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
