import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class Group {
  final int gid;
  final int user_uid;
  final String name;
  final String type;
  final String des;
  final double latitude;
  final double longtitude;
  final String imgUrl;

  Group(
      {@required this.gid,
      this.user_uid,
      this.name,
      this.type,
      this.des,
      this.latitude,
      this.longtitude,
      this.imgUrl});
}

class Scoreboard {
  final int uid;
  final String name;
  final String imgUrl;
  final int gid;
  final int score;

  Scoreboard({
    this.uid,
    this.name,
    this.imgUrl,
    this.gid,
    this.score,
  });
}

class GroupProvider with ChangeNotifier {
 

   final endUrl = dotenv.env['endUrl'];
  List<Group> allGroup;

  Future<void> getGroups() async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/group";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      final List<Group> loadedData = [];
      if (extractData == null) {
        return null;
      } else {
        extractData.forEach((element) {
          final data = element as Map<String, dynamic>;
          loadedData.add(
            Group(
                gid: data['gid'],
                user_uid: data['user_uid'],
                name: data['name'],
                type: data['type'],
                des: data['des'],
                latitude: data['latitude'],
                longtitude: data['longtitude'],
                imgUrl: data['imgUrl']),
          );
        });
      }
      notifyListeners();
      allGroup = loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<Group> getGroup(int gid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/group/$gid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;

      if (extractData == null) {
        return null;
      }
      final data = extractData[0] as Map<String, dynamic>;
      Group loadedData = Group(
          gid: data['gid'],
          user_uid: data['user_uid'],
          name: data['name'],
          type: data['type'],
          des: data['des'],
          latitude: data['latitude'],
          longtitude: data['longtitude'],
          imgUrl: data['imgUrl']);
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<User>> getGroupMember(int gid, int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/groupMember/$gid/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      final List<User> loadedData = [];
      if (extractData == null) {
        return null;
      }
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
    } catch (error) {}
  }

  Future<List<Scoreboard>> getScoreboard(int gid, int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/scoreboard/$gid/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      final List<Scoreboard> loadedData = [];
      if (extractData == null) {
        return null;
      }
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(Scoreboard(
            uid: data['user_uid'],
            gid: data['group_gid'],
            score: data['score'],
            name: data["firstName"],
            imgUrl: data["imgUrl"]));
      });
      loadedData.sort((a, b) => (a.score).compareTo(b.score));

      notifyListeners();
      //From max to min
      return loadedData.reversed.toList();
    } catch (error) {
      print(error);
    }
  }

  Future<String> createGroup(Group group) async {
  final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/group";
    try {
      var body = json.encode(
        ({
          'gid': group.gid,
          'user_uid': group.user_uid,
          'name': group.name,
          'type': group.type,
          'des': group.des,
          'latitude': group.latitude,
          'longitude': group.longtitude,
          'imgUrl': group.imgUrl,
        }),
      );

      final response = await http.post(url,
          headers: {
            'content-type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: body);

      notifyListeners();
      return response.body;
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateGroup(Group group) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/group";
    try {
      var body = json.encode(
        ({
          'gid': group.gid,
          'user_uid': group.user_uid,
          'name': group.name,
          'type': group.type,
          'des': group.des,
          'latitude': group.latitude,
          'longtitude': group.longtitude,
          'imgUrl': group.imgUrl,
        }),
      );

      final response = await http.put(url,
          headers: {
            'content-type': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: body);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<List<Group>> userGroup(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/groupList/$uid";
    try {
      await getGroups();
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;

      if (extractData == null) {
        return null;
      }
      List<Group> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(allGroup
            .where((element) => element.gid == data['logsygroup_gid'])
            .toList()[0]);
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<Group>> getGroupInvite(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/groupInvitationList/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      List<Group> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(Group(
            gid: data['gid'],
            name: data['name'],
            des: data['des'],
            imgUrl: data['imgUrl']));
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> createGroupInvite(List<Map<String, dynamic>> data) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/groupInvitation";
    try {
      var body = json.encode(data);
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

  Future<void> updateStatus(int uid, int gid, String status) async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/groupStatus/$uid/$gid/$status";
    try {
      final response =
          await http.put(url, headers: {"Authorization": "Bearer $token"});
      print(response.body);
    } catch (error) {
      print(error);
    }
  }

  Future<String> getGroupStatus(int uid, int gid) async {
   final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/memberStatus/$uid/$gid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      notifyListeners();
      return response.body;
    } catch (error) {
      print(error);
    }
  }
}
