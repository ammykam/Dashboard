import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class User {
  final int uid;
  final String username;
  final String pwd;
  final String email;
  final String firstName;
  final String lastName;
  final int age;
  final int weight;
  final int height;
  final int physicalActivity;
  final int idealWeight;
  final String gender;
  final String goal;
  final String des;
  final String imgUrl;
  final int exerciseGoal;
  final int sleepGoal;
  final int stepGoal;

  User(
      {@required this.uid,
      this.username,
      this.pwd,
      this.email,
      this.firstName,
      this.lastName,
      this.age,
      this.weight,
      this.height,
      this.physicalActivity,
      this.idealWeight,
      this.gender,
      this.goal,
      this.des,
      this.imgUrl,
      this.exerciseGoal,
      this.sleepGoal,
      this.stepGoal});
}

class DailyIntake {
  final int uid;
  final int minCalories;
  final int maxCalories;
  final int minCarb;
  final int maxCarb;
  final int minProtein;
  final int maxProtein;
  final int minFat;
  final int maxFat;

  DailyIntake(
      {this.uid,
      this.minCalories,
      this.maxCalories,
      this.minCarb,
      this.maxCarb,
      this.minProtein,
      this.maxProtein,
      this.minFat,
      this.maxFat});
}

class Report {
  final int uid;
  final String type;
  final String reason;
  final Map<String, dynamic> note;
  final DateTime datetime;

  Report({
    this.uid,
    this.type,
    this.reason,
    this.note,
    this.datetime,
  });
}

class UserProvider with ChangeNotifier {
  final endUrl = dotenv.env['endUrl'];
  List<User> allUser = [];
  User currentUser;
  int _loginUid;

  List<User> get users {
    return allUser;
  }

  int get loginUser {
    return _loginUid;
    //return 50;
  }

  void setLoginUser(int uid) {
    _loginUid = uid;
  }

  Future<List<User>> getUsers() async {
    final url = "$endUrl/userList";

    try {
      final user = u.FirebaseAuth.instance.currentUser;
      // final token = await user.getIdToken(true);
      final token = await user.getIdToken();
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});

