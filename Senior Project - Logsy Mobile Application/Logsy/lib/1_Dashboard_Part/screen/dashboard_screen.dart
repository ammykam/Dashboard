import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/1_Dashboard_Part/provider/analyticsMsg.dart';
import 'package:logsy_app/1_Dashboard_Part/screen/lifestyle_summary.dart';
import 'package:logsy_app/1_Dashboard_Part/widget/badge_card.dart';
import 'package:logsy_app/3_Record_Part/provider/lifeStyle.dart';
import 'package:logsy_app/4_Community_Part/provider/badges.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/profile_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widget/data_card.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/record';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String time = "";
  bool _isInit = true;
  bool _isLoading = false;
  var user;
  User person;
  Badge currentBadge;
  LifeStyle lifeStyle;
  AnalyticsMsg analyticsMsg;
  final controller = PageController(viewportFraction: 0.8);
  DateTime startDateLifeStyle;
  DateTime endDateLifeStyle;

  List<int> _ran = [0, 1];
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
  List<String> _encourageSleep = [
    "Stick to a sleep schedule",
    "Pay attention to what you eat and drink",
    "Create a restful environment",
    "Limit daytime naps",
    "Include physical activity in your daily routine",
    "Manage worries"
  ];
  List<String> _encourageExer = [
    "Remember to warm-up",
    "Include strength training",
    "Include carbs in a pre-workout snack",
    "Focus on hydration",
    "Make sleep a priority",
    "Train with a friend",
    "Include protein and healthy fats in your meals",
    "Listen to your body",
    "Allow time to rest",
    "Be consistent",
    "Add some motivating workout music",
    "Make exercise a priority — no excuses",
  ];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      user = Provider.of<UserProvider>(context, listen: false);

      final lifestyle = Provider.of<LifeStyleProvider>(context, listen: false);
      final analytics =
          Provider.of<AnalyticsMsgProvider>(context, listen: false);
      DateTime now = DateTime.now();
      startDateLifeStyle = now.weekday == 7
          ? now.subtract(Duration(days: 7))
          : now
              .subtract(Duration(days: now.weekday))
              .subtract(Duration(days: 7));
      endDateLifeStyle = now.weekday == 7
          ? now.add(Duration(days: 6)).subtract(Duration(days: 7))
          : now
              .subtract(Duration(days: now.weekday - 6))
              .subtract(Duration(days: 7));

      //of last week

      if (DateFormat("EEEE").format(DateTime.now()) == "Sunday") {
        await lifestyle
            .getLifeStyle(user.loginUser, startDateLifeStyle, endDateLifeStyle)
            .then((value) {
          lifeStyle = value;
        });
      }

      await analytics
          .getDashboardMessage(user.loginUser, startDateLifeStyle)
          .then((value) {
        if (value == null) {
          analyticsMsg = AnalyticsMsg(uid: 0);
        } else {
          analyticsMsg = value;
        }
      });

      await user.getUser(user.loginUser).then(
        (value) {
          _isLoading = false;
          person = value;
        },
      );
      final hour = DateTime.now().hour;
      if (hour < 12) {
        time = "Good Morning";
      } else if (hour < 18) {
        time = "Good Afternoon";
      } else {
        time = "Good Evening";
      }
      setState(() {});
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void fetchAndSetData() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.getUser(user.loginUser).then(
      (value) {
        setState(() {
          person = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int show = _ran[Random().nextInt(_ran.length)];
    String sleep = _encourageSleep[Random().nextInt(_encourageSleep.length)];
    String exercise = _encourageExer[Random().nextInt(_encourageExer.length)];
    String food = _encourageFood[Random().nextInt(_encourageFood.length)];

    return Scaffold(
      body: analyticsMsg == null || person == null
          ? LinearProgressIndicator(
              color: Colors.teal[200],
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/Dashboard.png"),
                  fit: BoxFit.fitHeight,
                ),
                color: Color.fromRGBO(236, 234, 208, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    flexibleSpace: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          left: MediaQuery.of(context).size.height * 0.05,
                          right: MediaQuery.of(context).size.height * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ProfileScreen.routeName,
                                  arguments: [
                                    person.uid,
                                    "Owner"
                                  ]).then((value) {
                                fetchAndSetData();
                              });
                            },
                            child: Material(
                              shape: CircleBorder(),
                              elevation: 4.0,
                              child: Container(
                                width: 80,
                                height: 80,
                                margin: EdgeInsets.only(bottom: 0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/avatar/${person.imgUrl}"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                time == "" ? "" : "${time}, ",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                person == null ? "" : "${person.firstName}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromRGBO(151, 112, 213, 1),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " !",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            'Today is ${DateFormat('dd MMMM yyyy').format(DateTime.now())}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                     
                        child: PageView(
                          controller: controller,
                          children: [
                            DataCard(analyticsMsg, "Eat", startDateLifeStyle,
                                endDateLifeStyle, show, food),
                            DataCard(analyticsMsg, "Sleep", startDateLifeStyle,
                                endDateLifeStyle, show, sleep),
                            DataCard(
                                analyticsMsg,
                                "Exercise",
                                startDateLifeStyle,
                                endDateLifeStyle,
                                show,
                                exercise),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: 3,
                          effect: WormEffect(
                              dotWidth: 8,
                              dotHeight: 8,
                              dotColor: Colors.grey[400],
                              activeDotColor: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}




