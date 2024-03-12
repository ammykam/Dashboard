import 'package:firebase_auth/firebase_auth.dart' as u;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';

class Exercise {
  final int eid;
  final String name;
  final int burntRate1;
  final int burntRate2;
  final int burntRate3;
  final String imgUrl;
  final int verified;

  Exercise(
      {@required this.eid,
      this.name,
      this.burntRate1,
      this.burntRate2,
      this.burntRate3,
      this.imgUrl,
      this.verified});
}

class ExerciseProvider with ChangeNotifier {
 final endUrl = dotenv.env['endUrl'];

  //exercise detail
  Future<List<Exercise>> getExercise() async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/exercise";
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
      final extractData = json.decode(response.body) as List<dynamic>;

      if (extractData == null) {
        return null;
      }
      List<Exercise> loadedData = [];
      extractData.forEach((element) {
        loadedData.add(
          Exercise(
            eid: element['eid'],
            name: element['name'],
            burntRate1: element['burntRate1'],
            burntRate2: element['burntRate2'],
            burntRate3: element['burntRate3'],
            imgUrl: element['imgUrl'],
            verified: element['verified'],
          ),
        );
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<Exercise> getExerciseOne(int eid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/exercise/$eid";
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
      Exercise loadedData = Exercise(
        eid: data['eid'],
        name: data['name'],
        burntRate1: data['burntRate1'],
        burntRate2: data['burntRate2'],
        burntRate3: data['burntRate3'],
        imgUrl: data['imgUrl'],
        verified: data['verified'],
      );

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }
}
