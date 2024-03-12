import 'package:flutter/material.dart';

class ExerciseItem extends StatelessWidget {
  final String name;
  final String select;

  ExerciseItem(this.name, this.select);
  @override
  Widget build(BuildContext context) {
    return select == name
        ? Container(
          decoration: BoxDecoration (
                color: Colors.teal[200]
            ),
          child: ListTile(
              title: Text(name),
              
            ),
        )
        : ListTile(
            title: Text(name),
          );
  }
}
