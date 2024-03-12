import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/1_Dashboard_Part/widget/eat_meal_detail.dart';
import 'package:logsy_app/3_Record_Part/provider/foodRecord.dart';
import 'package:logsy_app/3_Record_Part/provider/waterRecord.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class EatDateItem extends StatefulWidget {
  final DateTime dateSelect;

  EatDateItem(this.dateSelect);
  @override
  _EatDateItemState createState() => _EatDateItemState();
}

class _EatDateItemState extends State<EatDateItem> {
  bool _sun = false;
  bool _mon = false;
  bool _tue = false;
  bool _wed = false;
  bool _thu = false;
  bool _fri = false;
  bool _sat = false;
  bool _collapse = false;
  bool _isInit = true;
  DateTime _selectDate;
  List<FoodRecord> _foodRecord = [];
  List<WaterRecord> _waterRecord = [];
  List<Map<String, dynamic>> _allFood = [];
  Map<String, dynamic> _presentFood;
  DateTime startDate;

  @override
  void didUpdateWidget(covariant EatDateItem oldWidget) {
    _sun = false;
    _mon = false;
    _tue = false;
    _wed = false;
    _thu = false;
    _fri = false;
    _sat = false;
    _collapse = false;
    _isInit = true;
    startDate = widget.dateSelect.weekday == 7
        ? widget.dateSelect
        : widget.dateSelect.subtract(Duration(days: widget.dateSelect.weekday));
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final user = Provider.of<UserProvider>(context, listen: false);
      final foodRec = Provider.of<FoodRecordProvider>(context, listen: false);
      final waterRec = Provider.of<WaterRecordProvider>(context, listen: false);
      startDate = widget.dateSelect.weekday == 7
          ? widget.dateSelect
          : widget.dateSelect
              .subtract(Duration(days: widget.dateSelect.weekday));

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

  Widget _date(DateTime date, bool day) {
    return Column(children: [
      Text(
        DateFormat('EEE').format(date).toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
      SizedBox(height: 10),
      day
          ? Stack(
              alignment: AlignmentDirectional.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 13.0,
                ),
                Text(
                  DateFormat('dd').format(date),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.teal[200]),
                ),
              ],
            )
          : Stack(
              alignment: AlignmentDirectional.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 13.0,
                ),
                Text(
                  DateFormat('dd').format(date),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white),
                ),
              ],
            )
    ]);
  }

  Widget _eachDay(DateTime date, List<dynamic> breakfast, List<dynamic> lunch,
      List<dynamic> dinner, List<dynamic> snack, int water) {
    print(breakfast);
    return Column(
      children: [
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
    // return Container();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      color: Colors.teal[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_sun) {
                      _collapse = false;
                    } else {
                      _collapse = true;
                    }
                    _sun = !_sun;
                    _mon = false;
                    _tue = false;
                    _wed = false;
                    _thu = false;
                    _fri = false;
                    _sat = false;

                    _selectDate = startDate;
                    var index = _allFood.indexWhere((element) =>
                        DateFormat('d/MM/y').format(element['timestamp']) ==
                        DateFormat('d/MM/y').format(_selectDate));

                    if (index != -1) {
                      setState(() {
                        _presentFood = _allFood[index];
                      });
                    } else {
                      setState(() {
                        _presentFood = null;
                      });
                    }
                  });
                },
                child: _date(startDate, _sun),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_mon) {
                      _collapse = false;
                    } else {
                      _collapse = true;
                    }
                    _mon = !_mon;
                    _sun = false;
                    _tue = false;
                    _wed = false;
                    _thu = false;
                    _fri = false;
                    _sat = false;
                    _selectDate = startDate.add(Duration(days: 1));
               
                    var index = _allFood.indexWhere((element) =>
                        DateFormat('d/MM/y').format(element['timestamp']) ==
                        DateFormat('d/MM/y').format(_selectDate));

                  
                   if (index != -1) {
                      setState(() {
                        _presentFood = _allFood[index];
                      });
                      print(_presentFood);
                    } else {
                      setState(() {
                        _presentFood = null;
                      });
                    }
                  });
                },
                child: _date(startDate.add(Duration(days: 1)), _mon),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_tue) {
                      _collapse = false;
                    } else {
                      _collapse = true;
                    }
                    _tue = !_tue;
                    _mon = false;
                    _sun = false;
                    _wed = false;
                    _thu = false;
                    _fri = false;
                    _sat = false;
                    _selectDate = startDate.add(Duration(days: 2));

                    var index = _allFood.indexWhere((element) =>
                        DateFormat('d/MM/y').format(element['timestamp']) ==
                        DateFormat('d/MM/y').format(_selectDate));

                    if (index != -1) {
                      setState(() {
                        _presentFood = _allFood[index];
                      });
                    } else {
                      setState(() {
                        _presentFood = null;
                      });
                    }
                  });
                },
                child: _date(startDate.add(Duration(days: 2)), _tue),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_wed) {
                      _collapse = false;
                    } else {
                      _collapse = true;
                    }
                    _wed = !_wed;
                    _mon = false;
                    _tue = false;
                    _sun = false;
                    _thu = false;
                    _fri = false;
                    _sat = false;
                    _selectDate = startDate.add(Duration(days: 3));

                    var index = _allFood.indexWhere((element) =>
                        DateFormat('d/MM/y').format(element['timestamp']) ==
                        DateFormat('d/MM/y').format(_selectDate));
                    if (index != -1) {
                      setState(() {
                        _presentFood = _allFood[index];
                      });
                    } else {
                      setState(() {
                        _presentFood = null;
                      });
                    }
                  });
                },
                child: _date(startDate.add(Duration(days: 3)), _wed),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_thu) {
                      _collapse = false;
                    } else {
                      _collapse = true;
                    }
                    _thu = !_thu;
                    _mon = false;
                    _tue = false;
                    _wed = false;
                    _sun = false;
                    _fri = false;
                    _sat = false;
                    _selectDate = startDate.add(Duration(days: 4));

                    var index = _allFood.indexWhere((element) =>
                        DateFormat('d/MM/y').format(element['timestamp']) ==
                        DateFormat('d/MM/y').format(_selectDate));
                    if (index != -1) {
                      setState(() {
                        _presentFood = _allFood[index];
                      });
                    } else {
                      setState(() {
                        _presentFood = null;
                      });
                    }
                  });
                },
                child: _date(startDate.add(Duration(days: 4)), _thu),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_fri) {
                      _collapse = false;
                    } else {
                      _collapse = true;
                    }
                    _fri = !_fri;
                    _mon = false;
                    _tue = false;
                    _wed = false;
                    _thu = false;
                    _sun = false;
                    _sat = false;
                    _selectDate = startDate.add(Duration(days: 5));

                    var index = _allFood.indexWhere((element) =>
                        DateFormat('d/MM/y').format(element['timestamp']) ==
                        DateFormat('d/MM/y').format(_selectDate));
                    if (index != -1) {
                      setState(() {
                        _presentFood = _allFood[index];
                      });
                    } else {
                      setState(() {
                        _presentFood = null;
                      });
                    }
                  });
                },
                child: _date(startDate.add(Duration(days: 5)), _fri),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_sat) {
                      _collapse = false;
                    } else {
                      _collapse = true;
                    }
                    _sat = !_sat;
                    _mon = false;
                    _tue = false;
                    _wed = false;
                    _thu = false;
                    _fri = false;
                    _sun = false;
                    _selectDate = startDate.add(Duration(days: 6));

                    var index = _allFood.indexWhere((element) =>
                        DateFormat('d/MM/y').format(element['timestamp']) ==
                        DateFormat('d/MM/y').format(_selectDate));
                    if (index != -1) {
                      setState(() {
                        _presentFood = _allFood[index];
                      });
                    } else {
                      setState(() {
                        _presentFood = null;
                      });
                    }
                  });
                },
                child: _date(startDate.add(Duration(days: 6)), _sat),
              ),
            ],
          ),
          //super dummy data
          _collapse
              ? _presentFood == null
                  ? _eachDay(DateTime.now(), [], [], [], [], 0)
                  : _eachDay(
                      _presentFood['timestamp'],
                      _presentFood['breakfast'],
                      _presentFood['lunch'],
                      _presentFood['dinner'],
                      _presentFood['snack'],
                      _presentFood['water'])
              : Container(),
        ],
      ),
    );
  }
}
