import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class Food {
  final int fid;
  final String type;
  final String category;
  final String name;
  final int calories;
  final int carb;
  final int protein;
  final int fat;
  final int fiber;
  final String des;
  final String imgUrl;
  final int verified;

  Food(
      {@required this.fid,
      this.type,
      this.category,
      this.name,
      this.calories,
      this.carb,
      this.protein,
      this.fat,
      this.fiber,
      this.des,
      this.imgUrl,
      this.verified});
}

class FoodProvider with ChangeNotifier {
  
 final endUrl = dotenv.env['endUrl'];


  List<Food> allFood;

  List<Food> get food {
    return allFood;
  }

  Future<void> getAllFood() async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/food";
    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"},);
      final extractData = json.decode(response.body) as List<dynamic>;
      final List<Food> loadedFood = [];
      if (extractData == null) {
        return;
      }
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedFood.add(Food(
          fid: data['fid'],
          type: data['type'],
          category: data['category'],
          name: data['name'],
          calories: data['calories'],
          carb: data['carb'],
          protein: data['protein'],
          fat: data['fat'],
          fiber: data['fiber'],
          des: data['des'],
          imgUrl: data['imgUrl'],
          verified: data['verified'],
        ));
      });
      allFood = loadedFood;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<Food> getFood(int fid) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/food/$fid";
    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"},);
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      final Food loadedFood = Food(
          fid: extractData[0]['fid'],
          type: extractData[0]['type'],
          category: extractData[0]['category'],
          name: extractData[0]['name'],
          calories: extractData[0]['calories'],
          carb: extractData[0]['carb'],
          protein: extractData[0]['protein'],
          fat: extractData[0]['fat'],
          fiber: extractData[0]['fiber'],
          des: extractData[0]['des'],
          imgUrl: extractData[0]['imgUrl'],
          verified: extractData[0]['verified']);
      notifyListeners();
      return loadedFood;
    } catch (error) {
      print(error);
    }
  }

  Future<void> addFood(Food food) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/food";
    try {
      var body = json.encode({
        "fid": food.fid,
        "type": food.type,
        "category": food.category,
        "name": food.name,
        "calories": food.calories,
        "carb": food.carb,
        "protein": food.protein,
        "fat": food.fat,
        "fiber": food.fiber,
        "des": food.des,
        "imgUrl": food.imgUrl,
        "verified": food.verified
      });
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json', "Authorization": "Bearer $token"},
        body: body,
      );
      print(response.body);
    } catch (error) {
      print(error);
    }
  }
}
