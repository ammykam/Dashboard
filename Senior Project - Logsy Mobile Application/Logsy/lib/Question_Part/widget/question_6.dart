import 'package:flutter/material.dart';
import 'package:logsy_app/Question_Part/widget/question_6_item.dart';

class Question6 extends StatelessWidget {
  final List<String> goal = [
    "Keto",
    "Circuit Training",
    "IF",
    "People",
    "Jogging",
  ];
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
                  "Step 6/6",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 50,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    "Choose five categories that represent what you want to see",
                    softWrap: true,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: goal.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 5 / 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, i) => Question6Item(goal[i]),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
