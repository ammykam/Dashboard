import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class LifeStyle {
  final String eat;
  final String sleep;
  final String exercise;

  LifeStyle({this.eat, this.sleep, this.exercise});
}

class LifeStyleProvider extends ChangeNotifier {
 
   final endUrl = dotenv.env['endUrl'];
  Future<LifeStyle> getLifeStyle(int uid, DateTime start, DateTime end) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final _token = await user.getIdToken(true);
     final _token = await user.getIdToken();
    final url =
        "$endUrl/lifestyleStatus/$uid/${start.year}/${start.month}/${start.day}/${end.year}/${end.month}/${end.day}";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $_token"});
      final extractData = json.decode(response.body) as dynamic;
      
      if (extractData == null) {
        return null;
      }
      LifeStyle loadedData = LifeStyle(
        eat: extractData["eat"],
        sleep: extractData["sleep"],
        exercise: extractData["exercise"],
      );
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }
}
