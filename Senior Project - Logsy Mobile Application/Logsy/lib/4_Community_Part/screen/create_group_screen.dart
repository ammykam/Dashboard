import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/widget/group_1_item.dart';
import 'package:logsy_app/4_Community_Part/widget/group_2_item.dart';
import 'package:provider/provider.dart';

class CreateGroupScreen extends StatefulWidget {
  static const routeName = "/create-group";

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  Map<String, dynamic> groupData = {
    'gid': 0,
    'user_uid': 0,
    'name': '',
    'type': '',
    'des': '',
    'latitude': "",
    'longitude': "",
    'imgUrl': '',
    'invitation': [],
  };
  int page = 1;
  bool _isDone = false;
  bool _isErr = false;

  void _changePage(Map<String, dynamic> data) {
    setState(() {
      page++;
      groupData = {
        'gid': groupData['gid'],
        'user_uid': groupData['user_uid'],
        'name': data['name'],
        'type': groupData['type'],
        'des': groupData['des'],
        'latitude': groupData['latitude'],
        'longitude': groupData['longitude'],
        'imgUrl': groupData['imgUrl'],
        'invitation': data['invitation'],
      };
    });
  }

  void _backPage(Map<String, dynamic> data) {
    setState(() {
      page--;
      groupData = {
        'gid': groupData['gid'],
        'user_uid': groupData['user_uid'],
        'name': groupData['name'],
        'type': data['type'],
        'des': data['des'],
        'latitude': data['latitude'],
        'longitude': data['longitude'],
        'imgUrl': groupData['imgUrl'],
        'invitation': groupData['invitation'],
      };
    });
    _groupData();
  }

  Future<void> checkValid() async {
    if (groupData['name'] == '' ||
        groupData['type'] == '' ||
        groupData['des'] == '') {
      setState(() {
        _isErr = true;
      });
    }
  }

  Future<void> _createGroup() async {
    _isErr = false;
    if (groupData['name'] == '' ||
        groupData['type'] == '' ||
        groupData['des'] == '') {
      setState(() {
        _isErr = true;
      });
    } else {
      setState(() {
        _isErr = false;
      });
    }
  }

  Future<void> _createGroupData() async {
    final group = Provider.of<GroupProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await group
        .createGroup(
      Group(
        gid: groupData['gid'],
        user_uid: user.loginUser,
        name: groupData['name'],
        type: groupData['type'],
        des: groupData['des'],
        latitude: groupData['latitude'],
        longtitude: groupData['longitude'],
        imgUrl: groupData['imgUrl'],
      ),
    )
        .then((value) async {
      final number = groupData['invitation'] as List<dynamic>;
      List<Map<String, dynamic>> sendData = [];
      number.forEach((element) {
        sendData.add({
          'user_uid': element,
          'logsygroup_gid': value,
          'status': 'invited'
        });
      });
      await group.createGroupInvite(sendData);
    });
  }

  Map<String, dynamic> _groupData() {
    return groupData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      color: page >= 1 ? Colors.teal : Colors.teal[200],
                      height: 5),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                      color: page >= 2 ? Colors.teal : Colors.teal[200],
                      height: 5),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          page == 1
              ? Group1Item(_changePage, _groupData)
              : Group2Item(
                  groupData: _groupData,
                  backPage: _backPage,
                  done: (value) {
                    groupData = {
                      'gid': groupData['user_uid'],
                      'user_uid': groupData['user_uid'],
                      'name': groupData['name'],
                      'type': value['type'],
                      'des': value['des'],
                      'latitude': value['latitude'],
                      'longitude': value['longitude'],
                      'imgUrl': groupData['imgUrl'],
                      'invitation': groupData['invitation'],
                    };
                    print(groupData);
                    _createGroup().then((_) {
                      _isErr
                          ? showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  content: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Icon(Icons.close)),
                                          ],
                                        ),
                                        Image.asset("assets/Popup/racism.png",
                                            width: 90, height: 90),
                                        SizedBox(height: 20),
                                        Text("Noo!!",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 20),
                                        Text('The party is ending!',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Text('Information incorrect',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        SizedBox(height: 20),
                                        ButtonTheme(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: RaisedButton(
                                            child: Text('Try Again',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            color: Colors.red,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  content: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Icon(Icons.close)),
                                          ],
                                        ),
                                        Image.asset("assets/Popup/garland.png",
                                            width: 90, height: 90),
                                        SizedBox(height: 20),
                                        Text("Hallelujah!!",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 20),
                                        Text('The party room is ready!',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Text('Continue to create',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)),
                                        Text('${groupData['name']}',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12)),
                                        SizedBox(height: 20),
                                        ButtonTheme(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: RaisedButton(
                                            child: Text('Continue',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            color: Colors.green,
                                            onPressed: () {
                                              _createGroupData();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    });
                  },
                ),
        ],
      ),
    );
  }
}
