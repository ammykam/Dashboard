import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/widget/friend_circle_item.dart';
import 'package:provider/provider.dart';

class Group1Item extends StatefulWidget {
  final Function changePage;
  final Function groupData;
  Group1Item(this.changePage, this.groupData);

  @override
  _Group1ItemState createState() => _Group1ItemState();
}

class _Group1ItemState extends State<Group1Item> {
  var _isInit = true;
  var _isLoading = false;
  List<dynamic> friends;
  final _form = GlobalKey<FormState>();
  Map<String, dynamic> _info = {
    "name": "",
    "invitation": [],
  };
  int _select = 0;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final user = Provider.of<UserProvider>(context, listen: false);
      await user.userFriend(user.loginUser).then((value) {
        setState(() {
          friends = value as List<dynamic>;
        });
      });

      // if (widget.groupData()['category'] == "Eat") {
      //   _select = 1;
      // } else if (widget.groupData()['category'] == "Sleep") {
      //   _select = 2;
      // } else if (widget.groupData()['category'] == "Exercise") {
      //   _select = 3;
      // } else {
      //   _select = 0;
      // }
      setState(() {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void updateInfo(Map<String, dynamic> data) {
    if (_info['invitation'].contains(data['uid'])) {
      _info['invitation'].remove(data['uid']);
    } else {
      _info['invitation'].add(data['uid']);
    }
  }

  void _saveForm() async {
    _form.currentState.save();
    widget.changePage(_info);
  }

  @override
  Widget build(BuildContext context) {
    return friends == null
        ? Center(child: CircularProgressIndicator())
        : Form(
            key: _form,
            child: Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Text(
                          "Create a Group",
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                            "This is where you will create a new group to meet up with new people! and do some challenge.",
                            style: TextStyle(
                              color: Colors.teal[400],
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center),
                        SizedBox(height: 40),
                        Container(
                          child: TextFormField(
                            initialValue: widget.groupData()['name'],
                            onSaved: (value) {
                              _info = {
                                "name": value,
                                "invitation": _info['invitation'],
                              };
                            },
                            style: TextStyle(
                              color: Colors.teal,
                            ),
                            cursorColor: Colors.teal,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Group Name",
                              labelStyle: TextStyle(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.teal[300],
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "SEND INVITATION TO",
                            style: TextStyle(
                                color: Colors.teal[400], fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      // width: double.infinity,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 15,
                        runSpacing: 5,
                        children: List.generate(
                            friends.length,
                            (index) => FriendCircleItem(friends[index],
                                updateInfo, widget.groupData()['invitation'])),
                      ),
                    ),
                  ),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: friends
                  //         .map(
                  //           (e) => FriendCircleItem(e, updateInfo,
                  //               widget.groupData()['invitation']),
                  //         )
                  //         .toList(),
                  //   ),
                  // ),
                  //SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 20.0, vertical: 10),
                  //   child: Container(
                  //     width: double.infinity,
                  //     child: Text(
                  //       "CATEGORY",
                  //       style: TextStyle(color: Colors.teal, fontSize: 12),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //   child: Row(
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             _select = 1;
                  //             _info = {
                  //               "name": _info["name"],
                  //               "invitation": _info['invitation'],
                  //               "category": "Eat",
                  //             };
                  //           });
                  //         },
                  //         child: Container(
                  //           width: MediaQuery.of(context).size.width * 0.2,
                  //           height: MediaQuery.of(context).size.width * 0.1,
                  //           decoration: BoxDecoration(
                  //             border: Border.all(color: Colors.teal),
                  //             color: _select == 1 ? Colors.teal : Colors.white,
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               "Eat",
                  //               style: TextStyle(
                  //                   color: _select == 1
                  //                       ? Colors.white
                  //                       : Colors.teal),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(width: 10),
                  //       GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             _select = 2;
                  //             _info = {
                  //               "name": _info["name"],
                  //               "invitation": _info['invitation'],
                  //               "category": "Sleep",
                  //             };
                  //           });
                  //         },
                  //         child: Container(
                  //           width: MediaQuery.of(context).size.width * 0.2,
                  //           height: MediaQuery.of(context).size.width * 0.1,
                  //           decoration: BoxDecoration(
                  //             border: Border.all(color: Colors.teal),
                  //             color: _select == 2 ? Colors.teal : Colors.white,
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               "Sleep",
                  //               style: TextStyle(
                  //                   color: _select == 2
                  //                       ? Colors.white
                  //                       : Colors.teal),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(width: 10),
                  //       GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             _select = 3;
                  //             _info = {
                  //               "name": _info["name"],
                  //               "invitation": _info['invitation'],
                  //               "category": "Exercise",
                  //             };
                  //           });
                  //         },
                  //         child: Container(
                  //           width: MediaQuery.of(context).size.width * 0.2,
                  //           height: MediaQuery.of(context).size.width * 0.1,
                  //           decoration: BoxDecoration(
                  //             border: Border.all(color: Colors.teal),
                  //             color: _select == 3 ? Colors.teal : Colors.white,
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               "Exercise",
                  //               style: TextStyle(
                  //                   color: _select == 3
                  //                       ? Colors.white
                  //                       : Colors.teal),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            _saveForm();
                          },
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
