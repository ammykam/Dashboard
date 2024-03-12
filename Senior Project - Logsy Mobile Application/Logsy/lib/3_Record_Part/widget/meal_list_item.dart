import 'package:flutter/material.dart';
import 'package:logsy_app/3_Record_Part/provider/food.dart';
import 'package:logsy_app/3_Record_Part/provider/foodRecord.dart';
import 'package:logsy_app/3_Record_Part/screen/food_detail_screen.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class MealListItem extends StatefulWidget {
  final Food food;
  final String title;

  MealListItem(this.food, this.title);

  @override
  _MealListItemState createState() => _MealListItemState();
}

class _MealListItemState extends State<MealListItem> {
  String img;
  Future<void> _addRecord() async {
    final foodRecord = Provider.of<FoodRecordProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    await foodRecord.addFoodRecord(
      FoodRecord(
          foodRecID: 0,
          user_uid: user.loginUser,
          food_fid: widget.food.fid,
          timestamp: DateTime.now(),
          type: widget.title.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == "Snack") {
      img = "snack";
    } else if (widget.title == "Breakfast") {
      img = "breakfast";
    } else if (widget.title == "Lunch") {
      img = "lunch-box";
    } else if (widget.title == "Dinner") {
      img = "wedding-dinner";
    }
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(FoodDetailScreen.routeName,
                arguments: [widget.food, widget.title]);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.food.verified == 1
                  ? CircleAvatar(
                      backgroundImage: AssetImage("assets/verified.png"),
                      radius: 10,
                    )
                  : CircleAvatar(
                      backgroundImage: AssetImage("assets/verifiedGrey.png"),
                      radius: 10,
                    ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.food.name,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: MediaQuery.of(context).size.height * 0.02),
                ),
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.height * 0.003,
                height: MediaQuery.of(context).size.height * 0.03,
                child: RaisedButton(
                    onPressed: () {
                      _addRecord().then((value) {
                        showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              content: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                        'Your ${widget.title.toLowerCase()} is ready!',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15)),
                                    Text('Continue to eat ',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15)),
                                    Text(
                                      "\"${widget.food.name}" "\"",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),
                                    ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: RaisedButton(
                                        child: Text('Continue',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "EAT",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.015),
                    ),
                    color: Colors.teal[400]),
              ),
            ],
          ),
        ));
  }
}
