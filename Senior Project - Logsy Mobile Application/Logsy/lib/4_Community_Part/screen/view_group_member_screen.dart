import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:logsy_app/4_Community_Part/widget/view_friend_item.dart';
import 'package:provider/provider.dart';

class ViewGroupMemberScreen extends StatefulWidget {
  static const routeName = "/view-group-member-screen";

  @override
  _ViewGroupMemberScreenState createState() => _ViewGroupMemberScreenState();
}

class _ViewGroupMemberScreenState extends State<ViewGroupMemberScreen> {
  List<dynamic> _realMember;
  List<dynamic> _member;
  var _isLoading = false;
  var currentGid;
  var _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      currentGid = ModalRoute.of(context).settings.arguments as int;
      final group = Provider.of<GroupProvider>(context, listen: false);
      final user = Provider.of<UserProvider>(context, listen: false);

      await group.getGroupMember(currentGid, user.loginUser).then((value) {
        setState(() {
          _isLoading = false;
          _realMember = value;
        });
        _member = _realMember;
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void _reItem() async {
    final group = Provider.of<GroupProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);

    await group.getGroupMember(currentGid, user.loginUser).then((value) {
      setState(() {
        _isLoading = false;
        _realMember = value;
      });
      _member = _realMember;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "MEMBERS",
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
                            _member = _realMember;
                          });
                        } else {
                          List<dynamic> searchMember = _member
                              .where((element) =>
                                  '${element.firstName} ${element.lastName}'
                                      .toLowerCase()
                                      .contains(text.toLowerCase()))
                              .toList();
                          setState(() {
                            _member = searchMember;
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
                _member == null
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
                                    _member[i].uid,
                                    user.userFriendStatus(
                                        user.loginUser, _member[i].uid)
                                  ]).then((_) {
                                _reItem();
                              });
                            },
                            child: ViewFriendItem(
                                _member[i].uid,
                                user.userFriendStatus(
                                    user.loginUser, _member[i].uid)),
                          ),
                          itemCount: _member.length,
                        ),
                      ),
              ],
            ),
    );
  }
}
