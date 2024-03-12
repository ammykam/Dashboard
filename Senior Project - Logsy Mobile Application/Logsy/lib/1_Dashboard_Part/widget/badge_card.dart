import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/badges.dart';

class BadgeCard extends StatefulWidget {
  final Badge badge;

  BadgeCard({this.badge});
  @override
  _BadgeCardState createState() => _BadgeCardState();
}

class _BadgeCardState extends State<BadgeCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.18, left: 20, right: 20),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4.0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.43,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[50],
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.amber[300],
                            Colors.red,
                            Colors.purple[300],
                          ],
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: Text(
                          "Congratulations!",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    
                      Image.asset("assets/Badge/${widget.badge.imgUrl}", height: 100, width: 100),
                      Text(
                        widget.badge.name,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.badge.des,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height:5)
      ],
    );
  }
}
