import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/sub_chat_screen.dart';
import 'package:provider/provider.dart';

class ChatListItem extends StatefulWidget {
  final int uid;

  ChatListItem(this.uid);

  @override
  _ChatListItemState createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  var _isInit = true;
  var currentUser;
  @override
  void didChangeDependencies() async {
    if(_isInit){
      final user = Provider.of<UserProvider>(context);

      currentUser = await user.getUser(widget.uid);
    }
    _isInit = false;
    setState(() {
      
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return currentUser == null ? Container(): GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(SubChatScreen.routeName, arguments: widget.uid);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          "${currentUser.firstName} ${currentUser.lastName}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        subtitle: Text(
          "...recent Message",
          style: TextStyle(color: Colors.teal[200]),
        ),
        trailing: Text("1h", style: TextStyle(color: Colors.teal[200])),
      ),
    );
  }
}
