import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:logsy_app/2_Plan_Part/screen/plan_screen.dart';
import 'package:logsy_app/3_Record_Part/screen/record_screen.dart';
import 'package:logsy_app/3_Record_Part/widget/record_modal.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart' as u;
import 'package:logsy_app/4_Community_Part/screen/community_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import '5_Notification_Part/screen/notification_part.dart';

import '1_Dashboard_Part/screen/dashboard_screen.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  Map<int, Widget> change;
  int _selectedIndex = 0;
  List<int> _ran = [0, 1];
  bool _isInit = true;
  bool _loadUser = false;

  List<String> _encourageFood = [
    "Eating healthy is good for your health!",
    "Eat fast food less often. When you visit a fast food restaurant, try the healthful options offered",
    "Eat at least 5 fruits and vegetables a day",
    "Drink 0 sugar-sweetened drinks.",
    "Replace soda pop, sports drinks, and even 100 percent fruit juice with milk or water.",
    "Eat more fish, including a portion of oily fish",
    "Eat lots of fruit and veg",
    "Cut down on saturated fat and sugar",
    "Eat less salt: no more than 6g a day for adults",
    "Do not get thirsty",
    "Do not skip breakfast",
    "Add Greek Yogurt to Your Diet",
    "Eat Eggs, Preferably for Breakfast",
    "Increase Your Protein Intake",
    "Drink Enough Water",
    "Replace Your Favorite “Fast Food” Restaurant",
    "Try at Least One New Healthy Recipe Per Week",
    "Eat Your Greens First",
    "Eat Your Fruits Instead of Drinking Them",
  ];

  @override
  void initState() {
    change = {
      0: DashboardScreen(),
      1: PlanScreen(),
      // 2: RecordScreen(),
      3: CommunityScreen(),
      4: NotificationScreen()
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String food = _encourageFood[Random().nextInt(_encourageFood.length)];
    int _show = _ran[Random().nextInt(_ran.length)];
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //1
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: Icon(
                        Icons.dashboard,
                        color: _selectedIndex == 0
                            ? Colors.teal[500]
                            : Colors.teal[200],
                      ),
                    ),
                    //2
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: _selectedIndex == 1
                          ? Image.asset("assets/food2.png",
                              width: 25, height: 25)
                          : Image.asset("assets/food1.png",
                              width: 25, height: 25),
                    ),
                    // 3
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            barrierColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            context: context,
                            builder: (builder) {
                              return RecordModal();
                            });
                        _show == 1
                            ? showOverlayNotification((context) {
                                return Column(
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: ListTile(
                                          title: Text(
                                            'Eating Food?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(food),
                                          trailing: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                OverlaySupportEntry.of(context)
                                                    .dismiss();
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }, duration: Duration(milliseconds: 4000))
                            : Container();
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.teal[500],
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    //4
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
                      child: Icon(
                        Icons.people,
                        color: _selectedIndex == 3
                            ? Colors.teal[500]
                            : Colors.teal[200],
                      ),
                    ),
                    //5
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 4;
                        });
                      },
                      child: Icon(
                        Icons.notifications,
                        color: _selectedIndex == 4
                            ? Colors.teal[500]
                            : Colors.teal[200],
                      ),
                    )
                  ],
                ),
              ),
      ),
      body: Container(
        child: change[_selectedIndex],
      ),
    );
  }
}
