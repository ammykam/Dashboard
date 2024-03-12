import 'package:flutter/material.dart';

class ChatInviOwner extends StatelessWidget {
  final String msg;

  ChatInviOwner(this.msg);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("Invitation",
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("You've sent an invitation to join",
                        style: TextStyle(color: Colors.teal)),
                    Text(msg,
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold)),
                    Text("private Group",
                        style: TextStyle(color: Colors.teal, fontSize: 12)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            CircleAvatar(
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
