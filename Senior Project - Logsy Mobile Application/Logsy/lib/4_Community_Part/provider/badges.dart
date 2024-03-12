import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class Badge {
  final int uid;
  final DateTime timestamp;

  final int bid;
  final String name;
  final String category;
  final String des;
  final String req;
  final String imgUrl;

  Badge(
      {this.uid,
      this.timestamp,
      this.bid,
      this.name,
      this.category,
      this.des,
      this.req,
      this.imgUrl});
}

class BadgeProvider extends ChangeNotifier {
 
   final endUrl = dotenv.env['endUrl'];
  Future<List<Badge>> getAllBadge(int uid) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/allBadges/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData.length == 0) {
        return null;
      }
      List<Badge> loadedData = [];
      extractData.forEach((element) {
        loadedData.add(
          Badge(
              uid: element["user_uid"],
              timestamp: DateTime.parse(element["timestamp"]),
              bid: element["bid"],
              name: element["name"],
              category: element["category"],
              des: element["des"],
              req: element["req"],
              imgUrl: element["imgUrl"]),
        );
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<Badge> getNewBadge(int uid) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/newestBadge/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData.length == 0) {
        return null;
      }
      final element = extractData[0] as Map<String, dynamic>;
      Badge loadedData = Badge(
          uid: element["user_uid"],
          timestamp: DateTime.parse(element["timestamp"]),
          bid: element["bid"],
          name: element["name"],
          category: element["category"],
          des: element["des"],
          req: element["req"],
          imgUrl: element["imgUrl"]);

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }
}
