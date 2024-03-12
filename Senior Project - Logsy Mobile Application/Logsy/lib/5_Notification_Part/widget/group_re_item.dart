import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class GroupReItem extends StatefulWidget {
  final String name;
  final String desc;
  final int gid;
  final String imgUrl;

  GroupReItem(this.name, this.desc, this.gid, this.imgUrl);

  @override
  _GroupReItemState createState() => _GroupReItemState();
}

class _GroupReItemState extends State<GroupReItem> {
  String grpRequest;

  Future<void> _groupAccept() async {
    final group = await Provider.of<GroupProvider>(context, listen: false);
    final user = await Provider.of<UserProvider>(context, listen: false);
    await group.updateStatus(user.loginUser, widget.gid, "accept");
  }

  Future<void> _groupDelete() async {
    final group = await Provider.of<GroupProvider>(context, listen: false);
    final user = await Provider.of<UserProvider>(context, listen: false);
    await group.updateStatus(user.loginUser, widget.gid, "delete");
  }

  @override
  Widget build(BuildContext context) {
    return grpRequest == "Delete"
        ? Container()
        : ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal[200],
              backgroundImage: NetworkImage(widget.imgUrl),
              //child: Icon(Icons.group, color: Colors.white),
            ),
            title: Text(
              widget.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            subtitle: Text(
              widget.desc,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
            trailing: grpRequest == "Accept"
                ? Text(
                    "ACCEPTED",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        fontSize: 14),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ButtonTheme(
                        height: MediaQuery.of(context).size.height * 0.04,
                        minWidth: 5,
                        child: FlatButton(
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
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Text(
                                            'Continue to accept group invitation',
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
                                              _groupAccept().then((value) {
                                                setState(() {
                                                  grpRequest = "Accept";
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
                      ButtonTheme(
                        height: MediaQuery.of(context).size.height * 0.04,
                        minWidth: 10,
                        child: FlatButton(
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
                                                  Navigator.of(context).pop();
                                                },
                                                child: Icon(Icons.close)),
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
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 20),
                                        Text('The face was shocked!',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Text(
                                            'Continue to delete group invitation',
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
                                            color: Colors.red,
                                            onPressed: () {
                                              _groupDelete().then((value) {
                                                setState(() {
                                                  grpRequest = "Delete";
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
