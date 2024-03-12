import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:logsy_app/4_Community_Part/widget/invite_list_item.dart';
import 'package:logsy_app/4_Community_Part/widget/view_friend_item.dart';

import 'package:provider/provider.dart';

class InviteGroupScreen extends StatefulWidget {
  static const routeName = "/invite-group-screen";
  @override
  _InviteGroupScreenState createState() => _InviteGroupScreenState();
}

class _InviteGroupScreenState extends State<InviteGroupScreen> {
  bool _isInit = true;
  List<User> _realList = [];
  List<User> _list = [];
  int currentGid;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final user = Provider.of<UserProvider>(context, listen: false);
      final gid = ModalRoute.of(context).settings.arguments as int;
      currentGid = gid;
      await user.userFriend(user.loginUser).then((value) {
        setState(() {
          _realList = value;
          _list = _realList;
          
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  

  void _reItem() async {
    final user = Provider.of<UserProvider>(context, listen: false);

    await user.userFriend(user.loginUser).then((value) {
      setState(() {
        _realList = value;
        _list = _realList;
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
          "INVITATION",
          style: TextStyle(
              fontSize: 18,
              color: Colors.teal[500],
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: _list.length == 0
          ? Center(child: CircularProgressIndicator())
          : Column(
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
                            _list = _realList;
                          });
                        } else {
                          List<dynamic> searchMember = _list
                              .where((element) =>
                                  '${element.firstName} ${element.lastName}'
                                      .toLowerCase()
                                      .contains(text.toLowerCase()))
                              .toList();
                          setState(() {
                            _list = searchMember;
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
                _list == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (ctx, i) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    ProfileScreen.routeName,
                                    arguments: [
                                      _list[i].uid,
                                      user.userFriendStatus(
                                          user.loginUser, _list[i].uid)
                                    ]).then((_) {
                                  _reItem();
                                });
                              },
                              child: InviteListItem(_list, i, currentGid)),
                          itemCount: _list.length,
                        ),
                      ),
              ],
            ),
    );
  }
}
