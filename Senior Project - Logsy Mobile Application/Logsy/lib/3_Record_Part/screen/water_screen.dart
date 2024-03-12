import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logsy_app/3_Record_Part/provider/waterRecord.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class WaterScreen extends StatefulWidget {
  static const routeName = '/water-screen';

  @override
  _WaterScreenState createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final _waterAmount = TextEditingController();
  int _selectWater = 0;
  int volume = 0;
  final _form = GlobalKey<FormState>();
  bool _isErr = false;

  Widget _waterItemFirst(int _select, String water) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _waterAmount.clear();
        setState(() {
          if (_selectWater == _select) {
            _selectWater = 0;
          } else {
            _selectWater = _select;
            volume = int.parse(water);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: _selectWater == _select ? Colors.teal[300] : Colors.white,
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _selectWater == _select
                  ? 'assets/150_white.png'
                  : 'assets/150.png',
              width: 30,
              height: 30,
            ),
            SizedBox(width: 20),
            Center(
              child: Text(
                '$water ml',
                style: TextStyle(
                  color:
                      _selectWater == _select ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _waterItem(
      int _select, String water, String image, String imageWhite) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _waterAmount.clear();
        setState(() {
          if (_selectWater == _select) {
            _selectWater = 0;
          } else {
            _selectWater = _select;
            volume = int.parse(water);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectWater == _select ? Colors.teal[300] : Colors.white,
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _selectWater == _select ? imageWhite : image,
              width: 30,
              height: 30,
            ),
            SizedBox(width: 20),
            Center(
              child: Text(
                '$water ml',
                style: TextStyle(
                  color:
                      _selectWater == _select ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    _form.currentState.save();
    _isErr = false;

    if (volume == 0) {
      setState(() {
        _isErr = true;
      });
    } else {
      final user = Provider.of<UserProvider>(context, listen: false);
      final waterRec = Provider.of<WaterRecordProvider>(context, listen: false);
      await waterRec.addWaterRecord(
        WaterRecord(
            waterRecID: 0,
            user_uid: user.loginUser,
            timestamp: DateTime.now(),
            volume: volume),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Color.fromRGBO(232, 230, 198, 100),
      //   iconTheme: IconThemeData(color: Colors.teal),
      // ),
      body: Container(
        color: Color.fromRGBO(232, 230, 198, 100),
        child: Form(
          key: _form,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Drink Size',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.teal[500],
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 4.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _waterItemFirst(1, "150"),
                          _waterItem(2, "240", "assets/240.png",
                              "assets/240_white.png"),
                          _waterItem(3, "650", "assets/650.png",
                              "assets/650_white.png"),
                          _waterItem(4, "1500", "assets/1500.png",
                              "assets/1500_white.png"),
                          Container(
                            color: _selectWater == 5
                                ? Colors.teal[300]
                                : Colors.white,
                            height: MediaQuery.of(context).size.height * 0.08,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              
                              controller: _waterAmount,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              textAlign: TextAlign.center,
                              onTap: () {
                                setState(() {
                                  if (_selectWater == 5) {
                                    _selectWater = 0;
                                  } else {
                                    _selectWater = 5;
                                  }
                                });
                              },
                              onSaved: (value) {
                                if (value != "") {
                                  volume = int.parse(value);
                                }
                              },
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              cursorColor: Colors.teal,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "amount of water",
                                hintStyle: TextStyle(
                                  color: _selectWater == 5
                                ? Colors.white: Colors.grey[700],
                                  fontSize: 15,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 50.0),
                                suffix: Container(
                                  child: Text(
                                    "ml",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            child: ButtonTheme(
                              height: 30,
                              child: FlatButton(
                                onPressed: () {
                                  _saveForm().then((_) {
                                    _isErr
                                        ? showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                ),
                                                content: Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Icon(
                                                                  Icons.close)),
                                                        ],
                                                      ),
                                                      Image.asset(
                                                          "assets/Popup/water-3.png",
                                                          width: 90,
                                                          height: 90),
                                                      SizedBox(height: 20),
                                                      Text("Oops!!",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        'The water was spilled!',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Text(
                                                        'Please select water volume.',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(height: 20),
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
                                                                  .circular(20),
                                                        ),
                                                        child: RaisedButton(
                                                          child: Text(
                                                              'Try Again',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          color: Colors.red,
                                                          onPressed: () {
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
                                          )
                                        : showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                ),
                                                content: Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Icon(
                                                                  Icons.close)),
                                                        ],
                                                      ),
                                                      Image.asset(
                                                          "assets/Popup/drinking-water.png",
                                                          width: 90,
                                                          height: 90),
                                                      SizedBox(height: 20),
                                                      Text("Yayy!!",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        'The glass is ready!',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Continue to drink',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            ' $volume ml of water.',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 20),
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
                                                                  .circular(20),
                                                        ),
                                                        child: RaisedButton(
                                                          child: Text(
                                                              'Continue',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          color: Colors.green,
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
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
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Colors.amber,
                                child: Text(
                                  "Record",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
