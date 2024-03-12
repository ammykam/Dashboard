import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class ExerciseRecord {
  final int exerciseRecID;

  final int user_uid;
  final int exercise_eid;
  final int duration;
  final DateTime timestamp;
  final int calBurnt;

  ExerciseRecord(
      {@required this.exerciseRecID,
      this.user_uid,
      this.exercise_eid,
      this.duration,
      this.timestamp,
      this.calBurnt});
}

class ExerciseRecordProvider with ChangeNotifier {
  
   final endUrl = dotenv.env['endUrl'];
 

  //exercise detail
  Future<ExerciseRecord> getExerciseRecord(int exerciseRecID) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/exerciseRecord/$exerciseRecID";
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
      final extractData = json.decode(response.body) as List<dynamic>;

      if (extractData == null) {
        return null;
      }
      final data = extractData[0] as Map<String, dynamic>;
      ExerciseRecord loadedData = ExerciseRecord(
        exerciseRecID: data['exerciseRecID'],
        user_uid: data['user_uid'],
        exercise_eid: data['exercise_eid'],
        duration: data['duration'],
        timestamp: DateTime.parse(data['timestamp']),
        calBurnt: data['calBurnt'],
      );

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<ExerciseRecord>> getExerciseRecordUser(int uid) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/exerciseRecordList/$uid";
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
      final extractData = json.decode(response.body) as List<dynamic>;

      if (extractData == null) {
        return null;
      }
      List<ExerciseRecord> loadedData = [];

      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(ExerciseRecord(
          exerciseRecID: data['exerciseRecID'],
          user_uid: data['user_uid'],
          exercise_eid: data['exercise_eid'],
          duration: data['duration'],
          timestamp: DateTime.parse(data['timestamp']),
          calBurnt: data['calBurnt'],
        ));
      });

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> addExerciseRecord(ExerciseRecord exerRec) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/exerciseRecord";
    try {
      var body = json.encode({
        "exerciseRecID": exerRec.exerciseRecID,
        "user_uid": exerRec.user_uid,
        "exercise_eid": exerRec.exercise_eid,
        "duration": exerRec.duration,
        "timestamp": exerRec.timestamp.toString(),
      });

      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: body,
      );

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<List<ExerciseRecord>> getExerciseRecordRange(
      int uid, DateTime start, DateTime end) async {
         final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url =
        "$endUrl/exerciseRecordRange/$uid/${start.year}/${start.month}/${start.day}/${end.year}/${end.month}/${end.day}";

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      final extractData = json.decode(response.body) as List<dynamic>;

      if (extractData == null) {
        return null;
      }
      List<ExerciseRecord> loadedData = [];

      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;

        loadedData.add(ExerciseRecord(
          exerciseRecID: data['exerciseRecID'],
          user_uid: data['user_uid'],
          exercise_eid: data['exercise_eid'],
          duration: data['duration'],
          timestamp: DateTime.parse(data['timestamp']),
          calBurnt: data['calBurnt'],
        ));
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }
}
