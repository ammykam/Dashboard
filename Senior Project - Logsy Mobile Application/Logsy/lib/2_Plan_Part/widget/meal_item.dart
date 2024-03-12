import 'package:flutter/material.dart';
import 'package:logsy_app/3_Record_Part/screen/food_detail_screen.dart';
import './water_item.dart';
import "dart:math";

class MealItem extends StatefulWidget {
  final String title;
  final DateTime date;

  MealItem(this.title, this.date);

  @override
  _MealItemState createState() => _MealItemState();
}

class _MealItemState extends State<MealItem> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> meal = [
      {
        'name': 'Caesar Salad',
        'nutrients': '400 cal | 30 carb | 17 protein | 8 fat',
        'location': 'iCanteen',
      },
      {
        'name': 'Spaghetti',
        'nutrients': '400 cal | 30 carb | 17 protein | 8 fat',
        'location': 'Siam Paragon',
      },
      {
        'name': 'Noodles',
        'nutrients': '400 cal | 30 carb | 17 protein | 8 fat',
        'location': 'Arts Canteen',
      },
      {
        'name': 'Tom Yum',
        'nutrients': '400 cal | 30 carb | 17 protein | 8 fat',
        'location': 'Siam Square',
      }
    ];

    Map<String, String> the_meal = meal[Random().nextInt(meal.length)];

    return Padding(
      padding: EdgeInsets.all(10),
      child: widget.title == "WATER"
          ? WaterItem()
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(color: Colors.amber, thickness: 2.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(FoodDetailScreen.routeName,
                        arguments: [the_meal, widget.title, meal]);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height * 0.15,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.blueGrey[100]),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.105,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.height * 0.27,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      the_meal['name'],
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      textAlign: TextAlign.left,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          the_meal = meal[
                                              Random().nextInt(meal.length)];
                                        });
                                      },
                                      child: Icon(Icons.refresh,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.025,
                                          color: Colors.blueGrey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                the_meal['nutrients'],
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.height * 0.27,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: Colors.teal[200],
                                    ),
                                    Text(
                                      the_meal['location'],
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.015),
                                      textAlign: TextAlign.left,
                                    ),
                                    Expanded(child: Text("")),
                                    ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.height *
                                              0.003,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                      child: RaisedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Icon(Icons.thumb_up,
                                                      size: 120,
                                                      color: Colors.teal),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text('You have eaten',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .teal)),
                                                        Text(the_meal['name'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .teal)),
                                                        Text(
                                                            'for ${widget.title.toLowerCase()}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .teal)),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    RaisedButton(
                                                      child: Text('OK',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.teal)),
                                                      color: Colors.teal[100],
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            "EAT",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.015),
                                          ),
                                          color: Colors.amber[400]),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
