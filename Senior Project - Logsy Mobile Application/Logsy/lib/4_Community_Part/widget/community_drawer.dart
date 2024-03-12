import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/create_group_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/group_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/maps_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/setting_screen.dart';
import 'package:logsy_app/4_Community_Part/widget/group_list_item.dart';
import 'package:provider/provider.dart';

class CommunityDrawer extends StatefulWidget {
  CommunityDrawer({Key key}) : super(key: key);

  @override
  _CommunityDrawerState createState() => _CommunityDrawerState();
}

class _CommunityDrawerState extends State<CommunityDrawer> {
  bool _privateExpand = false;
  bool _publicExpand = false;
  var _isInit = true;
  var _isLoading = false;
  var user;
  var group;
  var name;
  var currentUid;
  var person;
  List<Group> privateGroup = [];
  List<Group> publicGroup = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      user = Provider.of<UserProvider>(context, listen: false);
      group = Provider.of<GroupProvider>(context, listen: false);
      await user.getUser(user.loginUser).then(
        (value) {
          person = value as User;
        },
      );
      await group.userGroup(user.loginUser).then((value) {
        setState(() {
          _isLoading = false;
          List<Group> groupList = value;
          privateGroup =
              groupList.where((element) => element.type == "private").toList();
          publicGroup =
              groupList.where((element) => element.type == "public").toList();
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _reItem() async {
    await user.getUser(user.loginUser).then(
      (value) {
        person = value as User;
      },
    );
    await group.userGroup(user.loginUser).then((value) {
      setState(() {
        _isLoading = false;
        List<Group> groupList = value;
        privateGroup =
            groupList.where((element) => element.type == "private").toList();
        publicGroup =
            groupList.where((element) => element.type == "public").toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.teal[400],
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(ProfileScreen.routeName,
                      arguments: [person.uid, "Owner"]);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: double.infinity,
                  color: Colors.teal[200],
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                margin: EdgeInsets.only(bottom: 0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(person == null
                                          ? 'assets/greyAvatar.png'
                                          : 'assets/avatar/${person.imgUrl}'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right:5),
                                                                          child: Text(
                                        person == null
                                            ? ""
                                            : "${person.firstName} ${person.lastName}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "Bangkok, TH",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                horizontalTitleGap: 1.0,
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  "SETTINGS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(SettingScreen.routeName);
                },
              ),
              ListTile(
                horizontalTitleGap: 1.0,
                leading: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  "CREATE GROUP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(CreateGroupScreen.routeName)
                      .then((value) => _reItem());
                },
              ),
              Column(
                children: [
                  ListTile(
                    horizontalTitleGap: 1.0,
                    leading: Icon(Icons.emoji_people, color: Colors.white),
                    title: Text(
                      "PRIVATE GROUP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _privateExpand = !_privateExpand;
                      });
                    },
                    trailing: IconButton(
                      icon: _privateExpand
                          ? Icon(Icons.expand_more)
                          : Icon(Icons.expand_less),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _privateExpand = !_privateExpand;
                        });
                      },
                    ),
                  ),
                  _privateExpand
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.1),
                          child: Container(
                            child: Column(
                              children: privateGroup
                                  .map(
                                    (item) => Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                GroupScreen.routeName,
                                                arguments: [
                                                  item.gid,
                                                  "member"
                                                ]).then((value) => _reItem());
                                          },
                                          child: GroupListItem(item.name,
                                              item.type, item.gid, item.imgUrl),
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
              Column(
                children: [
                  ListTile(
                    horizontalTitleGap: 1.0,
                    leading: Icon(Icons.emoji_people, color: Colors.white),
                    title: Text(
                      "PUBLIC GROUP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _publicExpand = !_publicExpand;
                      });
                    },
                    trailing: IconButton(
                      icon: _publicExpand
                          ? Icon(Icons.expand_more)
                          : Icon(Icons.expand_less),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _publicExpand = !_publicExpand;
                        });
                      },
                    ),
                  ),
                  _publicExpand
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.1),
                          child: Container(
                            child: Column(
                              children: publicGroup
                                  .map(
                                    (item) => Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                GroupScreen.routeName,
                                                arguments: [
                                                  item.gid,
                                                  "member"
                                                ]).then((value) => _reItem());
                                          },
                                          child: GroupListItem(item.name,
                                              item.type, item.gid, item.imgUrl),
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
