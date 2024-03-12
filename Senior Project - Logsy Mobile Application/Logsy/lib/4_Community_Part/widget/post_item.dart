import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/post.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/post_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:logsy_app/4_Community_Part/widget/report_sheet.dart';
import 'package:provider/provider.dart';

class PostItem extends StatefulWidget {
  final int uid;
  final int gid;
  final DateTime timeStamp;
  PostItem(this.uid, this.gid, this.timeStamp);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool _isInit = true;
  bool _isLoading = false;
  Post postData;
  User postUser;
  Group groupData;
  bool _hide = false;
  bool _unfriend = false;
  bool _block = false;
  bool _disappear = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final post = Provider.of<PostProvider>(context, listen: false);
      final user = Provider.of<UserProvider>(context, listen: false);
      final group = Provider.of<GroupProvider>(context, listen: false);

      await post
          .getPost(widget.uid, widget.gid, widget.timeStamp.toString())
          .then((value) {
        postData = value;
      });

      await user.getUser(postData.user_uid).then((value) {
        postUser = value;
      });
      await group.getGroup(postData.group_gid).then((value) {
        setState(() {
          groupData = value;
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  String _getDiffTime(DateTime oldTime) {
    final different = DateTime.now().difference(postData.timestamp);
    // year, month, day
    if (different.inDays >= 1) {
      if (different.inDays == 1) {
        return "${different.inDays.toString()} d";
      }
      return "${different.inDays.toString()} d";
    }
    //hour
    else if (different.inHours >= 1) {
      if (different.inHours == 1) {
        return "${different.inHours.toString()} h";
      }
      return "${different.inHours.toString()} h";
    }
    //minutes
    else if (different.inMinutes >= 1) {
      if (different.inMinutes == 1) {
        return "${different.inMinutes.toString()} m";
      }
      return "${different.inMinutes.toString()} m";
    }
    //seconds
    else {
      return "${different.inSeconds.toString()} s";
    }
  }

  void report(String text) {
    if (text == 'hide') {
      setState(() {
        _hide = true;
      });
    } else if (text == 'unfriend') {
      setState(() {
        _unfriend = true;
      });
    } else if (text == 'block') {
      setState(() {
        _block = true;
      });
    }
    Timer timer = new Timer(new Duration(seconds: 5), () {
      setState(() {
        _hide = false;
        _unfriend = false;
        _block = false;
        _disappear = true;
      });
    });
  }

  Widget _reactionPost(Icon icon, String text) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            icon,
            SizedBox(height: 10),
            Text(text,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);

    return _isLoading ||
            postData == null ||
            postUser == null ||
            groupData == null
        ? LinearProgressIndicator(
            minHeight: 0.1, backgroundColor: Colors.teal[500])
        : _disappear
            ? Container()
            : Column(
                children: [
                  _hide
                      ? _reactionPost(Icon(Icons.hide_image, size: 30),
                          'This post is hidden.')
                      : _unfriend
                          ? _reactionPost(Icon(Icons.person_off, size: 30),
                              'This user is reported and unfriended.')
                          : _block
                              ? _reactionPost(Icon(Icons.person_off, size: 30),
                                  'This user is reported and blocked.')
                              : Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  child: Padding(
                                    padding: EdgeInsets.all(30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                ProfileScreen.routeName,
                                                arguments: [
                                                  postData.user_uid,
                                                  user.userFriendStatus(
                                                      user.loginUser,
                                                      postData.user_uid)
                                                ]);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            child: IntrinsicWidth(
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.teal[300],
                                                    backgroundImage: AssetImage(
                                                        'assets/avatar/${postUser.imgUrl}'),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${postUser.firstName} ${postUser.lastName}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[700],
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Group: ${groupData.name} • ",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.teal,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${_getDiffTime(postData.timestamp)}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  postData.user_uid ==
                                                          user.loginUser
                                                      ? Container()
                                                      : GestureDetector(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                barrierColor:
                                                                    Colors
                                                                        .black54,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30.0),
                                                                ),
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return ReportSheet(
                                                                      postData,
                                                                      postUser,
                                                                      report);
                                                                }).then((value) => null);
                                                          },
                                                          child: Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.grey,
                                                              size: 15),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          postData.content,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        postData.imgUrl != null &&
                                                postData.imgUrl != ""
                                            ? Column(
                                                children: [
                                                  SizedBox(height: 20),
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.blueGrey[100],
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              postData.imgUrl),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                  SizedBox(height: 10)
                ],
              );
  }
}
