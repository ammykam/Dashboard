import 'package:flutter/material.dart';

class Question2 extends StatefulWidget {
  @override
  _Question2State createState() => _Question2State();
}

class _Question2State extends State<Question2> {
  Color color1;
  Color color2;
  Color color3;
  String selectChoice;

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
                "Step 2/6",
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
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    color1=Colors.blue[100];
                    color2=Colors.white;
                    color3=Colors.white;
                    selectChoice="Lose Weight";
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.blue),
                    color: color1,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Lose Weight",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    color1=Colors.white;
                    color2=Colors.blue[100];
                    color3=Colors.white;
                    selectChoice="Maintain Weight";
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.blue),
                    color: color2,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Maintain Weight",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    color1=Colors.white;
                    color2=Colors.white;
                    color3=Colors.blue[100];
                    selectChoice="Gain Weight";
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.blue),
                    color: color3,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Gain Weight",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
