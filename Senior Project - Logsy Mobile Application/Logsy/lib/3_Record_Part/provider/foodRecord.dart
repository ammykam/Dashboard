import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

import 'food.dart';

class FoodRecord {
  final int foodRecID;
  final int user_uid;
  final int food_fid;
  final DateTime timestamp;
  final String type;

  FoodRecord(
      {@required this.foodRecID,
      this.user_uid,
      this.food_fid,
      this.timestamp,
      this.type});
}

class FoodRecordProvider with ChangeNotifier {
 final endUrl = dotenv.env['endUrl'];

  Future<List<FoodRecord>> getFoodRecordUser(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/foodRecordList/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      List<FoodRecord> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(FoodRecord(
            foodRecID: data['foodRecID'],
            user_uid: data['user_uid'],
            food_fid: data['food_fid'],
            timestamp: DateTime.parse(data['timestamp']),
            type: data['type']));
      });
      notifyListeners();

      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> addFoodRecord(FoodRecord foodRecord) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/foodRecord";
    try {
      var body = json.encode({
        "foodRecID": foodRecord.foodRecID,
        "user_uid": foodRecord.user_uid,
        "food_fid": foodRecord.food_fid,
        "timestamp": foodRecord.timestamp.toString(),
        "type": foodRecord.type,
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

  Future<List<FoodRecord>> getFoodRecordRange(
      int uid, DateTime start, DateTime end) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url =
        "$endUrl/foodRecordRange/$uid/${start.year}/${start.month}/${start.day}/${end.year}/${end.month}/${end.day}";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      List<FoodRecord> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(FoodRecord(
            foodRecID: data['foodRecID'],
            user_uid: data['user_uid'],
            food_fid: data['food_fid'],
            timestamp: DateTime.parse(data['timestamp']),
            type: data['type']));
      });

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<FoodRecord>> getFoodRecordDay(int uid, DateTime start) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url =
        "$endUrl/foodRecordDay/$uid/${start.year}/${start.month}/${start.day}";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      print(extractData);
      if (extractData == null) {
        return null;
      }
      List<FoodRecord> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(FoodRecord(
            foodRecID: data['foodRecID'],
            user_uid: data['user_uid'],
            food_fid: data['food_fid'],
            timestamp: DateTime.parse(data['timestamp']),
            type: data['type']));
      });

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<Map<String, int>> getSkippedMeal(
      int uid, DateTime start, DateTime end) async {
    try {
      List<FoodRecord> response = await getFoodRecordRange(uid, start, end);
      int breakfast = 0;
      int lunch = 0;
      int dinner = 0;
      List<Map<String, dynamic>> dateFoodRecord = [];

      response.forEach((foodData) {
        //time of the food record
        final date = DateFormat('d/MM/y').format(foodData.timestamp);
        //check date exist?
        var contain = dateFoodRecord.where((element) =>
            DateFormat('d/MM/y').format(element['timestamp']) == date);
        //if there is no date, insert data
        if (contain.isEmpty) {
          if (foodData.type == "breakfast") {
            dateFoodRecord.add({
              'timestamp': foodData.timestamp,
              'breakfast': [foodData.food_fid],
              'lunch': [],
              'dinner': [],
              'snack': [],
              'water': 0
            });
          } else if (foodData.type == "lunch") {
            dateFoodRecord.add({
              'timestamp': foodData.timestamp,
              'breakfast': [],
              'lunch': [foodData.food_fid],
              'dinner': [],
              'snack': [],
              'water': 0
            });
          } else if (foodData.type == "dinner") {
            dateFoodRecord.add({
              'timestamp': foodData.timestamp,
              'breakfast': [],
              'lunch': [],
              'dinner': [foodData.food_fid],
              'snack': [],
              'water': 0
            });
          } else if (foodData.type == "snack") {
            dateFoodRecord.add({
              'timestamp': foodData.timestamp,
              'breakfast': [],
              'lunch': [],
              'dinner': [],
              'snack': [foodData.food_fid],
              'water': 0
            });
          }
          // if the date already exists, add the menu
        } else {
          int index = dateFoodRecord.indexWhere((element) =>
              DateFormat('d/MM/y').format(element['timestamp']) == date);
          dateFoodRecord[index][foodData.type].add(foodData.food_fid);
        }
      });

      if (DateTime.now().isAfter(end)) {
        DateTime startDate = start;
        DateTime endDate = end.add(Duration(days: 1));
        while (startDate.isBefore(endDate)) {
          int index = dateFoodRecord.indexWhere((element) =>
              DateFormat('d/MM/y').format(element['timestamp']) ==
              DateFormat('d/MM/y').format(startDate));

          if (index < 0) {
            breakfast++;
            lunch++;
            dinner++;
          } else {
            Map<String, dynamic> element = dateFoodRecord[index];
            if (element['breakfast'].length == 0) {
              breakfast++;
            }
            if (element['lunch'].length == 0) {
              lunch++;
            }
            if (element['dinner'].length == 0) {
              dinner++;
            }
          }
          startDate = startDate.add(Duration(days: 1));
        }
      } else {
        //calculate until today
        DateTime startDate = start;
        DateTime currentDate = DateTime.now();

        while (DateFormat('d/MM/y').format(startDate) !=
            DateFormat('d/MM/y').format(currentDate)) {
          int index = dateFoodRecord.indexWhere((element) =>
              DateFormat('d/MM/y').format(element['timestamp']) ==
              DateFormat('d/MM/y').format(startDate));

          if (index < 0) {
            breakfast++;
            lunch++;
            dinner++;
          } else {
            Map<String, dynamic> element = dateFoodRecord[index];
            if (element['breakfast'].length == 0) {
              breakfast++;
            }
            if (element['lunch'].length == 0) {
              lunch++;
            }
            if (element['dinner'].length == 0) {
              dinner++;
            }
          }
          startDate = startDate.add(Duration(days: 1));
        }
      }
      // print({'breakfast': breakfast, 'lunch': lunch, 'dinner': dinner});
      return {'breakfast': breakfast, 'lunch': lunch, 'dinner': dinner};
    } catch (error) {
      print(error);
    }
  }

  Future<Map<String, dynamic>> getTotalSummary(
      int uid, DateTime start, DateTime end) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url =
        "$endUrl/foodRecordSummaryRange/$uid/${start.year}/${start.month}/${start.day}/${end.year}/${end.month}/${end.day}";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as dynamic;
      Map<String, dynamic> loadedData = extractData;
      if (loadedData['TotalCalories'] == null &&
          loadedData['TotalCarbohydrate'] == null &&
          loadedData['TotalProtein'] == null &&
          loadedData['TotalFat'] == null) {
        loadedData['TotalCalories'] = 0;
        loadedData['TotalCarbohydrate'] = 0;
        loadedData['TotalProtein'] = 0;
        loadedData['TotalFat'] = 0;
      } else {
        loadedData['TotalCalories'] = loadedData['TotalCalories'];
        loadedData['TotalCarbohydrate'] = loadedData['TotalCarbohydrate'];
        loadedData['TotalProtein'] = loadedData['TotalProtein'];
        loadedData['TotalFat'] = loadedData['TotalFat'];
      }
      // DateTime currentDate = DateTime.now();
      // if (currentDate.isAfter(end)) {
      //   //the week is full
      // loadedData['TotalCalories'] = loadedData['TotalCalories']/7;
      // loadedData['TotalCarbohydrate'] = loadedData['TotalCarbohydrate']/7;
      // loadedData['TotalProtein'] = loadedData['TotalProtein']/7;
      // loadedData['TotalFat'] = loadedData['TotalFat']/7;
      // } else {
      //   //this is the current week
      //   int day = 0;
      //   while (DateFormat('d/MM/y').format(currentDate) !=
      //       DateFormat('d/MM/y').format(start)) {
      //     day++;
      //     start = start.add(Duration(days: 1));
      //   }
      //   loadedData['TotalCalories'] = loadedData['TotalCalories']/day;
      //   loadedData['TotalCarbohydrate'] = loadedData['TotalCarbohydrate']/day;
      //   loadedData['TotalProtein'] = loadedData['TotalProtein']/day;
      //   loadedData['TotalFat'] = loadedData['TotalFat']/day;
      // }

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<Map<String, dynamic>> getTotalSummaryDay(
      int uid, DateTime start) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url =
        "$endUrl/foodRecordSummaryDay/$uid/${start.year}/${start.month}/${start.day}";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      Map<String, dynamic> loadedData = extractData[0];
      // print(loadedData);
      if (loadedData['TotalCalories'] == null) {
        loadedData['TotalCalories'] = 0;
      }

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<Map<String, dynamic>>> getGraphData(
      int uid, DateTime start, DateTime end) async {
    try {
      DateTime currentDate = DateTime.now();
      List<Map<String, dynamic>> loadedData = [];
      if (currentDate.isAfter(end)) {
        //the week is complete

        while (DateFormat('d/MM/y').format(start) !=
            DateFormat('d/MM/y').format(end.add(Duration(days: 1)))) {
          int data = 0;
          await getTotalSummaryDay(uid, start).then((value) {
            data = value['TotalCalories'];
          });
          loadedData.add({'timestamp': start, 'value': data});
          start = start.add(Duration(days: 1));
        }
        return loadedData;
      } else {
        //current week so minus 7
        DateTime newTime = currentDate.subtract(Duration(days: 8));
        DateTime endTime = currentDate.subtract(Duration(days: 1));
        while (DateFormat('d/MM/y').format(newTime) !=
            DateFormat('d/MM/y').format(endTime)) {
          int data = 0;
          await getTotalSummaryDay(uid, endTime).then((value) {
            data = value['TotalCalories'];
          });
          loadedData.add({'timestamp': endTime, 'value': data});
          endTime = endTime.subtract(Duration(days: 1));
        }

        return loadedData.reversed.toList();
      }
    } catch (error) {
      print(error);
    }
  }
}
