import 'package:flutter/material.dart';
import 'package:logsy_app/2_Plan_Part/widget/glass_item.dart';

class WaterItem extends StatefulWidget {
  @override
  _WaterItemState createState() => _WaterItemState();
}

class _WaterItemState extends State<WaterItem> {
  //create 9 objects
  int glass = 9;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          child: Text(
            "WATER",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Text(
          "Goal: 8 Glasses",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.015,
            color: Colors.teal[400],
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  glass,
                  (index) => index == glass - 1
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              glass++;
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.teal[50],
                            child: Icon(Icons.add),
                          ),
                        )
                      : GlassItem()),
            ))
      ],
    );
  }
}
