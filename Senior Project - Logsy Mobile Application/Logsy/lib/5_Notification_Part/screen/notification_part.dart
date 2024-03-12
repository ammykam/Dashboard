import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/badges.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/group_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:logsy_app/5_Notification_Part/screen/friend_request.dart';
import 'package:logsy_app/5_Notification_Part/screen/group_request.dart';
import 'package:logsy_app/5_Notification_Part/widget/friend_re_item.dart';
import 'package:logsy_app/5_Notification_Part/widget/group_re_item.dart';
import 'package:logsy_app/5_Notification_Part/widget/notification_list_item.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notification';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<User> friend_re = [];
  List<Group> group_re = [];
  List<Group> fullGroupRe = [];
  List<Badge> badgeData = [];
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final user = Provider.of<UserProvider>(context, listen: false);
      final group = Provider.of<GroupProvider>(context, listen: false);
      final badge = Provider.of<BadgeProvider>(context, listen: false);
      await user.userPending(user.loginUser).then((value) {
        if (value.length <= 1) {
          friend_re = value;
        } else {
          friend_re = value.sublist(value.length - 2, value.length);
        }
      });
      await group.getGroupInvite(user.loginUser).then((value) {
        if (value.length <= 1) {
          group_re = value;
          _isLoading = false;
        } else {
          group_re = value.sublist(value.length - 2, value.length);
          _isLoading = false;
        }
      });
      await badge.getAllBadge(user.loginUser).then((value) {
        setState(() {
          badgeData = value;
          badgeData.sort((a,b) => a.timestamp.toString().compareTo(b.timestamp.toString()));
          badgeData = badgeData.reversed.toList();
          
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _reItem() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    final group = Provider.of<GroupProvider>(context, listen: false);
    await user.userPending(user.loginUser).then((value) {
      if (value.length <= 1) {
        friend_re = value;
      } else {
        friend_re = value.sublist(value.length - 2, value.length);
      }
    });
    await group.getGroupInvite(user.loginUser).then((value) {
      if (value.length <= 1) {
        group_re = value;
      } else {
        group_re = value.sublist(value.length - 2, value.length);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'NOTIFICATIONS',
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
            ? LinearProgressIndicator(
                minHeight: 0.1, backgroundColor: Colors.teal[500])
            : Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              "Friend Request",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(FriendRequest.routeName)
                                    .then((_) => _reItem());
                              },
                              child: Text(
                                "See all",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                        color: Colors.teal,
                      ),
                      friend_re == null
                          ? LinearProgressIndicator(
                              minHeight: 1, backgroundColor: Colors.white)
                          : friend_re.length == 0
                              ? Container(
                                  width: double.infinity,
                                  child: Center(
                                    child:
                                        Text("There are no pending request."),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                )
                              : Column(
                                  children: friend_re
                                      .map(
                                        (data) => GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              ProfileScreen.routeName,
                                              arguments: [
                                                data.uid,
                                                user.userFriendStatus(
                                                    user.loginUser, data.uid)
                                              ],
                                            ).then((value) => _reItem());
                                          },
                                          child: FriendReItem(
                                            data.uid,
                                            '${data.firstName} ${data.lastName}',
                                            data.des,
                                            data.imgUrl,
                                          ),
                                        ),
                                      )
                                      .toList()),
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                "Group Invitations",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(GroupRequest.routeName)
                                      .then((_) => _reItem());
                                },
                                child: Text(
                                  "See all",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),
                          color: Colors.teal),
                      group_re == null
                          ? LinearProgressIndicator(
                              minHeight: 1, backgroundColor: Colors.white)
                          : group_re.length == 0
                              ? Container(
                                  width: double.infinity,
                                  child: Center(
                                    child:
                                        Text("There are no pending request."),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                )
                              : Column(
                                  children: group_re
                                      .map(
                                        (data) => GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                GroupScreen.routeName,
                                                arguments: [data.gid,"invited"]);
                                          },
                                          child: GroupReItem(data.name,
                                              data.des, data.gid, data.imgUrl),
                                        ),
                                      )
                                      .toList()),
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Others",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          color: Colors.teal),
                      Column(
                        children: badgeData
                            .map((data) => NotificationListItem(data))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
