import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:logsy_app/0_Login_Part/screen/create_screen.dart';
import 'package:logsy_app/0_Login_Part/screen/login_screen.dart';
import 'package:logsy_app/0_Login_Part/screen/waiting_screen.dart';
import 'package:logsy_app/2_Plan_Part/screen/history_screen.dart';
import 'package:logsy_app/3_Record_Part/provider/exercise.dart';
import 'package:logsy_app/3_Record_Part/provider/exerciseRecord.dart';
import 'package:logsy_app/3_Record_Part/provider/foodRecord.dart';
import 'package:logsy_app/3_Record_Part/provider/lifeStyle.dart';
import 'package:logsy_app/3_Record_Part/provider/sleepRecord.dart';
import 'package:logsy_app/3_Record_Part/screen/exercise_screen.dart';
import 'package:logsy_app/3_Record_Part/screen/sleep_screen.dart';
import 'package:logsy_app/3_Record_Part/screen/water_screen.dart';
import 'package:logsy_app/4_Community_Part/provider/badges.dart';
import 'package:logsy_app/4_Community_Part/provider/challenge.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/post.dart';
import 'package:logsy_app/4_Community_Part/screen/challenge_detail_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/challenge_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/create_challenge_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/invite_group_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/maps_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/scoreboard_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/setting_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/view_group_member_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
//in-app
import 'package:logsy_app/1_Dashboard_Part/screen/lifestyle_summary.dart';
import 'package:logsy_app/4_Community_Part/screen/edit_profile_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/post_screen.dart';
import 'package:logsy_app/4_Community_Part/screen/view_friend_screen.dart';
import 'package:logsy_app/5_Notification_Part/screen/friend_request.dart';
import 'package:logsy_app/5_Notification_Part/screen/group_request.dart';
import './3_Record_Part/screen/food_detail_screen.dart';
import './3_Record_Part/screen/personal_meal_screen.dart';
import './4_Community_Part/screen/create_group_screen.dart';
import './4_Community_Part/screen/group_screen.dart';
import './4_Community_Part/screen/main_chat_screen.dart';
import './4_Community_Part/screen/profile_screen.dart';
import './4_Community_Part/screen/search_screen.dart';
import './4_Community_Part/screen/sub_chat_screen.dart';
import '1_Dashboard_Part/provider/analyticsMsg.dart';
import '1_Dashboard_Part/screen/dashboard_screen.dart';
import './2_Plan_Part/screen/plan_screen.dart';
import './3_Record_Part/screen/record_screen.dart';
import './4_Community_Part/screen/community_screen.dart';
import '3_Record_Part/provider/food.dart';
import '3_Record_Part/provider/foodRequest.dart';
import '3_Record_Part/provider/restaurant.dart';
import '3_Record_Part/provider/waterRecord.dart';
import '4_Community_Part/provider/user.dart' as u;
import '5_Notification_Part/screen/notification_part.dart';
import 'package:logsy_app/tab_screen.dart';

import 'Question_Part/screen/question_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => u.UserProvider()),
        ChangeNotifierProvider(create: (ctx) => FoodProvider()),
        ChangeNotifierProvider(create: (ctx) => GroupProvider()),
        ChangeNotifierProvider(create: (ctx) => PostProvider()),
        ChangeNotifierProvider(create: (ctx) => FoodRecordProvider()),
        ChangeNotifierProvider(create: (ctx) => WaterRecordProvider()),
        // ChangeNotifierProxyProvider<u.UserProvider, WaterRecordProvider>(
        //   update: (ctx, user, previousWater) => WaterRecordProvider(user.getToken()),
        //   create: (BuildContext context) => WaterRecordProvider(null),
        // ),
        ChangeNotifierProvider(create: (ctx) => ChallengeProvider()),
        ChangeNotifierProvider(create: (ctx) => ExerciseProvider()),
        ChangeNotifierProvider(create: (ctx) => ExerciseRecordProvider()),
        ChangeNotifierProvider(create: (ctx) => RestaurantProvider()),
        ChangeNotifierProvider(create: (ctx) => FoodRequestProvider()),
        ChangeNotifierProvider(create: (ctx) => SleepRecordProvider()),
        ChangeNotifierProvider(create: (ctx) => BadgeProvider()),
        ChangeNotifierProvider(create: (ctx) => LifeStyleProvider()),
        ChangeNotifierProvider(create: (ctx) => AnalyticsMsgProvider()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Logsy',
            theme: ThemeData(
              fontFamily: 'Montserrat',
              primarySwatch: Colors.blue,
              accentColor: Colors.greenAccent,
            ),
            routes: {
              //Login
              '/': (ctx) => WaitingScreen(),
              //'/': (ctx) => LoginScreen(),
              LoginScreen.routeName: (ctx) => LoginScreen(),
              CreateScreen.routeName: (ctx) => CreateScreen(),

              QuestionScreen.routeName: (ctx) => QuestionScreen(),
              DashboardScreen.routeName: (ctx) => DashboardScreen(),

              TabScreen.routeName: (ctx) => TabScreen(),

              PlanScreen.routeName: (ctx) => PlanScreen(),
              RecordScreen.routeName: (ctx) => RecordScreen(),
              CommunityScreen.routeName: (ctx) => CommunityScreen(),
              NotificationScreen.routeName: (ctx) => NotificationScreen(),
              PersonalMealScreen.routeName: (ctx) => PersonalMealScreen(),
              FoodDetailScreen.routeName: (ctx) => FoodDetailScreen(),
              CreateGroupScreen.routeName: (ctx) => CreateGroupScreen(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              SearchScreen.routeName: (ctx) => SearchScreen(),
              GroupScreen.routeName: (ctx) => GroupScreen(),
              MainChatScreen.routeName: (ctx) => MainChatScreen(),
              SubChatScreen.routeName: (ctx) => SubChatScreen(),
              LifeStyleSummary.routeName: (ctx) => LifeStyleSummary(),
              FriendRequest.routeName: (ctx) => FriendRequest(),
              GroupRequest.routeName: (ctx) => GroupRequest(),
              PostScreen.routeName: (ctx) => PostScreen(),
              EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
              ViewFriendScreen.routeName: (ctx) => ViewFriendScreen(),
              ViewGroupMemberScreen.routeName: (ctx) => ViewGroupMemberScreen(),
              CreateChallengeScreen.routeName: (ctx) => CreateChallengeScreen(),
              ScoreboardScreen.routeName: (ctx) => ScoreboardScreen(),
              HistoryScreen.routeName: (ctx) => HistoryScreen(),
              WaterScreen.routeName: (ctx) => WaterScreen(),
              ChallengeScreen.routeName: (ctx) => ChallengeScreen(),
              ExerciseScreen.routeName: (ctx) => ExerciseScreen(),
              SleepScreen.routeName: (ctx) => SleepScreen(),
              InviteGroupScreen.routeName: (ctx) => InviteGroupScreen(),
              SettingScreen.routeName: (ctx) => SettingScreen(),
              ChallengeScreenDetail.routeName: (ctx) => ChallengeScreenDetail(),

              MapsScreen.routeName: (ctx) => MapsScreen(),
            }),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
