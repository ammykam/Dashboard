import 'package:flutter/material.dart';

class ChatInviSender extends StatefulWidget {
  final String msg;

  ChatInviSender(this.msg);

  @override
  _ChatInviSenderState createState() => _ChatInviSenderState();
}

class _ChatInviSenderState extends State<ChatInviSender> {
  bool status;

  @override
  Widget build(BuildContext context) {
    return status != null
        ? Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.teal[400],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: status
                          ? Column(
                              children: [
                                Text(
                                  "Congratulations",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text("You have joined",
                                    style: TextStyle(color: Colors.white)),
                                Text(widget.msg,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text("private Group",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              ],
                            )
                          : Column(
                              children: [
                                Text("You have declined",
                                    style: TextStyle(color: Colors.white)),
                                Text(widget.msg,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text("private Group",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          )
        : Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.teal[400],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text("Invitation",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("You've got an invitation to join",
                              style: TextStyle(color: Colors.white)),
                          Text(widget.msg,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text("private Group",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      status = true;
                                    });
                                  },
                                  child: Text(
                                    "ACCEPT",
                                    style: TextStyle(
                                      color: Colors.teal,
                                    ),
                                  ),
                                  color: Colors.white),
                              SizedBox(width: 10),
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      status = false;
                                    });
                                  },
                                  child: Text(
                                    "DECLINE",
                                    style: TextStyle(
                                      color: Colors.teal,
                                    ),
                                  ),
                                  color: Colors.white),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          );
  }
}
