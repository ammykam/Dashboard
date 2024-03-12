import 'package:flutter/material.dart';
import 'package:logsy_app/1_Dashboard_Part/widget/eat_item.dart';
import "dart:math";

import 'package:logsy_app/3_Record_Part/provider/food.dart';
import 'package:logsy_app/3_Record_Part/provider/foodRecord.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class FoodDetailScreen extends StatefulWidget {
  static const routeName = "/food-detail";

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  Food food;
  String title;
  String img;
  DailyIntake _userIntake;
  var _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final meal = ModalRoute.of(context).settings.arguments as List;
      final user = Provider.of<UserProvider>(context, listen: false);

      await user.getDailyIntakes(user.loginUser).then((value) {
        setState(() {
          _userIntake = value;
        });
      });
      //extract
      food = meal[0] as Food;
      title = meal[1] as String;
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _addRecord() async {
    final foodRecord = Provider.of<FoodRecordProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await foodRecord.addFoodRecord(
      FoodRecord(
          foodRecID: 0,
          user_uid: user.loginUser,
          food_fid: food.fid,
          timestamp: DateTime.now(),
          type: title.toLowerCase()),
    );
  }

  Widget _circle(int foodDetail, int userDetail, Color color1, Color color2,
      String img, String name, String unit) {
    return Row(
      children: [
        CircularPercentIndicator(
          radius: 50,
          lineWidth: 6.0,
          animation: true,
          percent: foodDetail.toDouble() / userDetail.toDouble(),
          animationDuration: 1200,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: color1,
          progressColor: color2,
          center: Image.asset(img, width: 20, height: 20),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${((foodDetail.toDouble() / userDetail.toDouble()) * 100).ceil()}%",
              style: TextStyle(color: color2, fontWeight: FontWeight.bold),
            ),
            Text(name,
                style: TextStyle(color: color2, fontWeight: FontWeight.bold)),
            Text("${foodDetail.toString()} ${unit}")
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (title == "Snack") {
      img = "snack";
    } else if (title == "Breakfast") {
      img = "breakfast";
    } else if (title == "Lunch") {
      img = "lunch-box";
    } else if (title == "Dinner") {
      img = "wedding-dinner";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          food == null ? "" : food.name,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.teal[500]),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.teal,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _userIntake == null || food == null
          ? LinearPercentIndicator()
          : Padding(
              padding: EdgeInsets.all(10),
              child:  Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        margin: EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(food.imgUrl),
                              fit: BoxFit.cover),
                          shape: BoxShape.rectangle,
                          color: Colors.blueGrey[100],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Nutrition Fact",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Text(
                          "Remark:  The percentage represents the portion of each nutrition fact from your daily consumption.",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 12)),
                    ),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _circle(
                                food.calories,
                                _userIntake.maxCalories,
                                Colors.blue[100],
                                Colors.blue[300],
                                "assets/calories.png",
                                "Calories",
                                "kcal"),
                            SizedBox(height: 20),
                            _circle(
                                food.carb,
                                _userIntake.maxCarb,
                                Colors.green[100],
                                Colors.green[300],
                                "assets/carb.png",
                                "Carbohydrates",
                                "g"),
                          ],
                        ),
                        SizedBox(width: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _circle(
                                food.protein,
                                _userIntake.maxProtein,
                                Colors.amber[100],
                                Colors.amber[300],
                                "assets/protein.png",
                                "Protein",
                                "g"),
                            SizedBox(height: 20),
                            _circle(
                                food.fat,
                                _userIntake.maxFat,
                                Colors.red[100],
                                Colors.red[300],
                                "assets/fats.png",
                                "Fats",
                                "g"),
                          ],
                        ),
                      ],
                    ),

                   
                    SizedBox(height: 20),
                    ButtonTheme(
                      height: 30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: FlatButton(
                        color: Colors.amber,
                        onPressed: () {
                          _addRecord().then((value) {
                            showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  content: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Icon(Icons.close)),
                                          ],
                                        ),
                                        Image.asset("assets/Popup/${img}.png",
                                            width: 90, height: 90),
                                        SizedBox(height: 20),
                                        Text("Yayy!",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 20),
                                        Text(
                                            'Your ${title.toLowerCase()} is ready!',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15)),
                                        Text('Continue to eat ',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15)),
                                        Text(
                                          "\"${food.name}" "\"",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 20),
                                        ButtonTheme(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: RaisedButton(
                                            child: Text('Continue',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            color: Colors.green,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          });
                        },
                        child: Text(
                          "Eat",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    
                  ],
                ),
           
            ),
    );
  }
}
