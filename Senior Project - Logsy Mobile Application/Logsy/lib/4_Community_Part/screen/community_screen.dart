import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/post.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/main_chat_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/search_screen.dart';
import 'package:logsy_app/4_Community_Part/widget/community_drawer.dart';
import 'package:logsy_app/4_Community_Part/widget/post_item.dart';
import 'package:provider/provider.dart';

class CommunityScreen extends StatefulWidget {
  static const routeName = '/community';

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  var _isInit = true;
  var user;
  User person;
  List<Post> postData = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      user = Provider.of<UserProvider>(context, listen: false);
      final post = Provider.of<PostProvider>(context, listen: false);
      await user.getUser(user.loginUser).then((value) {
        person = value as User;
      });
      await post.getPostWithUser(user.loginUser).then((value) {
        setState(() {
          postData = value;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _reItem() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    final post = Provider.of<PostProvider>(context, listen: false);

    await post.getPostWithUser(user.loginUser).then((value) {
      setState(() {
        postData = value;
        print(postData);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'COMMUNITY',
          style: TextStyle(
              fontSize: 18,
              color: Colors.teal[500],
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(SearchScreen.routeName, arguments: person.uid)
                  .then((value) => _reItem());
            },
          ),
          // IconButton(
          //     onPressed: () {
          //       _reItem();
          //     },
          //     icon: Icon(Icons.refresh))
        ],
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: CommunityDrawer(),
      ),
      body: SingleChildScrollView(
        child: postData == null
            ? Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Text(
                    "No post",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : Column(
                children: postData
                    .map((e) => PostItem(e.user_uid, e.group_gid, e.timestamp))
                    .toList()),
      ),
    );
  }
}
