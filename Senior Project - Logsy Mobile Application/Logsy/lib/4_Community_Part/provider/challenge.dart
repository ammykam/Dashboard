import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class Challenge {
  final int cid;
  final int group_gid;
  final int user_uidCreator;
  final String name;
  final String category;
  final String level;
  final DateTime startD;
  final DateTime endD;
  final String des;
  final int theme;

  Challenge(
      {@required this.cid,
      @required this.group_gid,
      @required this.user_uidCreator,
      this.name,
      this.category,
      this.level,
      this.startD,
      this.endD,
      this.des,
      this.theme});
}

class ChallengeProvider with ChangeNotifier {
 

   final endUrl = dotenv.env['endUrl'];
  Future<List<Challenge>> getChallenges() async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/challenge";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }

      List<Challenge> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(Challenge(
            cid: data['cid'],
            group_gid: data['group_gid'],
            user_uidCreator: data['user_uidCreator'],
            name: data['name'],
            category: data['category'],
            level: data['level'],
            startD: DateTime.parse(data['startD']),
            endD: DateTime.parse(data['endD']),
            des: data['des'],
            theme: data['theme']));
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<Challenge> getChallenge(int cid) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/challenge/$cid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      final data = extractData[0] as Map<String, dynamic>;
      Challenge loadedData = Challenge(
          cid: data['cid'],
          group_gid: data['group_gid'],
          user_uidCreator: data['user_uidCreator'],
          name: data['name'],
          category: data['category'],
          level: data['level'],
          startD: DateTime.parse(data['startD']),
          endD: DateTime.parse(data['endD']),
          des: data['des'],
          theme: data['theme']);
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<Challenge>> getChallengeGroupCurrent(int gid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/challengeGroupCurrent/$gid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }

      List<Challenge> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(Challenge(
            cid: data['cid'],
            group_gid: data['group_gid'],
            user_uidCreator: data['user_uidCreator'],
            name: data['name'],
            category: data['category'],
            level: data['level'],
            startD: DateTime.parse(data['startD']),
            endD: DateTime.parse(data['endD']),
            des: data['des'],
            theme: data['theme']));
      });

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<Challenge>> getChallengeGroupUpcoming(int gid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/challengeGroupUpcoming/$gid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }

      List<Challenge> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(Challenge(
            cid: data['cid'],
            group_gid: data['group_gid'],
            user_uidCreator: data['user_uidCreator'],
            name: data['name'],
            category: data['category'],
            level: data['level'],
            startD: DateTime.parse(data['startD']),
            endD: DateTime.parse(data['endD']),
            des: data['des'],
            theme: data['theme']));
      });

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<Challenge>> getChallengeGroupExpired(int gid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/challengeGroupExpired/$gid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }

      List<Challenge> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(Challenge(
            cid: data['cid'],
            group_gid: data['group_gid'],
            user_uidCreator: data['user_uidCreator'],
            name: data['name'],
            category: data['category'],
            level: data['level'],
            startD: DateTime.parse(data['startD']),
            endD: DateTime.parse(data['endD']),
            des: data['des'],
            theme: data['theme']));
      });

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> createChallenge(Challenge challenge) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/challenge";
    try {
      var body = json.encode(
        ({
          'cid': challenge.cid,
          'group_gid': challenge.group_gid,
          'user_uidCreator': challenge.user_uidCreator,
          'name': challenge.name,
          'category': challenge.category,
          'level': challenge.level,
          'startD': challenge.startD.toString(),
          'endD': challenge.endD.toString(),
          'des': challenge.des,
          'theme': challenge.theme
        }),
      );

      final response = await http.post(url,
          headers: {
            'content-type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: body);
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<void> joinChallenge(int user_uid, int challenge_cid, DateTime joinedD,
      String complete) async {
   final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/joinChallenge";
    try {
      var body = json.encode(
        ({
          'user_uid': user_uid,
          'challenge_cid': challenge_cid,
          'joinedD': joinedD.toString(),
          'isCompleted': complete,
        }),
      );
      final response = await http.post(url,
          headers: {
            'content-type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: body);
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<void> completeChallenge(int uid, int cid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/completeChallenge/$uid/$cid";
    try {
      final response = await http.post(url, headers: {
        'content-type': 'application/json',
        "Authorization": "Bearer $token"
      });
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<String> getChallengeUserStatus(int uid, int cid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/challengeUserStatus/$uid/$cid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});

      return response.body;
    } catch (error) {
      print(error);
    }
  }

  Future<List<dynamic>> getJoinListChallenge(int cid) async {
 final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/joinUser/$cid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      return json.decode(response.body);
    } catch (error) {
      print(error);
    }
  }
}
