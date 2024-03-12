import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/post.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class ReportSheet extends StatefulWidget {
  final Post post;
  final User user;
  final Function report;

  ReportSheet(this.post, this.user, this.report);
  @override
  _ReportSheetState createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  bool _isInit = true;

  int _selectReport = 0;
  String _value = "";
  String _value2 = "";
  String _value2Reason = "";

  Widget _tile(Icon icon, String text1, String text2, int select) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: Row(
        children: [
          icon,
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text1,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(text2, style: TextStyle(fontSize: 11))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cancel(String text) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
        padding: EdgeInsets.all(15),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }

  Future<void> _reportPost(String reason) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.postReport(
        user.loginUser,
        Report(
            uid: user.loginUser,
            type: 'report post',
            reason: reason,
            note: {
              'uid': widget.post.user_uid,
              'gid': widget.post.group_gid,
              'timestamp': widget.post.timestamp
            },
            datetime: DateTime.now()));
  }

  Widget _submitPost(String reason) {
    return _value == ""
        ? Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text("Submit", style: TextStyle(color: Colors.grey[400])),
            ),
          )
        : GestureDetector(
            onTap: () {
              _reportPost(reason);
              setState(() {
                _selectReport = 4;
              });
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text("Submit"),
              ),
            ),
          );
  }

  Future<void> _hidePost() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.postHidePost(user.loginUser, widget.post.user_uid,
        widget.post.group_gid, widget.post.timestamp);
    widget.report('hide');
  }

  Future<void> _reportUser(String type, String reason) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.postReport(
        user.loginUser,
        Report(
            uid: user.loginUser,
            type: 'report user',
            reason: reason,
            note: {
              'uid': widget.post.user_uid,
              'gid': widget.post.group_gid,
              'timestamp': widget.post.timestamp
            },
            datetime: DateTime.now()));
    if (type == "unfriend") {
      await user.deleteFriendRequest(user.loginUser, widget.post.user_uid);
       widget.report('unfriend');
    } else if (type == "block") {
      await user.updateBlock(
          user.loginUser, widget.post.user_uid, DateTime.now());
       widget.report('block');
    }
  }

  Widget _submitReport(String type, String reason) {
    return _value2 == "" || _value2Reason == ""
        ? Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
            padding: EdgeInsets.all(15),
            //height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Text("Submit", style: TextStyle(color: Colors.grey[400])),
            ),
          )
        : GestureDetector(
            onTap: () async {
              await _reportUser(type, reason).then((value) => setState(() {
                    _selectReport = 4;
                  }));
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
              padding: EdgeInsets.all(15),
              //height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Text("Submit"),
              ),
            ),
          );
  }

  Widget _rowRadio(String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.all(10),
          child: Radio(
            fillColor: MaterialStateProperty.all(Colors.grey[600]),
            value: text,
            groupValue: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Widget _rowRadio2(String text, String subtext, String type) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 15),
          child: Radio(
            fillColor: MaterialStateProperty.all(Colors.grey[600]),
            value: type,
            groupValue: _value2,
            onChanged: (value) {
              setState(() {
                _value2 = value;
              });
            },
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              Text(subtext,
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]))
            ],
          ),
        ),
      ],
    );
  }

  Widget _rowRadio3(String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.all(10),
          child: Radio(
            fillColor: MaterialStateProperty.all(Colors.grey[600]),
            value: text,
            groupValue: _value2Reason,
            onChanged: (value) {
              setState(() {
                _value2Reason = value;
              });
            },
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Widget _completePage(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Icon(Icons.check_circle, size: 60)
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.transparent,
        ),
        _cancel("Close")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _selectReport == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                margin:
                    EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
                padding: EdgeInsets.all(15),
                //height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectReport = 1;
                        });
                      },
                      child: _tile(
                          Icon(Icons.flag, size: 30),
                          "Report this post",
                          "This post is offensive or the account is hacked.",
                          1),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () async {
                        await _hidePost().then((value) => setState(() {
                              _selectReport = 2;
                            }));
                      },
                      child: _tile(
                          Icon(Icons.hide_source, size: 30),
                          "Hide post",
                          "Let us know why you don't want to see this post.",
                          2),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectReport = 3;
                        });
                      },
                      child: _tile(Icon(Icons.cancel, size: 30), "Report user",
                          "Block and stop seeing posts from this user.", 3),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.transparent,
              ),
              _cancel("Cancel")
            ],
          )
        : _selectReport == 1
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    margin: EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 5),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Why are you reporting this post?",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        _rowRadio("It's annoying or not interesting."),
                        _rowRadio("I think it should not be on Logsy."),
                        _rowRadio("It is a spam."),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.transparent,
                  ),
                  _submitPost(_value)
                ],
              )
            : _selectReport == 2
                ? _completePage("You will no longer see this post.")
                : _selectReport == 3
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            margin: EdgeInsets.only(
                                top: 15, left: 15, right: 15, bottom: 5),
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Report and/or Block This Person",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                _rowRadio2(
                                    "Unfriend ${widget.user.firstName}",
                                    "${widget.user.firstName} will no longer be your friend.",
                                    "unfriend"),
                                SizedBox(height: 8),
                                _rowRadio2(
                                    "Block ${widget.user.firstName}",
                                    "You and ${widget.user.firstName} won't be able to see each other post and no longer friend.",
                                    "block"),
                                SizedBox(height: 15),
                                Text(
                                  "Why are you reporting this person?",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                _rowRadio3(
                                    "This profile is pretending to be someone or is fake."),
                                _rowRadio3(
                                    "This person is harrassing or bullying me."),
                                _rowRadio3("This person is annoying me.")
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.transparent,
                          ),
                          _submitReport(_value2, _value2Reason)
                        ],
                      )
                    : _completePage("The report has been sent to Logsy team.");
  }
}
