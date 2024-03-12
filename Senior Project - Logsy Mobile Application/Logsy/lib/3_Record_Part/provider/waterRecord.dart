import 'package:firebase_auth/firebase_auth.dart' as u;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class WaterRecord {
  final int waterRecID;
  final int user_uid;
  final DateTime timestamp;
  final int volume;

  WaterRecord(
      {@required this.waterRecID, this.user_uid, this.timestamp, this.volume});
}

class WaterRecordProvider with ChangeNotifier {

  final endUrl = dotenv.env['endUrl'];

  Future<WaterRecord> getWaterRecord(int waterRecID) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/waterRecord/$waterRecID";
    try {
      final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;

      if (extractData == null) {
        return null;
      }
      final data = extractData[0] as Map<String, dynamic>;
      WaterRecord loadedData = WaterRecord(
          waterRecID: data['waterRecID'],
          user_uid: data['user_uid'],
          timestamp: DateTime.parse(data['timestamp']),
          volume: data['volume']);
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<WaterRecord>> getWaterRecordUser(int uid) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/waterRecordList/$uid";
    try {
      
      final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      List<WaterRecord> loadedData = [];
      if (extractData == null) {
        return null;
      }
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(WaterRecord(
            waterRecID: data['waterRecID'],
            user_uid: data['user_uid'],
            timestamp: DateTime.parse(data['timestamp']),
            volume: data['volume']));
      });

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> addWaterRecord(WaterRecord waterRecord) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/waterRecord";
    try {
      var body = json.encode({
        "waterRecID": waterRecord.waterRecID,
        "user_uid": waterRecord.user_uid,
        "timestamp": waterRecord.timestamp.toString(),
        "volume": waterRecord.volume,
      });
      final response = await http.post(
        url,
        headers: {'content-type': 'application/json',"Authorization": "Bearer $token"},
        body: body,
      );
    } catch (error) {
      print(error);
    }
  }

  Future<List<WaterRecord>> getWaterRecordRange(
      int uid, DateTime start, DateTime end) async {
        final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url =
        "$endUrl/waterRecordRange/$uid/${start.year}/${start.month}/${start.day}/${end.year}/${end.month}/${end.day}";
    try {
      final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      List<WaterRecord> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(WaterRecord(
            waterRecID: data['waterRecID'],
            user_uid: data['user_uid'],
            timestamp: DateTime.parse(data['timestamp']),
            volume: data['volume']));
      });

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<int> getTotalSummary(int uid, DateTime start, DateTime end) async {
   final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url =
        "$endUrl/waterRecordSummaryRange/$uid/${start.year}/${start.month}/${start.day}/${end.year}/${end.month}/${end.day}";
    try {
      final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as dynamic;
      Map<String, dynamic> loadedData = extractData;
      if (loadedData['TotalVolume'] == null) {
        loadedData['TotalVolume'] = 0;
      }

      DateTime currentDate = DateTime.now();
      if (currentDate.isAfter(end)) {
        //the week is full
        loadedData['TotalVolume'] = loadedData['TotalVolume'];
      } else {
        //this is the current week
        int day = 0;
        while (DateFormat('d/MM/y').format(currentDate) !=
            DateFormat('d/MM/y').format(start)) {
          day++;
          start = start.add(Duration(days: 1));
        }

        loadedData['TotalVolume'] = loadedData['TotalVolume'];
      }
      notifyListeners();
      int glass = (loadedData['TotalVolume'] / 240).round();

      return glass;
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
        "$endUrl/waterRecordSummaryRange/$uid/${start.year}/${start.month}/${start.day}";
    try {
      final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      Map<String, dynamic> loadedData = extractData[0];

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }
}
