import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/post.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class TopCommunity extends StatefulWidget {
  final int gid;
  final Function parentAction;

  TopCommunity({this.gid, this.parentAction});
  @override
  _TopCommunityState createState() => _TopCommunityState();
}

class _TopCommunityState extends State<TopCommunity> {
  var _isInit = true;
  var _isLoading = false;
  var user;
  User person;
  final _form = GlobalKey<FormState>();
  var msgController = TextEditingController();
  Map<String, dynamic> _info = {
    'pid': 0,
    'user_uid': 0,
    'group_gid': 0,
    'content': '',
    'imgUrl': '',
    'timestamp': '',
  };

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      user = Provider.of<UserProvider>(context, listen: false);
      await user.getUser(user.loginUser).then(
        (value) {
          setState(() {
            _isLoading = false;
            person = value as User;
          });
        },
      );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() async {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final post = Provider.of<PostProvider>(context, listen: false);

    await post
        .createPost(Post(
            pid: _info['pid'],
            user_uid: _info['user_uid'],
            group_gid: _info['group_gid'],
            content: _info['content'],
            imgUrl: _info['imgUrl'],
            timestamp: _info['timestamp']))
        .then((value) {
      setState(() {
        msgController.clear();
        widget.parentAction();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    return person == null
        ? Container()
        : Form(
            key: _form,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/avatar/${person.imgUrl}'),
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              maxLines: null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: msgController,
                              onFieldSubmitted: (value) {
                                setState(() {
                                  _info = {
                                    'pid': 0,
                                    'user_uid': user.loginUser,
                                    'group_gid': widget.gid,
                                    'content': value,
                                    'imgUrl': _info['imgUrl'],
                                    'timestamp': DateTime.now(),
                                  };

                                  _saveForm();
                                });
                              },
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                              cursorColor: Colors.teal,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Write something...",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                labelStyle: TextStyle(color: Colors.teal),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonTheme(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minWidth: MediaQuery.of(context).size.width * 0.02,
                        height: MediaQuery.of(context).size.height * 0.035,
                        child: FlatButton(
                          color: Colors.teal,
                          onPressed: () {
                            setState(() {
                              _info = {
                                'pid': 0,
                                'user_uid': user.loginUser,
                                'group_gid': widget.gid,
                                'content': msgController.text,
                                'imgUrl': _info['imgUrl'],
                                'timestamp': DateTime.now(),
                              };
                              _saveForm();
                            });
                          },
                          child: Text(
                            'Post',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 20)
                    ],
                  )
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         height: MediaQuery.of(context).size.height * 0.04,
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.teal[100]),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Icon(Icons.picture_in_picture,
                  //                 color: Colors.teal[200], size: 20),
                  //             SizedBox(width: 5),
                  //             Text("Photo",
                  //                 style: TextStyle(color: Colors.teal[200])),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         height: MediaQuery.of(context).size.height * 0.04,
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.teal[100]),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Icon(Icons.photo_camera,
                  //                 color: Colors.teal[200], size: 20),
                  //             SizedBox(width: 5),
                  //             Text("Camera",
                  //                 style: TextStyle(color: Colors.teal[200])),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         height: MediaQuery.of(context).size.height * 0.04,
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.teal[100]),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Icon(Icons.location_pin,
                  //                 color: Colors.teal[200], size: 20),
                  //             SizedBox(width: 5),
                  //             Text(
                  //               "Location",
                  //               style: TextStyle(color: Colors.teal[200]),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          );
  }
}
