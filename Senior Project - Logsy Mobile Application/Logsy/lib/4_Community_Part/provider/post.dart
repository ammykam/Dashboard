import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class Post {
  final int pid;
  final int user_uid;
  final int group_gid;
  final String content;
  final String imgUrl;

  final DateTime timestamp;

  Post(
      {@required this.pid,
      this.user_uid,
      this.group_gid,
      this.content,
      this.imgUrl,
      this.timestamp});
}

class PostProvider with ChangeNotifier {
  final endUrl = dotenv.env['endUrl'];
  Future<List<Post>> getAllPost(int gid, int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/allPost/$gid/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      final List<Post> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(
          Post(
              pid: data['pid'],
              user_uid: data['user_uid'],
              group_gid: data['group_gid'],
              content: data['content'],
              imgUrl: data['imgUrl'],
              timestamp: DateTime.parse(data['timestamp'])),
        );
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<Post> getPost(int uid, int gid, String dateTime) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/post/$uid/$gid/$dateTime";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      final data = extractData[0] as Map<String, dynamic>;
      final Post loadedData = Post(
          pid: data['pid'],
          user_uid: data['user_uid'],
          group_gid: data['group_gid'],
          content: data['content'],
          imgUrl: data['imgUrl'],
          timestamp: DateTime.parse(data['timestamp']));

      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<void> createPost(Post post) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/post";
    try {
      var body = json.encode(
        ({
          'pid': post.pid,
          'user_uid': post.user_uid,
          'group_gid': post.group_gid,
          'content': post.content,
          'imgUrl': post.imgUrl,
          'timestamp': post.timestamp.toString(),
        }),
      );

      final response = await http.post(url,
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

  Future<List<Post>> getPostWithUser(int uid) async {
    final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
    final token = await user.getIdToken();
    final url = "$endUrl/feed/$uid";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      if (extractData == null) {
        return null;
      }
      List<Post> loadedData = [];
      extractData.forEach((element) {
        final data = element as Map<String, dynamic>;
        loadedData.add(Post(
            pid: data['pid'],
            user_uid: data['user_uid'],
            group_gid: data['group_gid'],
            content: data['content'],
            imgUrl: data['imgUrl'],
            timestamp: DateTime.parse(data['timestamp'])));
      });
      notifyListeners();
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  
}
