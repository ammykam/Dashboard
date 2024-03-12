import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/group_screen.dart';
import 'package:provider/provider.dart';

class GroupItem extends StatefulWidget {
  final Group group;
  final Function update;

  GroupItem({this.group, this.update});

  @override
  _GroupItemState createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> {
  var _isInit = true;
  var _isLoading = false;
  int numGroupmem = 0;
  String status = "";
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final user = Provider.of<UserProvider>(context, listen: false);
      final group = Provider.of<GroupProvider>(context, listen: false);
      await group
          .getGroupStatus(user.loginUser, widget.group.gid)
          .then((value) {
        status = value;
      });
      await group.getGroupMember(widget.group.gid, user.loginUser).then((value) {
        setState(() {
          numGroupmem = value.length;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant GroupItem oldWidget) {
    final group = Provider.of<GroupProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    group.getGroupStatus(user.loginUser, widget.group.gid).then((value) {
      status = value;
    });
    group.getGroupMember(widget.group.gid, user.loginUser).then((value) {
      setState(() {
        numGroupmem = value.length;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _joinGroup() async {
    final group = Provider.of<GroupProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await group
        .updateStatus(user.loginUser, widget.group.gid, "join")
        .then((value) {
      _reItem();
    });
  }

  Future<void> _deleteGroup() async {
    final group = Provider.of<GroupProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await group
        .updateStatus(user.loginUser, widget.group.gid, "delete")
        .then((value) {
      _reItem();
    });
  }

  void _reItem() async {
    final group = Provider.of<GroupProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    group.getGroupStatus(user.loginUser, widget.group.gid).then((value) {
      setState(() {
        status = value;
      });
    });
    group.getGroupMember(widget.group.gid, user.loginUser).then((value) {
      setState(() {
        numGroupmem = value.length;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return status == ""
        ? Container()
        : ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(GroupScreen.routeName,
                  arguments: [widget.group.gid, status]).then((value) {
                widget.update();
                _reItem();
                print("hello");
              });
            },
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              backgroundImage: NetworkImage(widget.group.imgUrl == ""
                  ? "https://image.freepik.com/free-vector/group-young-people-posing-photo_52683-18824.jpg"
                  : widget.group.imgUrl),
            ),
            title: Text(
              widget.group.name,
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "$numGroupmem members",
              style: TextStyle(color: Colors.teal[300], fontSize: 13),
            ),
            trailing: status == "member"
                ? ButtonTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 30,
                    child: FlatButton(
                      color: Colors.white,
                      child:
                          Text("MEMBER", style: TextStyle(color: Colors.teal)),
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
                                    Image.asset("assets/Popup/racism.png",
                                        width: 90, height: 90),
                                    SizedBox(height: 20),
                                    Text("Nooo!!",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                                    Text('The party is ending!',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                    Text('Continue to leave',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                    Text(widget.group.name,
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
                                        color: Colors.red,
                                        onPressed: () {
                                          _deleteGroup();
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
                    ),
                  )
                : ButtonTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 30,
                    child: FlatButton(
                      color: Colors.teal[50],
                      child: Text("JOIN", style: TextStyle(color: Colors.teal)),
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
                                    Image.asset("assets/Popup/dance.png",
                                        width: 90, height: 90),
                                    SizedBox(height: 20),
                                    Text("Woohoo!!",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                                    Text('The party is going to start!',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                    Text('Continue to join',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                    Text(widget.group.name,
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
                                          _joinGroup();
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
                    ),
                  ),
          );
  }
}
