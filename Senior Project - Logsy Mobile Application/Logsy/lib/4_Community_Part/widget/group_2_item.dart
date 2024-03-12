import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Group2Item extends StatefulWidget {
  final Function backPage;
  final Function done;
  final Function groupData;

  Group2Item({this.backPage, this.done, this.groupData});

  @override
  _Group2ItemState createState() => _Group2ItemState();
}

class _Group2ItemState extends State<Group2Item> {
  List<dynamic> friends;
  Completer<GoogleMapController> _controller = Completer();
  final _form = GlobalKey<FormState>();
  Map<String, dynamic> _info = {
    "des": "",
    "type": "",
    "latitude": "",
    "longitude": ""
  };
  int _selectType;
  int _selectCat;
  Position _currentPosition;

  @override
  void didChangeDependencies() async {
    await Geolocator().getCurrentPosition().then((Position position) {
      setState(() {
        _currentPosition = position;
        
      });
    });
    
    if (widget.groupData()['type'] == "private") {
      _selectType = 2;
      _info = {
        "des": widget.groupData()['des'],
        "type": "private",
        "latitude": _currentPosition.latitude,
        "longitude": _currentPosition.longitude,
      };
    } else if (widget.groupData()['type'] == "public") {
      _selectType = 1;
      _info = {
        "des": widget.groupData()['des'],
        "type": "public",
        "latitude": _currentPosition.latitude,
        "longitude": _currentPosition.longitude,
      };
    } else {
      _selectType = 0;
      _info = {
        "des": "",
        "type": "",
        "latitude": _currentPosition.latitude,
        "longitude": _currentPosition.longitude,
      };
    }

    super.didChangeDependencies();
  }

  void _saveForm() async {
    _form.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  "DESCRIPTION",
                  style: TextStyle(color: Colors.teal, fontSize: 12),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: widget.groupData()['des'],
                onSaved: (value) {
                  _info = {
                    "des": value,
                    "type": _info['type'],
                    "latitude": _currentPosition.latitude,
                    "longitude": _currentPosition.longitude,
                  };
                },
                style: TextStyle(
                  color: Colors.teal,
                ),
                maxLines: 3,
                cursorColor: Colors.teal,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.teal),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal[300],
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Text(
                  "PUBLIC/ PRIVATE",
                  style: TextStyle(color: Colors.teal, fontSize: 12),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectType = 1;
                        _info = {
                          "des": _info['des'],
                          "type": "public",
                          "latitude": _currentPosition.latitude,
                          "longitude": _currentPosition.longitude,
                        };
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        color: _selectType == 1 ? Colors.teal : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "Public",
                          style: TextStyle(
                              color: _selectType == 1
                                  ? Colors.white
                                  : Colors.teal),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectType = 2;
                        _info = {
                          "des": _info['des'],
                          "type": "private",
                          "latitude": _currentPosition.latitude,
                          "longitude": _currentPosition.longitude,
                        };
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        color: _selectType == 2 ? Colors.teal : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "Private",
                          style: TextStyle(
                              color: _selectType == 2
                                  ? Colors.white
                                  : Colors.teal),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Text(
                  "LOCATION",
                  style: TextStyle(color: Colors.teal, fontSize: 12),
                ),
              ),
              SizedBox(height: 10),
              _currentPosition == null
                  ? Container()
                  : Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              _currentPosition.latitude,
                              _currentPosition
                                  .longitude), //กำหนดพิกัดเริ่มต้นบนแผนที่
                          zoom: 15, //กำหนดระยะการซูม สามารถกำหนดค่าได้ 0-20
                        ),
                        markers: {
                          Marker(
                              markerId: MarkerId("1"),
                              position: LatLng(_currentPosition.latitude,
                                  _currentPosition.longitude),
                              infoWindow: InfoWindow(
                                title: "Your Group Area",
                              )),
                        },
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        _saveForm();
                        widget.backPage(_info);
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        _saveForm();
                        print(_info);
                        widget.done(_info);
                      },
                      child: Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.teal,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
