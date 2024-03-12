import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class SleepRecord {
  final int sleepRecID;
  final int user_uid;
  final DateTime date;
  final DateTime bedTime;
  final DateTime wakeTime;

  SleepRecord(
      {@required this.sleepRecID,
      this.user_uid,
      this.date,
      this.bedTime,
      this.wakeTime});
}

class SleepGoal {
  final int minGreen;
  final int maxGreen;
  final int minLowerYellow;
  final int maxLowerYellow;
  final int minUpperYellow;
  final int maxUpperYellow;

  SleepGoal({
    this.minGreen,
    this.maxGreen,
    this.minLowerYellow,
    this.maxLowerYellow,
    this.minUpperYellow,
    this.maxUpperYellow,
  });
}

class SleepRecordProvider with ChangeNotifier {
  
  final endUrl = dotenv.env['endUrl'];
  Future<List<SleepRecord>> getSleepRecord(int uid) async {
   final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/sleepRecordList/$uid";
    try {
      final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;

      if (extractData == null) {
        return null;
      }

      List<SleepRecord> loadedData = [];
      extractData.forEach(
        (element) {
          String day =
              DateFormat("yyyy-MM-dd").format(DateTime.parse(element["date"]));
          loadedData.add(
            SleepRecord(
              sleepRecID: element["sleepRecID"],
              user_uid: element["user_uid"],
              date: DateTime.parse(element["date"]),
              bedTime: DateTime.parse(element["bedTime"]),
              wakeTime: DateTime.parse(element["wakeTime"]),
            ),
          );
        },
      );
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<SleepRecord>> getSleepRecordRange(
      int uid, DateTime start, DateTime end) async {
         final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url =
        "$endUrl/sleepRecordRange/$uid/${start.year}/${start.month}/${start.day}/${end.year}/${end.month}/${end.day}";
    try {
      final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;

      if (extractData == null) {
        return null;
      }

      List<SleepRecord> loadedData = [];
      extractData.forEach(
        (element) {
          String day =
              DateFormat("yyyy-MM-dd").format(DateTime.parse(element["date"]));
          loadedData.add(
            SleepRecord(
              sleepRecID: element["sleepRecID"],
              user_uid: element["user_uid"],
              date: DateTime.parse(element["date"]),
              bedTime: DateTime.parse(element["bedTime"]),
              wakeTime: DateTime.parse(element["wakeTime"]),
            ),
          );
        },
      );
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<SleepRecord> getSleepRecordDay(int uid, DateTime date) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url =
        "$endUrl/sleepRecordDay/$uid/${date.year}/${date.month}/${date.day}";
    try {
      final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;

      if (extractData.length == 0) {
        return null;
      }
      final element = extractData[0] as Map<String, dynamic>;

      SleepRecord loadedData = SleepRecord(
        sleepRecID: element["sleepRecID"],
        user_uid: element["user_uid"],
        date: DateTime.parse(element["date"]),
        bedTime: DateTime.parse(element["bedTime"]),
        wakeTime: DateTime.parse(element["wakeTime"]),
      );

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
          double bedTime;
          double wakeTime;
          double bT;
          double wT;

          await getSleepRecordDay(uid, start).then((value) {
            if (value == null) {
              bedTime = 10;
              wakeTime = 10;
              wT = wakeTime;
              bT = bedTime;
            } else {
              bedTime = double.parse(DateFormat("HHmm").format(value.bedTime));
              wakeTime =
                  double.parse(DateFormat("HHmm").format(value.wakeTime));
              wT = wakeTime;
              bT = bedTime;

              //wakeTime
              if (wakeTime >= 1900 && wakeTime <= 2400) {
                if (wakeTime <= 0) {
                  wakeTime = 6;
                } else if (wakeTime <= 1900) {
                  wakeTime = 1;
                } else if (wakeTime <= 2000) {
                  wakeTime = 2;
                } else if (wakeTime <= 2100) {
                  wakeTime = 3;
                } else if (wakeTime <= 2200) {
                  wakeTime = 4;
                } else if (wakeTime <= 2400) {
                  wakeTime = 5;
                }
              } else {
                if (wakeTime >= 1100) {
                  wakeTime = 18;
                } else if (wakeTime >= 1000) {
                  wakeTime = 17;
                } else if (wakeTime >= 900) {
                  wakeTime = 16;
                } else if (wakeTime >= 800) {
                  wakeTime = 15;
                } else if (wakeTime >= 700) {
                  wakeTime = 14;
                } else if (wakeTime >= 600) {
                  wakeTime = 13;
                } else if (wakeTime >= 500) {
                  wakeTime = 12;
                } else if (wakeTime >= 400) {
                  wakeTime = 11;
                } else if (wakeTime >= 300) {
                  wakeTime = 10;
                } else if (wakeTime >= 200) {
                  wakeTime = 9;
                } else if (wakeTime >= 100) {
                  wakeTime = 8;
                } else if (wakeTime >= 0) {
                  wakeTime = 7;
                }
              }
              //bedTime
              if (bedTime >= 1900 && bedTime <= 2400) {
                if (bedTime <= 0) {
                  bedTime = 6;
                } else if (bedTime <= 1900) {
                  bedTime = 1;
                } else if (bedTime <= 2000) {
                  bedTime = 2;
                } else if (bedTime <= 2100) {
                  bedTime = 3;
                } else if (bedTime <= 2200) {
                  bedTime = 4;
                } else if (bedTime <= 2400) {
                  bedTime = 5;
                }
              } else {
                if (bedTime >= 1100) {
                  bedTime = 18;
                } else if (bedTime >= 1000) {
                  bedTime = 17;
                } else if (bedTime >= 900) {
                  bedTime = 16;
                } else if (bedTime >= 800) {
                  bedTime = 15;
                } else if (bedTime >= 700) {
                  bedTime = 14;
                } else if (bedTime >= 600) {
                  bedTime = 13;
                } else if (bedTime >= 500) {
                  bedTime = 12;
                } else if (bedTime >= 400) {
                  bedTime = 11;
                } else if (bedTime >= 300) {
                  bedTime = 10;
                } else if (bedTime >= 200) {
                  bedTime = 9;
                } else if (bedTime >= 100) {
                  bedTime = 8;
                } else if (bedTime >= 0) {
                  bedTime = 7;
                }
              }
            }
          });
          loadedData.add({
            "timestamp": start,
            "wakeTime": wakeTime,
            "bedTime": bedTime,
            "wT": wT,
            "bT": bT
          });
          start = start.add(Duration(days: 1));
        }

        return loadedData;
      } else {
        //current week so minus 7
        DateTime newTime = currentDate.subtract(Duration(days: 8));
        DateTime endTime = currentDate.subtract(Duration(days: 1));
        while (DateFormat('d/MM/y').format(newTime) !=
            DateFormat('d/MM/y').format(endTime)) {
          double bedTime;
          double wakeTime;
          double bT;
          double wT;

          await getSleepRecordDay(uid, endTime).then((value) {
            if (value == null) {
              bedTime = 10;
              wakeTime = 10;
              wT = wakeTime;
              bT = bedTime;
            } else {
              bedTime = double.parse(DateFormat("HHmm").format(value.bedTime));
              wakeTime =
                  double.parse(DateFormat("HHmm").format(value.wakeTime));
              wT = wakeTime;
              bT = bedTime;

              
              //wakeTime
              if (wakeTime >= 1900 && wakeTime <= 2400) {
                if (wakeTime <= 1900) {
                  wakeTime = 1;
                } else if (wakeTime <= 2000) {
                  wakeTime = 2;
                } else if (wakeTime <= 2100) {
                  wakeTime = 3;
                } else if (wakeTime <= 2200) {
                  wakeTime = 4;
                } else if (wakeTime <= 2400) {
                  wakeTime = 5;
                }
              } else {
                if (wakeTime >= 1100) {
                  wakeTime = 17;
                } else if (wakeTime >= 1000) {
                  wakeTime = 16;
                } else if (wakeTime >= 900) {
                  wakeTime = 15;
                } else if (wakeTime >= 800) {
                  wakeTime = 14;
                } else if (wakeTime >= 700) {
                  wakeTime = 13;
                } else if (wakeTime >= 600) {
                  wakeTime = 12;
                } else if (wakeTime >= 500) {
                  wakeTime = 11;
                } else if (wakeTime >= 400) {
                  wakeTime = 10;
                } else if (wakeTime >= 300) {
                  wakeTime = 9;
                } else if (wakeTime >= 200) {
                  wakeTime = 8;
                } else if (wakeTime >= 100) {
                  wakeTime = 7;
                } else if (wakeTime >= 0) {
                  wakeTime = 6;
                }
              }
              //bedTime
              if (bedTime >= 1900 && bedTime <= 2400) {
                if (bedTime <= 1900) {
                  bedTime = 1;
                } else if (bedTime <= 2000) {
                  bedTime = 2;
                } else if (bedTime <= 2100) {
                  bedTime = 3;
                } else if (bedTime <= 2200) {
                  bedTime = 4;
                } else if (bedTime <= 2400) {
                  bedTime = 5;
                }
              } else {
                if (bedTime >= 1100) {
                  bedTime = 17;
                } else if (bedTime >= 1000) {
                  bedTime = 16;
                } else if (bedTime >= 900) {
                  bedTime = 15;
                } else if (bedTime >= 800) {
                  bedTime = 14;
                } else if (bedTime >= 700) {
                  bedTime = 13;
                } else if (bedTime >= 600) {
                  bedTime = 12;
                } else if (bedTime >= 500) {
                  bedTime = 11;
                } else if (bedTime >= 400) {
                  bedTime = 10;
                } else if (bedTime >= 300) {
                  bedTime = 9;
                } else if (bedTime >= 200) {
                  bedTime = 8;
                } else if (bedTime >= 100) {
                  bedTime = 7;
                } else if (bedTime >= 0) {
                  bedTime = 6;
                }
              }
            }
          });
          loadedData.add({
            "timestamp": endTime,
            "wakeTime": wakeTime,
            "bedTime": bedTime,
            "wT": wT,
            "bT": bT
          });
          endTime = endTime.subtract(Duration(days: 1));
        }
   

        return loadedData.reversed.toList();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<int> getSleepAverage(int uid, DateTime start, DateTime end) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url =
        "$endUrl/sleepAverage/$uid/${start.year}/${start.month}/${start.day}/${end.year}/${end.month}/${end.day}";
    try {
      final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as int;
      if (extractData == null) {
        return null;
      }
      notifyListeners();
      return extractData;
    } catch (error) {
      print(error);
    }
  }

  Future<SleepGoal> getSleepGoal(int uid) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/sleepGoal/$uid";
    try {
      final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData.length == 0) {
        return null;
      }
      final data = extractData[0] as Map<String, dynamic>;
      SleepGoal loadedData = SleepGoal(
        minGreen: data["minGreen"],
        maxGreen: data["maxGreen"],
        minLowerYellow: data["minLowerYellow"],
        maxLowerYellow: data["maxLowerYellow"],
        minUpperYellow: data["minUpperYellow"],
        maxUpperYellow: data["maxUpperYellow"],
      );
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> addSleepRecord(SleepRecord sleepRecord) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/sleepRecord";
    try {
      var body = json.encode({
        "sleepRecID": sleepRecord.sleepRecID,
        "user_uid": sleepRecord.user_uid,
        "date": sleepRecord.date.toString(),
        "bedTime": sleepRecord.bedTime.toString(),
        "wakeTime": sleepRecord.wakeTime.toString(),
      });
      final response = await http.post(
        url,
        body: body,
        headers: {'content-type': 'application/json',"Authorization": "Bearer $token"},
      );
    } catch (error) {
      print(error);
    }
  }
}
