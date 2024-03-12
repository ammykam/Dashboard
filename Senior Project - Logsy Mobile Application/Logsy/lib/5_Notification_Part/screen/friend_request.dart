import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:logsy_app/5_Notification_Part/widget/friend_re_item.dart';
import 'package:provider/provider.dart';

class FriendRequest extends StatefulWidget {
  static const routeName = '/friend-request';

  @override
  _FriendRequestState createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  List<User> realList;
  List<User> list;
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final user = Provider.of<UserProvider>(context, listen: false);
      await user.userPending(user.loginUser).then((value) {
        setState(() {
          realList = value;
          list = realList;
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

  void _reItem() async{
    final user = Provider.of<UserProvider>(context, listen: false);
      await user.userPending(user.loginUser).then((value) {
        setState(() {
          realList = value;
          list = realList;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'FRIEND REQUESTS',
          style: TextStyle(fontSize: 18, color: Colors.teal[500], fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: Form(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width,
              color: Colors.teal[100],
              child: Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  onChanged: (text) {
                    if (text == "") {
                      setState(() {
                        list = realList;
                      });
                    } else {
                      list = realList;
                      List<dynamic> searchList = list
                          .where(
                            (element) =>
                                '${element.firstName} ${element.lastName}'
                                    .toLowerCase()
                                    .contains(
                                      text.toLowerCase(),
                                    ),
                          )
                          .toList();
                      setState(() {
                        list = searchList;
                      });
                    }
                  },
                  style: TextStyle(color: Colors.teal),
                  cursorColor: Colors.teal,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      border: InputBorder.none,
                      focusColor: Colors.teal),
                ),
              ),
            ),
            list == null
                ? LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    minHeight: MediaQuery.of(context).size.height * 0.0001,
                  )
                : Expanded(
                    child: list.length == 0
                        ? Container(
                            width: double.infinity,
                            child: Center(
                                child: Text("There are no pending request.")),
                            height: MediaQuery.of(context).size.height * 0.07,
                          )
                        : ListView.builder(
                            itemBuilder: (ctx, i) => GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        ProfileScreen.routeName,
                                        arguments: [
                                          list[i].uid,
                                          user.userFriendStatus(
                                              user.loginUser, list[i].uid)
                                        ]).then((value) => _reItem());
                                  },
                                  child: FriendReItem(
                                    list[i].uid,
                                    '${list[i].firstName} ${list[i].lastName}',
                                    list[i].des,
                                    list[i].imgUrl,
                                    
                                  ),
                                ),
                            itemCount: list.length),
                  ),
          ],
        ),
      ),
    );
  }
}
