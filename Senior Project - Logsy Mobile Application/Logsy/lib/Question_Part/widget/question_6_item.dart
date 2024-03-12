import 'package:flutter/material.dart';

class Question6Item extends StatefulWidget {
  final String goal;

  Question6Item(this.goal);

  @override
  _Question6ItemState createState() => _Question6ItemState();
}

class _Question6ItemState extends State<Question6Item> {
  Color color;
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          setState(
            () {
              if (color == Colors.blue[100]) {
                color = Colors.white;
              } else {
                color = Colors.blue[100];
              }
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.blue),
            color: color,
          ),
          child: Center(
            child: Text(
              widget.goal,
              style: TextStyle(fontSize: 17, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
