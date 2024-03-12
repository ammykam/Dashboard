import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:logsy_app/4_Community_Part/widget/view_friend_item.dart';
import 'package:provider/provider.dart';

class ViewFriendScreen extends StatefulWidget {
  static const routeName = "/view-friend-screen";

  @override
  _ViewFriendScreenState createState() => _ViewFriendScreenState();
}

class _ViewFriendScreenState extends State<ViewFriendScreen> {
  List<User> _realFriend;
  List<User> _friend;
  bool _isLoading = false;
  int currentUid;
  bool _isInit = true;
  String status;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final user = Provider.of<UserProvider>(context, listen: false);
      currentUid = ModalRoute.of(context).settings.arguments as int;

      await user.userFriend(currentUid).then((value) {
        setState(() {
          _isLoading = false;
          _realFriend = value;
        });
        _friend = _realFriend;
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _deleteFriend(int uid) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.deleteFriendRequest(user.loginUser, uid);
  }

  Widget _buttonFriend(User person) {
    return ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minWidth: MediaQuery.of(context).size.width * 0.25,
        height: 30,
        child: OutlineButton(
          borderSide: BorderSide(width: 1.0, color: Colors.transparent),
          child: Text("FRIEND",
              style: TextStyle(color: Colors.teal, fontSize: 12)),
          onPressed: () {},
        ));
  }

  Widget _checkStatus(User person) {
    // this page contains only friend + can't remove friend from here!
    return _buttonFriend(person);
  }

  void _navigate(User person) {
    final user = Provider.of<UserProvider>(context, listen: false);
    Navigator.of(context).pushNamed(ProfileScreen.routeName,
        arguments: [person.uid, user.userFriendStatus(currentUid, person.uid)]);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Friends",
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
              color: Colors.teal,
              minHeight: 0.3,
            )
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
                            _friend = _realFriend;
                          });
                        } else {
                          List<dynamic> searchFriend = _friend
                              .where((element) =>
                                  '${element.firstName} ${element.lastName}'
                                      .toLowerCase()
                                      .contains(text.toLowerCase()))
                              .toList();
                          setState(() {
                            _friend = searchFriend;
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
                _friend == null
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (ctx, i) => GestureDetector(
                            onTap: () {
                              _navigate(_friend[i]);
                            },
                            child: _friend[i] == null
                                ? LinearProgressIndicator(
                                    minHeight: 0.1,
                                    backgroundColor: Colors.teal[500])
                                : ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.teal[300],
                                      backgroundImage: AssetImage(
                                          'assets/avatar/${_friend[i].imgUrl}'),
                                    ),
                                    title: Text(
                                      "${_friend[i].firstName} ${_friend[i].lastName}",
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      _friend[i].des,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.teal),
                                    ),
                                    trailing: _checkStatus(_friend[i]),
                                  ),
                          ),
                          itemCount: _friend.length,
                        ),
                      ),
              ],
            ),
    );
  }
}
