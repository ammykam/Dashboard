import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:provider/provider.dart';

class ChatItem extends StatefulWidget {
  final List<Map<String, String>> chat;
  final int uid;

  ChatItem(this.chat, this.uid);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  var currentUser;
  var _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final user = Provider.of<UserProvider>(context);
      currentUser = await user.getUser(user.loginUser);
    }
    print(currentUser.firstName);
    _isInit = false;
    
    super.didChangeDependencies();
  }

  Widget _buildTextForSender(String msg) {
    final user = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProfileScreen.routeName,
                    arguments: [
                      widget.uid,
                      user.userFriendStatus(user.loginUser, widget.uid)
                    ]);
              },
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
            SizedBox(width: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.teal[400],
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(msg, style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTextForOwner(String msg) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(msg, style: TextStyle(color: Colors.teal)),
              ),
            ),
            SizedBox(width: 20),
            CircleAvatar(
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return currentUser == null ? Container(): Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Column(
          children: [
            Text(
              widget.chat[0]["time"],
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: widget.chat
                  .map<Widget>((chat) => chat["name"] ==
                          "${currentUser.firstName} ${currentUser.lastName}"
                      ? _buildTextForOwner(chat["message"])
                      : _buildTextForSender(chat["message"]))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
