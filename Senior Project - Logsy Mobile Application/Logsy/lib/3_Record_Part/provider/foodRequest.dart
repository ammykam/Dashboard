import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class FoodRequest {
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
  final int rid;
  final String branchName;
  final int branchID;

  FoodRequest(
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
      this.verified,
      this.rid,
      this.branchName,
      this.branchID});
}

class FoodRequestProvider extends ChangeNotifier {
 final endUrl = dotenv.env['endUrl'];

  FoodRequest breakfast;
  FoodRequest lunch;
  FoodRequest dinner;
  FoodRequest snack;

  Future<FoodRequest> getBreakfast(int uid, List<int> res, int refresh) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/breakfast/$uid";
    try {
      if (breakfast == null || refresh == 1) {
        final response = await http.post(url,
            headers: {
              'content-type': 'application/json',
              "Authorization": "Bearer $token"
            },
            body: json.encode(res));
        final data = json.decode(response.body) as Map<String, dynamic>;
        final loadedData = FoodRequest(
            fid: data['fid'],
            type: data['type'],
            category: data['category'],
            name: data['foodName'],
            calories: data['calories'],
            carb: data['carb'],
            protein: data['protein'],
            fat: data['fat'],
            fiber: data['fiber'],
            des: data['des'],
            imgUrl: data['imgUrl'],
            verified: data['foodVerified'],
            rid: data['restaurant_rid'],
            branchID: data['branchID'],
            branchName: data['branchName']);
        breakfast = loadedData;
        return loadedData;
      } else {
        return breakfast;
      }
    } catch (error) {
      print(error);
    }
  }

  Future<FoodRequest> getLunch(int uid, List<int> res, int refresh) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/lunch/$uid";
    try {
      if (lunch == null || refresh == 1) {
        final response = await http.post(url,
            headers: {
              'content-type': 'application/json',
              "Authorization": "Bearer $token"
            },
            body: json.encode(res));
        final data = json.decode(response.body) as Map<String, dynamic>;

        final loadedData = FoodRequest(
            fid: data['fid'],
            type: data['type'],
            category: data['category'],
            name: data['foodName'],
            calories: data['calories'],
            carb: data['carb'],
            protein: data['protein'],
            fat: data['fat'],
            fiber: data['fiber'],
            des: data['des'],
            imgUrl: data['imgUrl'],
            verified: data['foodVerified'],
            rid: data['restaurant_rid'],
            branchID: data['branchID'],
            branchName: data['branchName']);
        lunch = loadedData;
        return loadedData;
      } else {
        return lunch;
      }
    } catch (error) {
      print(error);
    }
  }

  Future<FoodRequest> getDinner(int uid, List<int> res, int refresh) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/dinner/$uid";
    try {
      if (dinner == null || refresh == 1) {
        final response = await http.post(url,
            headers: {
              'content-type': 'application/json',
              "Authorization": "Bearer $token"
            },
            body: json.encode(res));
        final data = json.decode(response.body) as Map<String, dynamic>;

        final loadedData = FoodRequest(
            fid: data['fid'],
            type: data['type'],
            category: data['category'],
            name: data['foodName'],
            calories: data['calories'],
            carb: data['carb'],
            protein: data['protein'],
            fat: data['fat'],
            fiber: data['fiber'],
            des: data['des'],
            imgUrl: data['imgUrl'],
            verified: data['foodVerified'],
            rid: data['restaurant_rid'],
            branchID: data['branchID'],
            branchName: data['branchName']);
        dinner = loadedData;
        return loadedData;
      } else {
        return dinner;
      }
    } catch (error) {
      print(error);
    }
  }

  Future<FoodRequest> getSnack(int uid, List<int> res, int refresh) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/snack/$uid";
    try {
      if (snack == null || refresh == 1) {
        final response = await http.post(url,
            headers: {
              'content-type': 'application/json',
              "Authorization": "Bearer $token"
            },
            body: json.encode(res));
        final data = json.decode(response.body) as Map<String, dynamic>;

        final loadedData = FoodRequest(
            fid: data['fid'],
            type: data['type'],
            category: data['category'],
            name: data['foodName'],
            calories: data['calories'],
            carb: data['carb'],
            protein: data['protein'],
            fat: data['fat'],
            fiber: data['fiber'],
            des: data['des'],
            imgUrl: data['imgUrl'],
            verified: data['foodVerified'],
            rid: data['restaurant_rid'],
            branchID: data['branchID'],
            branchName: data['branchName']);
        snack = loadedData;
        return loadedData;
      } else {
        return snack;
      }
    } catch (error) {
      print(error);
    }
  }

  Future<List<FoodRequest>> getRecommendFood(int uid, List<int> res) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/recommendFood/$uid";
    try {
      final response = await http.post(
        url,
        body: json.encode(res),
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
      );
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      List<FoodRequest> loadedData = [];

      extractData.forEach((element) {
        loadedData.add(FoodRequest(
            fid: element['fid'],
            type: element['type'],
            category: element['category'],
            name: element['foodName'],
            calories: element['calories'],
            carb: element['carb'],
            protein: element['protein'],
            fat: element['fat'],
            fiber: element['fiber'],
            des: element['des'],
            imgUrl: element['imgUrl'],
            verified: element['foodVerified'],
            rid: element['restaurant_rid'],
            branchID: element['branchID'],
            branchName: element['branchName']));
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }
}