      final extractData = json.decode(response.body) as List<dynamic>;
      final List<User> loadedUser = [];
      if (extractData == null) {
        return null;
      }
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedUser.add(
          User(
              uid: data['uid'],
              username: data['username'],
              pwd: data['pwd'],
              email: data['email'],
              firstName: data['firstName'],
              lastName: data['lastName'],
              age: data['age'],
              weight: data['weight'],
              height: data['height'],
              physicalActivity: data['physicalActivity'],
              idealWeight: data['idealWeight'],
              gender: data['gender'],
              goal: data['goal'],
              des: data['des'],
              imgUrl: data['imgUrl'],
              exerciseGoal: data['exerciseGoal'],
              sleepGoal: data['sleepGoal'],
              stepGoal: data['stepGoal']),
        );
      });
      allUser = loadedUser;
      notifyListeners();
      return loadedUser;
    } catch (error) {
      print(error);
    }
  }

  Future<int> findUser(String fire_uid) async {
    int uid;
    await getUsers().then((value) {
      int index = value.indexWhere((element) => element.username == fire_uid);
      uid = value[index].uid;
      _loginUid = value[index].uid;
    });
    return uid;
  }

  Future<User> getUser(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/user/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      final data = extractData[0] as Map<String, dynamic>;

      User user = User(
          uid: data['uid'],
          username: data['username'],
          pwd: data['pwd'],
          email: data['email'],
          firstName: data['firstName'],
          lastName: data['lastName'],
          age: data['age'],
          weight: data['weight'],
          height: data['height'],
          physicalActivity: data['physicalActivity'],
          idealWeight: data['idealWeight'],
          gender: data['gender'],
          goal: data['goal'],
          des: data['des'],
          imgUrl: data['imgUrl'],
          exerciseGoal: data['exerciseGoal'],
          sleepGoal: data['sleepGoal'],
          stepGoal: data['stepGoal']);
      notifyListeners();
      return user;
    } catch (error) {
      print(error);
    }
  }

  Future<DailyIntake> getDailyIntakes(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;

    final token = await user.getIdToken();
    final url = "$endUrl/dailyIntakes/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData.length == 0) {
        return null;
      }

      final element = extractData[0] as Map<String, dynamic>;
      DailyIntake loadedData = DailyIntake(
        uid: element["user_uid"],
        minCalories: element["minCalories"],
        maxCalories: element["maxCalories"],
        minCarb: element["minCarb"],
        maxCarb: element["maxCarb"],
        minProtein: element["minProtein"],
        maxProtein: element["maxProtein"],
        minFat: element["minFat"],
        maxFat: element["maxFat"],
      );
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<String>> getInterest(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/interest/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      List<String> loadedData = [];
      extractData.forEach((element) {
        loadedData.add(element['interest']);
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<dynamic>> getInterestCategory(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;

    final token = await user.getIdToken();
    final url = "$endUrl/interest/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }

      notifyListeners();
      return extractData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> addUser(Map<String, dynamic> user) async {
    final userF = u.FirebaseAuth.instance.currentUser;
    // final token = await userF.getIdToken(true);
    final token = await userF.getIdToken();
    final url = "$endUrl/user";
    try {
      var body = json.encode(
        ({
          'uid': user['uid'],
          'username': user['username'],
          'pwd': user['password'],
          'email': user['email'],
          'firstName': user['firstName'],
          'lastName': user['lastName'],
          'age': int.parse(user['age']),
          'weight': int.parse(user['weight']),
          'height': int.parse(user['height']),
          'physicalActivity': user['physicalActivity'],
          'idealWeight': int.parse(user['idealWeight']),
          'gender': user['gender'],
          'goal': user['goal'],
          'des': user['desc'],
          'imgUrl': user['imgUrl'],
          'exerciseGoal': int.parse(user['exerciseGoal']),
          'sleepGoal': user['sleepGoal'],
          'eatInterest': user['eatInterest'],
          'sleepInterest': user["sleepInterest"],
          "exerciseInterest": user['exerciseInterest'],
          "stepGoal": user['stepGoal']
        }),
      );

      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: body,
      );
      print(response.body);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteUser(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/user/$uid";
    try {
      final response =
          await http.delete(url, headers: {"Authorization": "Bearer $token"});
      await user.delete();
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final userF = u.FirebaseAuth.instance.currentUser;
    // final token = await userF.getIdToken(true);
    final token = await userF.getIdToken();
    final url = "$endUrl/user";

    try {
      var body = json.encode(
        ({
          'uid': user['uid'],
          'username': user['username'],
          'pwd': user['password'],
          'email': user['email'],
          'firstName': user['firstName'],
          'lastName': user['lastName'],
          'age': user['age'],
          'weight': user['weight'],
          'height': user['height'],
          'physicalActivity': user['physicalActivity'],
          'idealWeight': user['idealWeight'],
          'gender': user['gender'],
          'goal': user['goal'],
          'des': user['desc'],
          'imgUrl': user['imgUrl'],
          'exerciseGoal': user['exerciseGoal'],
          'sleepGoal': user['sleepGoal'],
          'eatInterest': user['eatInterest'],
          'sleepInterest': user["sleepInterest"],
          "exerciseInterest": user['exerciseInterest'],
          "stepGoal": user['stepGoal']
        }),
      );
      final response = await http.put(
        url,
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: body,
      );
      print(response.body);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<int> userFriendNum(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    final token = await user.getIdToken();
    final url = "$endUrl/userFriend/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;

      int loadedData;

      return extractData.length;
    } catch (error) {
      print(error);
    }
  }

  Future<List<User>> userFriend(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    final token = await user.getIdToken();
    final url = "$endUrl/userFriend/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;

      List<User> loadedData = [];
      for (var data in extractData) {
        User user = await getUser(data['uid']);
        loadedData.add(user);
      }
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<String> userFriendStatus(int uid1, int uid2) async {
    final user = u.FirebaseAuth.instance.currentUser;

    final token = await user.getIdToken();
    final url = "$endUrl/friendStatus/$uid1/$uid2";
    try {
      if (uid1 == uid2) {
        return "Owner";
      }
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = response.body as String;
      notifyListeners();
      return extractData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<User>> userRequesting(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/userRequestedFriend/$uid";
    try {
      await getUsers();
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      List<User> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(
            allUser.where((element) => element.uid == data['uid']).toList()[0]);
      });
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<User>> userPending(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/userPendingFriend/$uid";
    try {
      await getUsers();
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      List<User> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(
            allUser.where((element) => element.uid == data['uid']).toList()[0]);
      });
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> sendFriendRequest(int uid1, int uid2) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/sendFriendRequest/$uid1/$uid2";
    try {
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
      );
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<void> acceptFriendRequest(int uid1, int uid2) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/acceptFriendRequest/$uid1/$uid2";
    try {
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
      );
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteFriendRequest(int uid1, int uid2) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/friend/$uid1/$uid2";
    try {
      final response = await http.delete(
        url,
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
      );
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<List<Map<String, dynamic>>> getUserListInfo(List<dynamic> data) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    try {
      List<Map<String, dynamic>> loadedData = [];
      for (final element in data) {
        User user;
        await getUser(element["user_uid"]).then((value) {
          user = value;
        });
        loadedData.add({
          "imgUrl": user.imgUrl,
          "name": '${user.firstName} ${user.lastName}',
          "isCompleted": element["isCompleted"],
          "joinedD": DateTime.parse(element["joinedD"])
        });
      }
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> postUsage(int uid, DateTime dateTime, String use) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/activity";
    try {
      var body = json.encode(
        ({'uid': uid, "timestamp": dateTime.toString(), "activity": use}),
      );

      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: body,
      );
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<List<User>> getBlockList(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/userBlockedFriend/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      print(extractData);
      if (extractData == null) {
        return null;
      }
      List<User> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(User(
            uid: data['uid'],
            firstName: data['firstName'],
            lastName: data['lastName'],
            imgUrl: data['imgUrl']));
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> postReport(int uid, Report report) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/report";
    try {
      var body = json.encode(
        ({
          'uid': uid,
          'type': report.type,
          'reason': report.reason,
          'note': report.note.toString(),
          'timestamp': report.datetime.toString()
        }),
      );

      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: body,
      );
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<void> postHidePost(
      int uid, int post_uid, int post_gid, DateTime post_timestamp) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/hidePost";
    try {
      var body = json.encode(
        ({
          'uid': uid,
          'post_uid': post_uid,
          'post_gid': post_gid,
          'post_timestamp': post_timestamp.toString(),
        }),
      );

      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: body,
      );
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateBlock(
      int blockerUid, int blockedUid, DateTime dateTime) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/blockUser";
    try {
      var body = json.encode(
        ({
          'blocker_uid': blockerUid,
          'blocked_uid': blockedUid,
          'timestamp': dateTime.toString(),
        }),
      );

      final response = await http.put(
        url,
        headers: {
          'content-type': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: body,
      );
      print(response.body);
    } catch (error) {
      print(error);
    }
  }
}
