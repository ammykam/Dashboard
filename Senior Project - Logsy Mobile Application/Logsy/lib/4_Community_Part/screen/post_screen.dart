import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/post.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/widget/comment_item.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  static const routeName = '/post-screen';

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var image;
  Group group;
  var desc;
  var _isInit = true;
  var _isLoading = false;
  Post data;
  User userData;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      data = ModalRoute.of(context).settings.arguments as Post;
      image = data.imgUrl;
      desc = data.content;

      final user = Provider.of<UserProvider>(context);
      final groupProvider = Provider.of<GroupProvider>(context);
      await user.getUser(data.user_uid).then((value) {
        userData = value as User;
      });
      await groupProvider.getGroup(data.group_gid).then((value) {
        setState(() {
          group = value as Group;
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Widget commentRow() {
    return Container(
      color: Colors.teal[100],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          // height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(
                    "https://cdn.shortpixel.ai/spai/w_1082+q_lossless+ret_img+to_webp/https://pawleaks.com/wp-content/uploads/2020/03/Maltese-Lifespan-Facts-You-Should-Know-scaled.jpg"),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  height: MediaQuery.of(context).size.height * 0.045,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                    cursorColor: Colors.teal,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "say something...",
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                      ),
                      labelStyle: TextStyle(color: Colors.teal),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward),
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDiffTime(DateTime oldTime) {
    final different = DateTime.now().difference(data.timestamp);
    // year, month, day
    if (different.inDays >= 1) {
      if (different.inDays == 1) {
        return "${different.inDays.toString()} day";
      }
      return "${different.inDays.toString()} days";
    }
    //hour
    else if (different.inHours >= 1) {
      if (different.inHours == 1) {
        return "${different.inHours.toString()} hr";
      }
      return "${different.inHours.toString()} hrs";
    }
    //minutes
    else if (different.inMinutes >= 1) {
      if (different.inMinutes == 1) {
        return "${different.inMinutes.toString()} min";
      }
      return "${different.inMinutes.toString()} mins";
    }
    //seconds
    else {
      return "${different.inSeconds.toString()} s";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> comment = [
      "Fah Suttamon",
      "Pachara Pattarabodee",
      "Ma-Muang",
      "Ammy"
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(bottom: 0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal[400],
                  image: DecorationImage(
                      image: NetworkImage(userData == null
                          ? "https://www.porcelaingres.com/img/collezioni/JUST-GREY/big/just_grey_light_grey.jpg"
                          : userData.imgUrl))),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData == null
                      ? ""
                      : "${userData.firstName} ${userData.lastName}",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  group == null ? "Group:" : "Group: ${group.name}",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            Spacer(),
            Text("${_getDiffTime(data.timestamp)} ago",
                style: TextStyle(color: Colors.grey, fontSize: 12))
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: _isLoading || userData == null
          ? LinearProgressIndicator(minHeight: 1, backgroundColor: Colors.white)
          : SingleChildScrollView(
              child: Column(
                children: [
                  //comment
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          desc,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 20),
                        image != ""
                            ? 
                            FittedBox(
                                child: Image.network(image),
                                fit: BoxFit.fill,
                              )
                            // Container(
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.2,
                            //     decoration: BoxDecoration(
                            //       color: Colors.blueGrey[100],
                            //       image: DecorationImage(
                            //           image: NetworkImage(
                            //               "https://th.virbac.com/files/live/sites/virbac-th/files/predefined-files/species/pictures/Cats/Cat%20species%202%20-%20280x205.jpg"),
                            //           fit: BoxFit.cover),
                            //     ),
                            //   )
                            : Container(),
                        image != "" ? SizedBox(height: 20) : Container(),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.teal,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "200",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Row(
                              children: [
                                Icon(
                                  Icons.comment,
                                  color: Colors.teal,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "125",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //line
                  Divider(
                    thickness: 1.5,
                    color: Colors.teal[100],
                  ),
                  //comment
                  Column(children: comment.map((e) => CommentItem(e)).toList()),
                  commentRow(),
                ],
              ),
            ),
    );
  }
}
