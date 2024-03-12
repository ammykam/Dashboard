import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logsy_app/3_Record_Part/provider/food.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PersonalMealScreen extends StatefulWidget {
  static const routeName = '/personal-meal';

  @override
  _PersonalMealScreenState createState() => _PersonalMealScreenState();
}

class _PersonalMealScreenState extends State<PersonalMealScreen> {
  final _nameFocus = FocusNode();
  final _typeFocus = FocusNode();
  final _calFocus = FocusNode();
  final _carbFocus = FocusNode();
  final _proFocus = FocusNode();
  final _fatFocus = FocusNode();
  final _fiberFocus = FocusNode();
  final _desFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  final picker = ImagePicker();
  File _image;

  bool isValid;
  bool _isError = false;
  Map<String, dynamic> food = {
    'fid': 0,
    'type': "",
    'name': "",
    'calories': 0,
    'carb': 0,
    'protein': 0,
    'fat': 0,
    'fiber': 0,
    'des': "",
    'imgUrl': "",
    'verified': 0
  };
  var _isLoading = false;

  @override
  void dispose() {
    _nameFocus.dispose();
    _typeFocus.dispose();
    _calFocus.dispose();
    _carbFocus.dispose();
    _proFocus.dispose();
    _fatFocus.dispose();
    _fiberFocus.dispose();

    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _rowData(String name, String dataName, FocusNode focus,
      FocusNode nextFocus, String unit, String hint) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
              color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Container(
          width: MediaQuery.of(context).size.height * 0.2,
          child: TextFormField(
            inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
            onSaved: (value) {
              food[dataName] = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter ${dataName}';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.teal,
            ),
            focusNode: focus,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(nextFocus);
            },
            cursorColor: Colors.teal,
            keyboardType: TextInputType.numberWithOptions(signed: true),
            decoration: InputDecoration(
              suffix: Text(
                unit,
                style: TextStyle(color: Colors.teal),
              ),
              labelText: hint,
              labelStyle: TextStyle(color: Colors.teal, fontSize: 12),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.teal,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.teal,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveForm() async {
    isValid = _form.currentState.validate();
    if (!isValid) {
      setState(() {
        _isError = true;
      });
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    final foodPro = Provider.of<FoodProvider>(context, listen: false);
    await foodPro
        .addFood(Food(
            fid: food['fid'],
            type: '',
            category: '',
            name: food['name'],
            calories: int.parse(food['calories']),
            carb: int.parse(food['carb']),
            protein: int.parse(food['protein']),
            fat: int.parse(food['protein']),
            fiber: int.parse(food['fiber']),
            des: food['des'],
            imgUrl:
                "https://www.porcelaingres.com/img/collezioni/JUST-GREY/big/just_grey_light_grey.jpg",
            verified: food['verified']))
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: getImage,
      //   tooltip: 'Pick Image',
      //   child: Icon(Icons.add_a_photo),
      // ),
      appBar: AppBar(
        title: Text(
          "FOOD",
          style: TextStyle(
              fontSize: 18,
              color: Colors.teal[500],
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.teal,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     showCupertinoModalPopup<void>(
                //       context: context,
                //       builder: (BuildContext context) => CupertinoActionSheet(
                //         title: const Text('Select Picture'),
                //         // message: const Text('Message'),
                //         actions: <CupertinoActionSheetAction>[
                //           CupertinoActionSheetAction(
                //             child: const Text('Camera'),
                //             onPressed: () {
                //               getImage();
                //             },
                //           ),
                //           CupertinoActionSheetAction(
                //             child: const Text('Library'),
                //             onPressed: () {
                //               getGallery();
                //             },
                //           ),
                //           CupertinoActionSheetAction(
                //             isDestructiveAction: true,
                //             child: const Text('Cancel'),
                //             onPressed: () {
                //               Navigator.pop(context);
                //             },
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                //   child: Container(
                //     width: double.infinity,
                //     child: _image == null
                //         ? Container(
                //             width: MediaQuery.of(context).size.height * 0.2,
                //             height: MediaQuery.of(context).size.height * 0.2,
                //             margin: EdgeInsets.only(bottom: 0),
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: Colors.blueGrey[100],
                //             ),
                //             child: Icon(Icons.add_a_photo, size: 30,color:Colors.grey[700]),
                //           )
                //         : CircleAvatar(
                //             backgroundImage: FileImage(_image, scale: 0.2),
                //             radius: MediaQuery.of(context).size.height * 0.1,
                //           ),
                //   ),
                // ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter food name';
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: Colors.teal,
                  ),
                  focusNode: _nameFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_desFocus);
                  },
                  onSaved: (value) {
                    food['name'] = value;
                  },
                  cursorColor: Colors.teal,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.food_bank, color: Colors.teal, size: 30),
                    labelText: "Food Name",
                    labelStyle: TextStyle(color: Colors.teal),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _rowData("Description", 'des', _desFocus, _calFocus, "",
                    "description"),
                // SizedBox(height: 30),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Type",
                //       style: TextStyle(
                //           color: Colors.teal,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 15),
                //     ),
                //     Spacer(),
                //     Container(
                //       width: MediaQuery.of(context).size.width * 0.45,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           GestureDetector(
                //             onTap: () {
                //               setState(() {
                //                 food['type'] = "meal";
                //               });
                //             },
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 border: Border.all(
                //                   color: food['type'] == "meal"
                //                       ? Colors.grey[300]
                //                       : _isError
                //                           ? Colors.red
                //                           : Colors.teal,
                //                 ),
                //                 borderRadius: BorderRadius.all(
                //                   Radius.circular(10),
                //                 ),
                //                 color: food['type'] == "meal"
                //                     ? Colors.teal
                //                     : Colors.transparent,
                //               ),
                //               padding: EdgeInsets.symmetric(
                //                   horizontal: 18, vertical: 5),
                //               child: Text(
                //                 "Meal",
                //                 style: TextStyle(
                //                   color: food['type'] == "meal"
                //                       ? Colors.white
                //                       : Colors.teal,
                //                   fontSize: 15,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               setState(() {
                //                 food['type'] = "snack";
                //               });
                //             },
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 border: Border.all(
                //                   color: food['type'] == "snack"
                //                       ? Colors.grey[300]
                //                       : _isError
                //                           ? Colors.red
                //                           : Colors.teal,
                //                 ),
                //                 borderRadius: BorderRadius.all(
                //                   Radius.circular(10),
                //                 ),
                //                 color: food['type'] == "snack"
                //                     ? Colors.teal
                //                     : Colors.transparent,
                //               ),
                //               padding: EdgeInsets.symmetric(
                //                   horizontal: 18, vertical: 5),
                //               child: Text(
                //                 "Snack",
                //                 style: TextStyle(
                //                   color: food['type'] == "snack"
                //                       ? Colors.white
                //                       : Colors.teal,
                //                   fontSize: 15,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 20),
                _rowData("Calories", "calories", _calFocus, _carbFocus, "kcal",
                    "Calories"),
                SizedBox(height: 10),
                _rowData("Carbohydrates", "carb", _carbFocus, _proFocus, "gram",
                    "Carbohydrates"),
                SizedBox(height: 10),
                _rowData("Protein", "protein", _proFocus, _fatFocus, "gram",
                    "Protein"),
                SizedBox(height: 10),
                _rowData("Fat", "fat", _fatFocus, _fiberFocus, "gram", "Fat"),
                SizedBox(height: 10),
                _rowData("Fiber", "fiber", _fiberFocus, _fiberFocus, "gram",
                    "Fiber"),
                SizedBox(height: 20),
                Center(
                  child: RaisedButton(
                    child: Text(
                      "ADD",
                      style: TextStyle(color: Colors.teal),
                    ),
                    onPressed: () {
                      _saveForm();

                      if (!_isLoading) {
                        Center(child: CircularProgressIndicator());
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              content: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Icon(Icons.close)),
                                      ],
                                    ),
                                    Image.asset("assets/Popup/tongue.png",
                                        width: 90, height: 90),
                                    SizedBox(height: 20),
                                    Text("Tasty!?",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                                    Text('The face is feeling yum!',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12)),
                                    Text(
                                      'Continue to save your personal menu',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('\"${food['name']}\"',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          ' to the food list.',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: RaisedButton(
                                        child: Text('Continue',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        color: Colors.green,
                                        onPressed: () {
                                          Navigator.of(context).pop();
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
                      }
                    },
                    color: Colors.teal[100],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
