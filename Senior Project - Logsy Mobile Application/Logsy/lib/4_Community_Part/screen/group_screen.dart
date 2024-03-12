import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/post.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/challenge_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/create_challenge_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/invite_group_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/scoreboard_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/view_group_member_screen.dart';
import 'package:logsy_app/4_Community_Part/widget/post_item.dart';
import 'package:logsy_app/4_Community_Part/widget/top_community.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatefulWidget {
  static const routeName = "/group-screen";

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  var _isInit = true;
  var _isLoading = false;
  var name;
  var grpStatus;
  var grpKind;
  Group groupData;
  var numGroup;
  var gid;
  List<Post> allPost;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      //arguments
      final list = ModalRoute.of(context).settings.arguments as List;

      gid = list[0] as int;
      String status = list[1];
      //provider
      final group = Provider.of<GroupProvider>(context, listen: false);
      final post = Provider.of<PostProvider>(context, listen: false);
      final user = Provider.of<UserProvider>(context, listen: false);

      //query
      await group.getGroup(gid).then((value) {
        groupData = value as Group;
        name = value.name;
        grpKind = value.type;
        grpStatus = status;
      });

      await group.getGroupMember(gid, user.loginUser).then((value) {
        numGroup = value.length;
      });
      await post.getAllPost(gid, user.loginUser).then((value) {
        setState(() {
          _isLoading = false;
          allPost = value.reversed.toList() as List<Post>;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateThis() async {
    setState(() {
      _isLoading = true;
    });
    final post = Provider.of<PostProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await post.getAllPost(gid, user.loginUser).then((value) {
      setState(() {
        _isLoading = false;
        allPost = value.reversed.toList() as List<Post>;
      });
    });
  }

  Future<void> _joinGroup() async {
    final group = Provider.of<GroupProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await group.updateStatus(user.loginUser, gid, "join").then((value) {
      _reItem("member");
    });
  }

  Future<void> _deleteGroup() async {
    final group = Provider.of<GroupProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await group.updateStatus(user.loginUser, gid, "delete").then((value) {
      _reItem("blank");
    });
  }

  void _reItem(String status) async {
    final group = Provider.of<GroupProvider>(context, listen: false);
    final post = Provider.of<PostProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);

    //query
    await group.getGroup(gid).then((value) {
      groupData = value as Group;
      name = value.name;
      grpKind = value.type;
      grpStatus = status;
    });

    await group.getGroupMember(gid, user.loginUser).then((value) {
      numGroup = value.length;
    });
    await post.getAllPost(gid, user.loginUser).then((value) {
      setState(() {
        _isLoading = false;
        allPost = value.reversed.toList() as List<Post>;
      });
    });
  }

  Widget statusGroup() {
    if (grpStatus == "invited") {
      return ButtonTheme(
        minWidth: MediaQuery.of(context).size.width * 0.02,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        height: 30,
        child: RaisedButton(
          elevation: 0.0,
          color: Colors.amber,
          onPressed: () {},
          child: Text(
            "Accept",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      );
    }
    if (grpStatus == "blank") {
      return ButtonTheme(
        minWidth: MediaQuery.of(context).size.width * 0.02,
        height: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: RaisedButton(
            elevation: 0.0,
            color: Colors.amber,
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
                                    Text(groupData.name,
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
            child: Text(
              "Join",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            )),
      );
    } else if (grpStatus == "member") {
      return ButtonTheme(
        minWidth: MediaQuery.of(context).size.width * 0.02,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        height: 30,
        child: OutlineButton(
            borderSide: BorderSide(color: Colors.teal),
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
                                    Text(groupData.name,
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
            child: Text(
              "Member",
              style: TextStyle(
                color: Colors.teal,
                fontSize: 12,
              ),
            )),
      );
    }
  }
  void _notifyUsage() async{
      final user = Provider.of<UserProvider>(context, listen: false);
      await user.postUsage(user.loginUser, DateTime.now(), "AccessScoreboard");
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          name == null ? "" : name.toUpperCase(),
          style: TextStyle(
              fontSize: 18,
              color: Colors.teal[500],
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      // floatingActionButton: grpStatus != "member"
      //     ? Container()
      //     : FloatingActionButton(
      //         onPressed: () {
      //           Navigator.of(context).pushNamed(CreateChallengeScreen.routeName,
      //               arguments: groupData.gid);
      //         },
      //         child: Icon(
      //           Icons.add,
      //           color: Colors.white,
      //         ),
      //         backgroundColor: Colors.red[400],
      //       ),
      body: _isLoading
          ? Container()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.indigo[300],
                          Colors.teal[400],
                          Colors.amber[100],
                        ],
                      ),
                      image: DecorationImage(
                          image:NetworkImage(groupData.imgUrl),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    grpKind == "public"
                                        ? "Public Group"
                                        : "Private Group",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Spacer(),
                              grpStatus != "member"
                                  ? Container()
                                  : ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                      height: 30,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: FlatButton(
                                        color: Colors.teal,
                                        // borderSide: BorderSide(color: Colors.teal),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              InviteGroupScreen.routeName,
                                              arguments: gid);
                                        },
                                        child: Text(
                                          "Invite",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                              statusGroup()
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  groupData.des,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width *
                                        0.43 *
                                        2 +
                                    10,
                                height: 30,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: OutlineButton(
                                  borderSide: BorderSide(color: Colors.teal),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        ViewGroupMemberScreen.routeName,
                                        arguments: gid);
                                  },
                                  child: Text(
                                    "$numGroup Members",
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Colors.amber[300],
                                      Colors.red,
                                      Colors.purple[300]
                                    ],
                                  ),
                                ),
                                child: ButtonTheme(
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.43,
                                  height: 30,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: FlatButton(
                                    child: Container(
                                      child: Text(
                                        "SCOREBOARD",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    onPressed: () {
                                      _notifyUsage();
                                      Navigator.of(context).pushNamed(
                                          ScoreboardScreen.routeName,
                                          arguments: gid);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              grpStatus != "member"
                                  ? ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.43,
                                      height: 30,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: OutlineButton(
                                        borderSide:
                                            BorderSide(color: Colors.teal),
                                        child: Text(
                                          "CHALLENGE",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    )
                                  : ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.43,
                                      height: 30,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: OutlineButton(
                                        borderSide:
                                            BorderSide(color: Colors.teal),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              ChallengeScreen.routeName,
                                              arguments: gid);
                                        },
                                        child: Text(
                                          "CHALLENGE",
                                          style: TextStyle(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.teal[100],
                  ),
                  grpStatus != "member"
                      ? Container()
                      : TopCommunity(gid: gid, parentAction: _updateThis),
                  SizedBox(height: 10),
                  grpKind == "public" || grpStatus == "member"
                      ? Column(
                          children: allPost
                              .map<Widget>((value) => PostItem(value.user_uid,
                                  value.group_gid, value.timestamp))
                              .toList(),
                        )
                      : Container()
                ],
              ),
            ),
    );
  }
}
