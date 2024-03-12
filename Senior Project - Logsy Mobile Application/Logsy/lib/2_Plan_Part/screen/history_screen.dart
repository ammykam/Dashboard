import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/1_Dashboard_Part/widget/eat_meal_detail.dart';
import 'package:logsy_app/3_Record_Part/provider/food.dart';
import 'package:logsy_app/3_Record_Part/provider/foodRecord.dart';
import 'package:logsy_app/3_Record_Part/provider/waterRecord.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = '/history-screen';

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isInit = true;
  List<FoodRecord> _foodRecord = [];
  List<WaterRecord> _waterRecord = [];
  List<Map<String, dynamic>> _allFood = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final user = Provider.of<UserProvider>(context, listen: false);
      final foodRec = Provider.of<FoodRecordProvider>(context, listen: false);
      final waterRec = Provider.of<WaterRecordProvider>(context, listen: false);

      await foodRec.getFoodRecordUser(user.loginUser).then((value) {
        _foodRecord = value;
      });
      await waterRec.getWaterRecordUser(user.loginUser).then((value) {
        _waterRecord = value;
      });
      setState(() {
        _allFood = _setData().reversed.toList();
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List<Map<String, dynamic>> _setData() {
    List<Map<String, dynamic>> dateFoodRecord = [];
    List<Map<String, dynamic>> dateWaterRecord = [];

    _foodRecord.forEach((foodData) {
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

    _waterRecord.forEach((waterData) {
      //time of the food record
      final date = DateFormat('d/MM/y').format(waterData.timestamp);
      //check date exist?
      var contain = dateWaterRecord.where((element) =>
          DateFormat('d/MM/y').format(element['timestamp']) == date);
      if (contain.isEmpty) {
        dateWaterRecord.add({
          'timestamp': waterData.timestamp,
          'waterDataRecord': waterData.volume
        });
      } else {
        int index = dateWaterRecord.indexWhere((element) =>
            DateFormat('d/MM/y').format(element['timestamp']) == date);
        int amountWater =
            dateWaterRecord[index]['waterDataRecord'] + waterData.volume;
        dateWaterRecord[index]['waterDataRecord'] = amountWater;
      }
    });

    dateWaterRecord.forEach((element) {
      int index = dateFoodRecord.indexWhere((data) =>
          DateFormat('d/MM/y').format(data['timestamp']) ==
          DateFormat('d/MM/y').format(element['timestamp']));
      if (index >= 0) {
        dateFoodRecord[index]['water'] = element['waterDataRecord'];
      } else {
        dateFoodRecord.add({
          'timestamp': element['timestamp'],
          'breakfast': [],
          'lunch': [],
          'dinner': [],
          'snack': [],
          'water': element['waterDataRecord']
        });
      }
    });

    dateFoodRecord.sort((a, b) {
      var first = a['timestamp'].compareTo(b['timestamp']);
      if (first != 0) return first;
      return a["timestamp"].compareTo(b["timestamp"]);
    });

    return dateFoodRecord;
  }

  Widget _eachDay(DateTime date, List<dynamic> breakfast, List<dynamic> lunch,
      List<dynamic> dinner, List<dynamic> snack, int water) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          color: Colors.teal[400],
          child: Text(
            DateFormat('EEEE, dd MMMM y').format(date),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 8),
        Column(
          children: breakfast.length == 0
              ? [EatMealDetail("Breakfast", 0)]
              : breakfast
                  .map((data) => EatMealDetail("Breakfast", data))
                  .toList(),
        ),
        Column(
          children: lunch.length == 0
              ? [EatMealDetail("Lunch", 0)]
              : lunch
                  .map(
                    (data) => EatMealDetail("Lunch", data),
                  )
                  .toList(),
        ),
        Column(
          children: dinner.length == 0
              ? [EatMealDetail("Dinner", 0)]
              : dinner
                  .map(
                    (data) => EatMealDetail("Dinner", data),
                  )
                  .toList(),
        ),
        Column(
          children: snack.length == 0
              ? [EatMealDetail("Snack", 0)]
              : snack
                  .map(
                    (data) => EatMealDetail("Snack", data),
                  )
                  .toList(),
        ),
        EatMealDetail("Water", water),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Record',
          style: TextStyle(
              fontSize: 18,
              color: Colors.teal[500],
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _allFood
              .map((data) => _eachDay(data['timestamp'], data['breakfast'],
                  data['lunch'], data['dinner'], data['snack'], data['water']))
              .toList(),
        ),
      ),
    );
  }
}
