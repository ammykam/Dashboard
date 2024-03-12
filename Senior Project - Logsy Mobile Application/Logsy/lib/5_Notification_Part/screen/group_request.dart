import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/group_screen.dart';
import 'package:logsy_app/5_Notification_Part/widget/group_re_item.dart';
import 'package:provider/provider.dart';

class GroupRequest extends StatefulWidget {
  static const routeName = '/group-request';

  @override
  _GroupRequestState createState() => _GroupRequestState();
}

class _GroupRequestState extends State<GroupRequest> {
  List<Group> realList;
  List<Group> list;
  var _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final group = Provider.of<GroupProvider>(context, listen: false);
      final user = Provider.of<UserProvider>(context, listen: false);
      await group.getGroupInvite(user.loginUser).then((value) {
        setState(() {
          realList = value;
          list = realList;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _reItem() async {
    final group = Provider.of<GroupProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await group.getGroupInvite(user.loginUser).then((value) {
      setState(() {
        realList = value;
        list = realList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Group> realList =
        ModalRoute.of(context).settings.arguments as List<Group>;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'GROUP INVITATIONS',
          style: TextStyle(
              fontSize: 18,
              color: Colors.teal[500],
              fontWeight: FontWeight.bold),
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
                      print(list);
                    } else {
                      list = realList;
                      List<Group> searchList = list
                          .where(
                            (element) => element.name.toLowerCase().contains(
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
                                    Navigator.of(context)
                                        .pushNamed(GroupScreen.routeName,
                                            arguments: list[i].gid)
                                        .then((value) => _reItem());
                                  },
                                  child: GroupReItem(
                                      list[i].name, list[i].des, list[i].gid, list[i].imgUrl),
                                ),
                            itemCount: list.length),
                  ),
          ],
        ),
      ),
    );
  }
}
