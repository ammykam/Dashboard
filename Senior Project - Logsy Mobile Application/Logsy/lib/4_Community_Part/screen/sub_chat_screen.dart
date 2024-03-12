import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/widget/chat_item.dart';
import 'package:provider/provider.dart';

class SubChatScreen extends StatefulWidget {
  static const routeName = "/sub-chat";

  @override
  _SubChatScreenState createState() => _SubChatScreenState();
}

class _SubChatScreenState extends State<SubChatScreen> {
  var currentUser;
  var messageUser;
  var _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final uid = ModalRoute.of(context).settings.arguments as int;
      final user = Provider.of<UserProvider>(context, listen: false);

      currentUser = await user.getUser(user.loginUser);
      messageUser = await user.getUser(uid);
    }
    _isInit = false;
    setState(() {});
    super.didChangeDependencies();
  }

  Widget commentRow() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.teal,
                  ),
                  cursorColor: Colors.teal,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "say something...",
                    hintStyle: TextStyle(color: Colors.teal[200]),
                    labelStyle: TextStyle(color: Colors.teal),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
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

  // Just leave it here
  // I don't have to create data by myself here
  List<List<Map<String, String>>> message = [
    [
      {
        "name": "Jessica Louis",
        "type": "msg",
        "message": "Hello, It's me!",
        "time": DateFormat('EEEE, HH:mm a')
            .format(DateTime.now().subtract(Duration(days: 1))),
      },
      {
        "name": "hi",
        "type": "msg",
        "message": "Hi Good luck to you!",
        "time": DateFormat('EEEE, HH:mm a')
            .format(DateTime.now().subtract(Duration(days: 1))),
      },
    ],
    [
      {
        "name": "Jessica Louis",
        "type": "msg",
        "message": "Hello, It's me!",
        "time": DateFormat('EEEE, HH:mm a').format(DateTime.now()),
      },
      {
        "name": "hi",
        "type": "msg",
        "message": "Hi Good luck to you!",
        "time": DateFormat('EEEE, HH:mm a').format(DateTime.now()),
      }
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        centerTitle: true,
        title: messageUser == null
            ? Text("")
            : Text(
                "${messageUser.firstName} ${messageUser.lastName}",
                style: TextStyle(fontSize: 18, color: Colors.teal[500], fontWeight: FontWeight.bold),
              ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: messageUser == null ? Center(child: CircularProgressIndicator()): Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemBuilder: (ctx, i) => ChatItem(message[i], messageUser.uid),
                itemCount: message.length),
          ),
          commentRow(),
        ],
      ),
    );
  }
}
