import 'package:flutter/material.dart';
import 'package:logsy_app/3_Record_Part/provider/food.dart';
import 'package:provider/provider.dart';

class EatMealDetail extends StatefulWidget {
  final String mealTime;
  final int fid;

  EatMealDetail(this.mealTime, this.fid);

  @override
  _EatMealDetailState createState() => _EatMealDetailState();
}

class _EatMealDetailState extends State<EatMealDetail> {
  bool _isInit = true;
  Food foodData;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final food = Provider.of<FoodProvider>(context, listen: false);
      await food.getFood(widget.fid).then((value) {
        setState(() {
          foodData = value;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant EatMealDetail oldWidget) {
    final food = Provider.of<FoodProvider>(context, listen: false);
    food.getFood(widget.fid).then((value) {
      setState(() {
        foodData = value;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
      child: widget.mealTime == "Water"
          ? Material(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.blue[200],
                        Colors.blue[100],
                        Colors.white
                      ],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'You drank',
                        style: TextStyle(
                            color: Colors.indigo[400],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "${widget.fid} ml.",
                        style: TextStyle(
                            color: Colors.indigo[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )
                    ],
                  )),
            )
          : Material(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                //skipped meal
                child: widget.fid == 0
                    ? IntrinsicHeight(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.mealTime,
                                  style: TextStyle(
                                      color: Colors.teal[400],
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Text(
                                    widget.mealTime == "Snack" ? "NO SNACK" :"SKIPPED MEAL",
                                    style: TextStyle(
                                        color: Colors.red[400],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    //meal
                    : foodData == null
                        ? Container()
                        : IntrinsicHeight(
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.mealTime,
                                      style: TextStyle(
                                          color: Colors.teal[400],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: 90,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(foodData
                                                        .imgUrl ==
                                                    null
                                                ? "https://img.freepik.com/free-photo/abstract-surface-textures-white-concrete-stone-wall_74190-8184.jpg?size=626&ext=jpg"
                                                : foodData.imgUrl),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        foodData.name,
                                        style:
                                            TextStyle(color: Colors.teal[400]),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(foodData.calories.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                              SizedBox(height: 7),
                                              Text("Cal",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(foodData.carb.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                              SizedBox(height: 7),
                                              Text("Carb",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(foodData.protein.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                              SizedBox(height: 7),
                                              Text("Protein",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(foodData.fat.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                              SizedBox(height: 7),
                                              Text("Fat",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12)),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ),
    );
  }
}
