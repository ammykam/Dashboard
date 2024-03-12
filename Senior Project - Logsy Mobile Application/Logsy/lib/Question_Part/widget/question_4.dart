import 'package:flutter/material.dart';

class Question4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Form(
        child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Step 4/6",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 50,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "What is your goal?",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
