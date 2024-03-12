import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/widget/chat_list_item.dart';
import 'package:provider/provider.dart';

class MainChatScreen extends StatefulWidget {
  static const routeName = "/main-chat";

  @override
  _MainChatScreenState createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  //Mock Data Very HARDD
  List<Map<String, dynamic>> realFriends = [
    {'uid': 2, 'name': "Guilbert Chantrell"},
    {'uid': 3, 'name': "Maridel McCranken"},
    {'uid': 4, 'name': "Breena Horlock"}
  ];
  List<Map<String, dynamic>> friends;
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final user = Provider.of<UserProvider>(context);
    }
    _isInit = false;
    friends = realFriends;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'MESSAGE',
          style: TextStyle(fontSize: 18, color: Colors.teal[500], fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: friends == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Form(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.06,
                    color: Colors.teal[50],
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: TextFormField(
                        onChanged: (text) {
                          if (text == "") {
                            setState(() {
                              friends = realFriends;
                            });
                          } else {
                            setState(() {
                              friends = realFriends;
                            });
                            List<Map<String, dynamic>> searchFriend = friends
                                .where((element) => element['name']
                                    .toLowerCase()
                                    .startsWith(text.toLowerCase()))
                                .toList();
                            setState(() {
                              friends = searchFriend;
                            });
                          }
                        },
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                        cursorColor: Colors.teal,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.teal),
                          hintText: "search",
                          hintStyle: TextStyle(color: Colors.teal[200]),
                          labelStyle: TextStyle(color: Colors.teal),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (ctx, i) => ChatListItem(friends[i]['uid']),
                      itemCount: friends.length),
                )
              ],
            ),
    );
  }
}
