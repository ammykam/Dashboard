import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/2_Plan_Part/screen/history_screen.dart';
import 'package:logsy_app/3_Record_Part/provider/exerciseRecord.dart';
import 'package:logsy_app/3_Record_Part/provider/food.dart';
import 'package:logsy_app/3_Record_Part/provider/foodRecord.dart';
import 'package:logsy_app/3_Record_Part/provider/foodRequest.dart';
import 'package:logsy_app/3_Record_Part/provider/restaurant.dart';
import 'package:logsy_app/3_Record_Part/screen/food_detail_screen.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/maps_screen.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as l;

class PlanScreen extends StatefulWidget {
  static const routeName = '/plan';

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  bool _isInit = true;

  FoodRequest foodData;
  FoodRequest snackData;
  List<FoodRequest> _recommendFood = [];
  List<int> _ateRec = [];
  bool _ateFood = false;
  bool _ateSnack = false;
  bool _isRefreshFood = false;
  bool _isRefreshSnack = false;
  //breakfast, lunch, dinner
  String time;
  String img;

  //Position
  Position _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  // _getCurrentLocation() {
  //   Geolocator().getCurrentPosition().then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //     _getAddressFromLatLng();
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await Geolocator().placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.subAdministrativeArea}, ${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final user = Provider.of<UserProvider>(context, listen: false);
      final foodRec = Provider.of<FoodRecordProvider>(context, listen: false);
      final foodRe = Provider.of<FoodRequestProvider>(context, listen: false);
      final res = Provider.of<RestaurantProvider>(context, listen: false);

      //check eat yet
      bool _eatBreak = false;
      bool _eatLunch = false;
      bool _eatDinner = false;
      bool _eatSnack = false;

      final foodList =
          await foodRec.getFoodRecordDay(user.loginUser, DateTime.now());
      for (final element in foodList) {
        if (element.type == "breakfast") {
          _eatBreak = true;
        } else if (element.type == "lunch") {
          _eatLunch = true;
        } else if (element.type == "dinner") {
          _eatDinner = true;
        } else if (element.type == "snack") {
          _eatSnack = true;
        }
      }

      // to present user's current location
      l.Location location_new = new l.Location();

      bool _serviceEnabled;
      l.PermissionStatus _permissionGranted;
      l.LocationData _locationData;

      _serviceEnabled = await location_new.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location_new.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location_new.hasPermission();
      if (_permissionGranted == l.PermissionStatus.denied) {
        _permissionGranted = await location_new.requestPermission();
        if (_permissionGranted != l.PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location_new.getLocation();
      Position position = Position(
          latitude: _locationData.latitude, longitude: _locationData.longitude);
      _currentPosition = position;
      _getAddressFromLatLng();
      //_getCurrentLocation();
      // to send to measure length
      //Position position = await Geolocator().getCurrentPosition();
      List<int> _sortRes = await res.getDistance(position);
      

      //recommendFood
      await foodRe.getRecommendFood(user.loginUser, _sortRes).then((value) {
        print(value);
        _recommendFood = value;
      });

      //get moment (morning, afternoon, evening)
      final hour = DateTime.now().hour;

      if (hour < 12) {
        time = "Breakfast";
        img = "breakfast";
        await foodRe.getBreakfast(user.loginUser, _sortRes, 0).then((value) {
          foodData = value;
        });
        await foodRe.getSnack(user.loginUser, _sortRes, 0).then((value) {
          snackData = value;
        });
        //check eat yet??
        _ateFood = _eatBreak;
        _ateSnack = _eatSnack;
      } else if (hour < 18) {
        time = "Lunch";
        img = "lunch-box";
        await foodRe.getLunch(user.loginUser, _sortRes, 0).then((value) {
          foodData = value;
        });
        await foodRe.getSnack(user.loginUser, _sortRes, 0).then((value) {
          snackData = value;
        });
        //check eat yet??
        _ateFood = _eatLunch;
        _ateSnack = _eatSnack;
      } else {
        time = "Dinner";
        img = "wedding-dinner";
        await foodRe.getDinner(1, _sortRes, 0).then((value) {
          foodData = value;
        });
        await foodRe.getSnack(1, _sortRes, 0).then((value) {
          snackData = value;
        });
        //check eat yet??
        _ateFood = _eatDinner;
        _ateSnack = _eatSnack;
      }
      setState(() {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _notifyUsage() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.postUsage(user.loginUser, DateTime.now(), "RefreshRecommend");
  }

  void _refreshFood() async {
    setState(() {
      _isRefreshFood = true;
    });
    final user = Provider.of<UserProvider>(context, listen: false);
    final foodRe = Provider.of<FoodRequestProvider>(context, listen: false);
    final res = Provider.of<RestaurantProvider>(context, listen: false);

    l.Location location_new = new l.Location();

    bool _serviceEnabled;
    l.PermissionStatus _permissionGranted;
    l.LocationData _locationData;

    _serviceEnabled = await location_new.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location_new.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location_new.hasPermission();
    if (_permissionGranted == l.PermissionStatus.denied) {
      _permissionGranted = await location_new.requestPermission();
      if (_permissionGranted != l.PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location_new.getLocation();
    
    Position position = Position(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
        _currentPosition = position;
        
    //to present user's current location
    //_getCurrentLocation();
    // to send to measure length
    //Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<int> _sortRes = await res.getDistance(position);

    //get moment (morning, afternoon, evening)
    final hour = DateTime.now().hour;
    if (hour < 12) {
      await foodRe.getBreakfast(user.loginUser, _sortRes, 1).then((value) {
        foodData = value;
      });
    } else if (hour < 18) {
      await foodRe.getLunch(user.loginUser, _sortRes, 1).then((value) {
        foodData = value;
      });
    } else {
      await foodRe.getDinner(1, _sortRes, 1).then((value) {
        foodData = value;
      });
    }
    setState(() {
      _isRefreshFood = false;
    });
  }

  void _refreshSnack() async {
    setState(() {
      _isRefreshSnack = true;
    });
    final user = Provider.of<UserProvider>(context, listen: false);
    final foodRe = Provider.of<FoodRequestProvider>(context, listen: false);
    final res = Provider.of<RestaurantProvider>(context, listen: false);

    l.Location location_new = new l.Location();

    bool _serviceEnabled;
    l.PermissionStatus _permissionGranted;
    l.LocationData _locationData;

    _serviceEnabled = await location_new.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location_new.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location_new.hasPermission();
    if (_permissionGranted == l.PermissionStatus.denied) {
      _permissionGranted = await location_new.requestPermission();
      if (_permissionGranted != l.PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location_new.getLocation();
    Position position = Position(
        latitude: _locationData.latitude, longitude: _locationData.longitude);
        _currentPosition = position;
    //to present user's current location
    //_getCurrentLocation();
    // to send to measure length
    //Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<int> _sortRes = await res.getDistance(position);

    //get moment (morning, afternoon, evening)
    final hour = DateTime.now().hour;
    if (hour < 12) {
      await foodRe.getSnack(user.loginUser, _sortRes, 1).then((value) {
        snackData = value;
      });
    } else if (hour < 18) {
      await foodRe.getSnack(user.loginUser, _sortRes, 1).then((value) {
        snackData = value;
      });
    } else {
      await foodRe.getSnack(1, _sortRes, 1).then((value) {
        snackData = value;
      });
    }
    setState(() {
      _isRefreshSnack = false;
    });
  }

  void _addRecord(int fid) async {
    final foodRecord = Provider.of<FoodRecordProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    //Time
    final hour = DateTime.now().hour;
    if (hour < 12) {
      time = "breakfast";
    } else if (hour < 18) {
      time = "lunch";
    } else {
      time = "dinner";
    }
    await foodRecord.addFoodRecord(
      FoodRecord(
          foodRecID: 0,
          user_uid: user.loginUser,
          food_fid: fid,
          timestamp: DateTime.now(),
          type: time),
    );
    setState(() {
      _ateFood = true;
    });
  }

  void _addSnack() async {
    final foodRecord = Provider.of<FoodRecordProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);

    await foodRecord.addFoodRecord(
      FoodRecord(
          foodRecID: 0,
          user_uid: user.loginUser,
          food_fid: snackData.fid,
          timestamp: DateTime.now(),
          type: "snack"),
    );
    setState(() {
      _ateSnack = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _recommendMenu(String imgUrl, String name, String location, int fid,
      int bid, bool _checkAte, FoodRequest foodData) {
    return _checkAte
        ? Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Material(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: AssetImage("assets/happy.png"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text("You ate"),
                            SizedBox(height: 5),
                            Text(name),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10)
                ],
              ),
              SizedBox(height: 10),
            ],
          )
        : GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(FoodDetailScreen.routeName, arguments: [
                Food(
                    fid: foodData.fid,
                    type: foodData.type,
                    category: foodData.category,
                    name: foodData.name,
                    calories: foodData.calories,
                    carb: foodData.carb,
                    protein: foodData.protein,
                    fat: foodData.fat,
                    fiber: foodData.fiber,
                    des: foodData.des,
                    imgUrl: foodData.imgUrl,
                    verified: foodData.verified),
                time,
              ]);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 10),
                    Material(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                              bottom: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: NetworkImage(imgUrl),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(name),
                              SizedBox(height: 5),
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints.tightFor(height: 25),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromRGBO(236, 234, 211, 1)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      )),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          MapsScreen.routeName,
                                          arguments: [
                                            bid,
                                            _currentPosition,
                                            foodData
                                          ]);
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset("assets/googlemaps.png",
                                            width: 15, height: 15),
                                        SizedBox(width: 3),
                                        Text(
                                          "Nearby Restaurant",
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                              ),
                              ButtonTheme(
                                height: 30,
                                minWidth: 120,
                                child: FlatButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          content: Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            Icon(Icons.close)),
                                                  ],
                                                ),
                                                Image.asset(
                                                    "assets/Popup/${img}.png",
                                                    width: 90,
                                                    height: 90),
                                                SizedBox(height: 20),
                                                Text("Yayy!",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 20),
                                                Text('Your $time is ready!',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15)),
                                                Text('Continue to eat ',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15)),
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 20),
                                                ButtonTheme(
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: RaisedButton(
                                                    child: Text('Continue',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    color: Colors.green,
                                                    onPressed: () {
                                                      _addRecord(fid);
                                                      setState(() {
                                                        _ateRec.add(fid);
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.amber,
                                  child: Text(
                                    "EAT",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10)
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RECOMMENDATION',
          style: TextStyle(
              fontSize: 18,
              color: Colors.teal[500],
              fontWeight: FontWeight.bold),
        ),
        elevation: 4.0,
        backgroundColor: Colors.white,
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.of(context).pushNamed(HistoryScreen.routeName);
        //   },
        //   child: Icon(
        //     Icons.history,
        //     color: Colors.teal,
        //   ),
        // ),
        bottom: PreferredSize(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(5),
            width: double.infinity,
            child: Row(
              children: [
                //Image.asset("assets/googlemaps.png", width:30 ,height:30),
                Icon(
                  Icons.location_pin,
                  size: 30,
                  color: Colors.teal[200],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Location",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    Text(_currentAddress != null ? _currentAddress : "",
                        style: TextStyle(color: Colors.teal)),
                  ],
                )
              ],
            ),
          ),
          preferredSize: Size.fromHeight(50.0),
        ),
      ),
      body: foodData == null || snackData == null
          ? LinearProgressIndicator(
              backgroundColor: Colors.white,
              minHeight: 0.5,
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 5),
                  // Meal
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                              color: Colors.teal[400],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      time,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                        DateFormat('dd MMMM y')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                                _ateFood
                                    ? Container()
                                    : _isRefreshFood
                                        ? SpinKitDualRing(
                                            color: Colors.white,
                                            size: 20,
                                            lineWidth: 2,
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              _notifyUsage();
                                              _refreshFood();
                                            },
                                            child: Icon(Icons.refresh,
                                                color: Colors.white),
                                          )
                              ],
                            ),
                          ),
                          _ateFood
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Image.asset('assets/happy.png',
                                          width: 150, height: 150),
                                      Center(
                                        child: Text(
                                          "You already ate $time!",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        FoodDetailScreen.routeName,
                                        arguments: [
                                          Food(
                                              fid: foodData.fid,
                                              type: foodData.type,
                                              category: foodData.category,
                                              name: foodData.name,
                                              calories: foodData.calories,
                                              carb: foodData.carb,
                                              protein: foodData.protein,
                                              fat: foodData.fat,
                                              fiber: foodData.fiber,
                                              des: foodData.des,
                                              imgUrl: foodData.imgUrl,
                                              verified: foodData.verified),
                                          time,
                                        ]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Text(foodData.name,
                                            style: TextStyle(
                                                color: Colors.teal[300],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        SizedBox(height: 8),
                                        Container(
                                          height: 80,
                                          width: 160,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: NetworkImage(foodData
                                                            .imgUrl ==
                                                        ""
                                                    ? "https://i.pinimg.com/736x/08/83/ff/0883ff5fef6c6653e62073223f1ba533.jpg"
                                                    : foodData.imgUrl),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  foodData.calories.toString(),
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  "Cal",
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 20),
                                            Column(
                                              children: [
                                                Text(foodData.carb.toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                Text("Carb",
                                                    style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            SizedBox(width: 20),
                                            Column(
                                              children: [
                                                Text(
                                                    foodData.protein.toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                Text("Protein",
                                                    style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            SizedBox(width: 20),
                                            Column(
                                              children: [
                                                Text(foodData.fat.toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                Text("Fat",
                                                    style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     Navigator.of(context).pushNamed(
                                        //         MapsScreen.routeName,
                                        //         arguments: [
                                        //           foodData.branchID,
                                        //           _currentPosition,
                                        //           foodData
                                        //         ]);
                                        //   },
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     children: [
                                        //       Image.asset("assets/googlemaps.png",
                                        //           width: 30, height: 30),
                                        //       Text(
                                        //         foodData.branchName,
                                        //         style:
                                        //             TextStyle(color: Colors.grey),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      height: 30),
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Color.fromRGBO(
                                                                    236,
                                                                    234,
                                                                    211,
                                                                    1)),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    )),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            MapsScreen
                                                                .routeName,
                                                            arguments: [
                                                          foodData.branchID,
                                                          _currentPosition,
                                                          foodData
                                                        ]);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                          "assets/googlemaps.png",
                                                          width: 15,
                                                          height: 15),
                                                      SizedBox(width: 3),
                                                      Text(
                                                        "Nearby Restaurant",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            ButtonTheme(
                                              height: 30,
                                              minWidth: 120,
                                              child: FlatButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible:
                                                        false, // user must tap button!
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30))),
                                                        content: Container(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Icon(
                                                                          Icons
                                                                              .close)),
                                                                ],
                                                              ),
                                                              Image.asset(
                                                                  "assets/Popup/${img}.png",
                                                                  width: 90,
                                                                  height: 90),
                                                              SizedBox(
                                                                  height: 20),
                                                              Text("Yayy!",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontSize:
                                                                          25,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              SizedBox(
                                                                  height: 20),
                                                              Text(
                                                                  'Your $time is ready!',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          15)),
                                                              Text(
                                                                  'Continue to eat ',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          15)),
                                                              Text(
                                                                foodData.name,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              SizedBox(
                                                                  height: 20),
                                                              ButtonTheme(
                                                                minWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child:
                                                                    RaisedButton(
                                                                  child: Text(
                                                                      'Continue',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  color: Colors
                                                                      .green,
                                                                  onPressed:
                                                                      () {
                                                                    _addRecord(
                                                                        foodData
                                                                            .fid);

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                color: Colors.amber,
                                                child: Text(
                                                  "EAT",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  //Snack
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                              color: Colors.teal[400],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Snack',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                        DateFormat('dd MMMM y')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                                _ateSnack
                                    ? Container()
                                    : _isRefreshSnack
                                        ? SpinKitDualRing(
                                            color: Colors.white,
                                            size: 20,
                                            lineWidth: 2,
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              _notifyUsage();
                                              _refreshSnack();
                                            },
                                            child: Icon(Icons.refresh,
                                                color: Colors.white))
                              ],
                            ),
                          ),
                          _ateSnack
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Image.asset('assets/happy2.png',
                                          width: 150, height: 150),
                                      Center(
                                        child: Text(
                                          "You already ate snack!",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        FoodDetailScreen.routeName,
                                        arguments: [
                                          Food(
                                              fid: snackData.fid,
                                              type: snackData.type,
                                              category: snackData.category,
                                              name: snackData.name,
                                              calories: snackData.calories,
                                              carb: snackData.carb,
                                              protein: snackData.protein,
                                              fat: snackData.fat,
                                              fiber: snackData.fiber,
                                              des: snackData.des,
                                              imgUrl: snackData.imgUrl,
                                              verified: snackData.verified),
                                          time,
                                        ]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snackData.name,
                                          style: TextStyle(
                                              color: Colors.teal[300],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: Container(
                                                  height: 80,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            snackData.imgUrl ==
                                                                    ""
                                                                ? "https://i.pinimg.com/736x/08/83/ff/0883ff5fef6c6653e62073223f1ba533.jpg"
                                                                : snackData
                                                                    .imgUrl),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          snackData.calories
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                        ),
                                                        Text(
                                                          ' Calories',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    ButtonTheme(
                                                      height: 30,
                                                      child: FlatButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false, // user must tap button!
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(30))),
                                                                content:
                                                                    Container(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Icon(Icons.close)),
                                                                        ],
                                                                      ),
                                                                      Image.asset(
                                                                          "assets/Popup/snack.png",
                                                                          width:
                                                                              90,
                                                                          height:
                                                                              90),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          "Yayy!",
                                                                          style: TextStyle(
                                                                              color: Colors.green,
                                                                              fontSize: 25,
                                                                              fontWeight: FontWeight.bold)),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                          'Your snack is ready!',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 15)),
                                                                      Text(
                                                                          'Continue to eat',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 15)),
                                                                      Text(
                                                                        snackData
                                                                            .name,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      ButtonTheme(
                                                                        minWidth:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.4,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            RaisedButton(
                                                                          child: Text(
                                                                              'Continue',
                                                                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                                                                          color:
                                                                              Colors.green,
                                                                          onPressed:
                                                                              () {
                                                                            _addSnack();
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        color: Colors.amber,
                                                        child: Text(
                                                          "EAT",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //Recommend
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Your Favorite Menu",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: _recommendFood
                                  .map((e) => _recommendMenu(
                                      e.imgUrl,
                                      e.name,
                                      e.branchName,
                                      e.fid,
                                      e.branchID,
                                      _ateRec.contains(e.fid),
                                      e))
                                  .toList()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
