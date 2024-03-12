import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/widget/group_item.dart';
import 'package:logsy_app/4_Community_Part/widget/people_list_item.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<User> friends;
  List<User> _originalFriends;

  List<Group> groups;
  List<Group> _originalGroups;

  var _isLoading = false;
  var _isStart = true;
  var uid;

  @override
  void didChangeDependencies() async {
    if (_isStart) {
      setState(() {
        _isLoading = true;
      });
      uid = ModalRoute.of(context).settings.arguments as int;
      final user = Provider.of<UserProvider>(context, listen: false);
      final group = Provider.of<GroupProvider>(context, listen: false);
      await user.getUsers();
      await group.getGroups().then((value) {
        _isLoading = false;
      });

      setState(() {
        _originalFriends = user.users;
        _originalGroups = group.allGroup;
        friends = _originalFriends;
        groups = _originalGroups;

        friends.sort((a, b) => ("${a.firstName} ${a.lastName}")
            .compareTo(("${b.firstName} ${b.lastName}")));
        groups.sort((a, b) => (a.name.compareTo(b.name)));
      });
    }
    _isStart = false;

    // print(friends);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _reItem() async {
    print("reitem");
    final user = Provider.of<UserProvider>(context, listen: false);
    final group = Provider.of<GroupProvider>(context, listen: false);
    await user.getUsers();
    await group.getGroups().then((value) {
      _isLoading = false;
    });

    setState(() {
      _originalFriends = user.users;
      _originalGroups = group.allGroup;
      friends = _originalFriends;
      groups = _originalGroups;
  

      friends.sort((a, b) => ("${a.firstName} ${a.lastName}")
          .compareTo(("${b.firstName} ${b.lastName}")));
      groups.sort((a, b) => (a.name.compareTo(b.name)));
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Column(
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
                                friends = _originalFriends;
                                friends.sort((a, b) =>
                                    ("${a.firstName} ${a.lastName}").compareTo(
                                        ("${b.firstName} ${b.lastName}")));
                                groups = _originalGroups;
                                groups
                                    .sort((a, b) => (a.name.compareTo(b.name)));
                              });
                            } else {
                              setState(() {
                                friends = _originalFriends;
                                friends.sort((a, b) =>
                                    ("${a.firstName} ${a.lastName}").compareTo(
                                        ("${b.firstName} ${b.lastName}")));
                                groups = _originalGroups;
                                groups
                                    .sort((a, b) => (a.name.compareTo(b.name)));
                              });
                              List<User> searchFriend = friends
                                  .where((element) =>
                                      "${element.firstName} ${element.lastName}"
                                          .toLowerCase()
                                          .contains(text.toLowerCase()))
                                  .toList();
                              List<Group> searchGroup = groups
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(text.toLowerCase()))
                                  .toList();
                              setState(() {
                                friends = searchFriend;
                                friends.sort((a, b) =>
                                    ("${a.firstName} ${a.lastName}").compareTo(
                                        ("${b.firstName} ${b.lastName}")));
                                groups = searchGroup;
                                groups
                                    .sort((a, b) => (a.name.compareTo(b.name)));
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
                            hintText: "search...",
                            hintStyle: TextStyle(color: Colors.teal[200]),
                            labelStyle: TextStyle(color: Colors.teal),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      )),
                ),
                TabBar(
                  labelColor: Colors.teal,
                  unselectedLabelColor: Colors.teal[200],
                  indicatorColor: Colors.teal,
                  tabs: [
                    Tab(text: 'People'),
                    Tab(text: 'Group'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: ListView.builder(
                      itemBuilder: (ctx, i) => friends[i].uid == uid
                          ? Container()
                          : PeopleListItem(
                              '${friends[i].firstName} ${friends[i].lastName}',
                              friends[i].uid,
                              friends[i].imgUrl,
                              uid,
                            ),
                      itemCount: friends.length,
                    ),
                  ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: ListView.builder(
                      itemBuilder: (ctx, i) => groups[i].type == "public"
                          ? GroupItem(group:groups[i], update: _reItem)
                          : Container(),
                      itemCount: groups.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
