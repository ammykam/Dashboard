import 'package:flutter/material.dart';

class GlassItem extends StatefulWidget {
  @override
  _GlassItemState createState() => _GlassItemState();
}

class _GlassItemState extends State<GlassItem> {
  String name = "empty";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          name = "full";
        });
      },
      child: Image.asset(
        'assets/$name.png',
        height: 50,
      ),
    );
  }
}
