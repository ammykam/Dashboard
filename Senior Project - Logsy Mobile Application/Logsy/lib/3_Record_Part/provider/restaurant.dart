import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;

class Restaurant {
  final int branchID;
  final int rid;
  final String name;
  final String address;
  final String openT;
  final String closeT;
  final double latitude;
  final double longitude;
  final String imgUrl;
  final int verified;

  Restaurant({
    @required this.branchID,
    @required this.rid,
    this.name,
    this.address,
    this.openT,
    this.closeT,
    this.latitude,
    this.longitude,
    this.imgUrl,
    this.verified,
  });
}

class RestaurantProvider with ChangeNotifier {


   final endUrl = dotenv.env['endUrl'];
  Future<List<Restaurant>> getRestaurant() async {
     final user = u.FirebaseAuth.instance.currentUser;
    // final token = await user.getIdToken(true);
     final token = await user.getIdToken();
    final url = "$endUrl/restaurant";
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      final extractData = json.decode(response.body) as List<dynamic>;
      List<Restaurant> loadedData = [];

      if (extractData == null) {
        return null;
      }
      extractData.forEach((element) {
        loadedData.add(
          Restaurant(
              branchID: element['branchID'],
              rid: element['rid'],
              name: element['name'],
              address: element['address'],
              openT: element['openT'],
              closeT: element['closeT'],
              latitude: element['latitude'],
              longitude: element['longitude'],
              imgUrl: element['imgUrl'],
              verified: element['verified']),
        );
      });
      return loadedData;
    } catch (error) {
      print(error);
    }
  }

  Future<List<int>> getDistance(Position position) async {
    List<Restaurant> res = await getRestaurant();
    List<int> sortRes = [];
    List<Map<String, dynamic>> _distance = [];

    for (final element in res) {
      double distanceInMeters = await Geolocator().distanceBetween(
          position.latitude,
          position.longitude,
          element.latitude,
          element.longitude);
      _distance.add({'bid': element.branchID, 'distance': distanceInMeters});
    }
    _distance.sort((a, b) => a['distance'].compareTo(b['distance']));

    for (final element in _distance) {
      sortRes.add(element['bid']);
    }
    return sortRes;
  }
}
