import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsMsg {
  final int uid;
  final DateTime date;
  final String eat;
  final String eatEdu;
  final String eatColor;
  final String sleep;
  final String sleepEdu;
  final String sleepColor;
  final String exercise;
  final String exerciseEdu;
  final String exerciseColor;

  AnalyticsMsg(
      {this.uid,
      this.date,
      this.eat,
      this.eatEdu,
      this.eatColor,
      this.sleep,
      this.sleepEdu,
      this.sleepColor,
      this.exercise,
      this.exerciseEdu,
      this.exerciseColor});
}

class Message {
  final int mid;
  final String type;
  final String level;
  final String subLevel;
  final String message;

  Message({this.mid, this.type, this.level, this.subLevel, this.message});
}

class AnalyticsMsgProvider with ChangeNotifier {
  // String token;
  final endUrl = dotenv.env['endUrl'];

  // Future<String> _firebase() async {
  //   FirebaseAuth.instance.authStateChanges().listen((User user) async {
  //     token = await user.getIdToken(true);
  //   });
  //   return token;
  // }

  Future<Message> getMotivateMessage(int mid, String _token) async {
    final url = "$endUrl/motivateMessage/$mid";
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $_token"},
      );
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData.length == null) {
        return null;
      }
      final element = extractData[0] as Map<String, dynamic>;
      Message loadedData = Message(
        mid: element["mid"],
        type: element["type"],
        level: element["level"],
        subLevel: element["subLevel"],
        message: element["message"],
      );
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
    //await _firebase();
  }

  Future<Message> getEducatingMessage(int emid, String _token) async {
    final url = "$endUrl/educatingMessage/$emid";
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $_token"},
      );
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData.length == null) {
        return null;
      }
      final element = extractData[0] as Map<String, dynamic>;
      Message loadedData = Message(
        mid: element["mid"],
        type: element["type"],
        level: element["level"],
        message: element["message"],
      );

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
    // await _firebase();
  }

  Future<AnalyticsMsg> getDashboardMessage(int uid, DateTime date) async {
    final user = FirebaseAuth.instance.currentUser;
    //final _token = await user.getIdToken(true);
    final _token = await user.getIdToken();

    final url =
        "$endUrl/dashboardMessage/$uid/${date.year}/${date.month}/${date.day}";
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer ${_token}"},
      );
      //print(_token);
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData.length == null) {
        return null;
      }
      final element = extractData[0] as Map<String, dynamic>;
      String eat = "";
      String sleep = "";
      String exercise = "";
      String eatColor = "";
      String sleepColor = "";
      String exerciseColor = "";

      String eat_edu = "";
      String sleep_edu = "";
      String exercise_edu = "";

      await getMotivateMessage(element["eat_mid"], _token).then((value) {
        eat = value.message;
        eatColor = value.level;
      });
      await getMotivateMessage(element["sleep_mid"], _token).then((value) {
        sleep = value.message;
        sleepColor = value.level;
      });
      await getMotivateMessage(element["exercise_mid"], _token).then((value) {
        exercise = value.message;
        exerciseColor = value.level;
      });

      await getEducatingMessage(element["eat_emid"], _token).then((value) {
        eat_edu = value.message;
      });
      await getEducatingMessage(element["sleep_emid"], _token).then((value) {
        sleep_edu = value.message;
      });
      await getEducatingMessage(element["exercise_emid"], _token).then((value) {
        exercise_edu = value.message;
      });

      AnalyticsMsg loadedData = AnalyticsMsg(
        uid: element["user_uid"],
        date: DateTime.parse(element["date"]),
        eat: eat,
        eatEdu: eat_edu,
        sleep: sleep,
        eatColor: eatColor,
        sleepColor: sleepColor,
        exerciseColor: exerciseColor,
        sleepEdu: sleep_edu,
        exercise: exercise,
        exerciseEdu: exercise_edu,
      );

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
    // await _firebase();
  }
}
