import 'package:flutter/material.dart';
import 'package:logsy_app/3_Record_Part/screen/exercise_screen.dart';
import 'package:logsy_app/3_Record_Part/screen/record_screen.dart';
import 'package:logsy_app/3_Record_Part/screen/sleep_screen.dart';
import 'package:logsy_app/3_Record_Part/screen/water_screen.dart';

class RecordModal extends StatelessWidget {
  Widget _item(String title, String img) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage("assets/$img.png"),
            radius: 20,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown[200],
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Colors.red[600],
        //     Colors.pink[500],
        //     Colors.deepPurple[400],
        //     Colors.indigo[400]
        //   ],
        // ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "Record",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RecordScreen.routeName, arguments: "Snack");
                },
                child: _item("Snack", "snack"),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(WaterScreen.routeName);
                },
                child: _item("Water", "water"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(RecordScreen.routeName,
                      arguments: "Breakfast");
                },
                child: _item("Breakfast", "breakfast"),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RecordScreen.routeName, arguments: "Lunch");
                  },
                  child: _item("Lunch", "lunch")),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(RecordScreen.routeName, arguments: "Dinner");
                  },
                  child: _item("Dinner", "dinner")),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(ExerciseScreen.routeName);
                  },
                  child: _item("Exercise", "exercise"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(SleepScreen.routeName);
                  },
                  child: _item("Sleep", "sleep")
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:logsy_app/3_Record_Part/screen/exercise_screen.dart';
// import 'package:logsy_app/3_Record_Part/screen/record_screen.dart';
// import 'package:logsy_app/3_Record_Part/screen/sleep_screen.dart';
// import 'package:logsy_app/3_Record_Part/screen/water_screen.dart';

// class RecordModal extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.lightGreen[600],
//             Colors.lightGreen[400],
//             Colors.lightGreen[200]
//           ],
//         ),
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(30),
//         ),
//       ),
//       height: MediaQuery.of(context).size.height * 0.5,
//       child: Stack(
//         children: [
//           Positioned(
//             top: 0.0,
//             left: 0.0,
//             right: 0.0,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context)
//                     .pushNamed(RecordScreen.routeName, arguments: "Breakfast");
//               },
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.01,
//                     bottom: MediaQuery.of(context).size.height * 0.05),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.deepPurple[600],
//                       Colors.deepPurple[400],
//                       Colors.deepPurple[200]
//                     ],
//                   ),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(30),
//                   ),
//                 ),
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Icon(Icons.wb_sunny, color: Colors.white, size: 40),
//                     SizedBox(width: 20),
//                     Text(
//                       "Breakfast",
//                       style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.height * 0.03,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: MediaQuery.of(context).size.height * 0.07,
//             left: 0.0,
//             right: 0.0,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context)
//                     .pushNamed(RecordScreen.routeName, arguments: "Lunch");
//               },
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.01,
//                     bottom: MediaQuery.of(context).size.height * 0.05),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.lightBlue[600],
//                       Colors.lightBlue[400],
//                       Colors.lightBlue[200]
//                     ],
//                   ),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(30),
//                   ),
//                 ),
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     //Icon(Icons.set_meal, color: Colors.white, size: 40),
//                     SizedBox(width: 20),
//                     Text(
//                       "Lunch",
//                       style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.height * 0.03,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: MediaQuery.of(context).size.height * 0.14,
//             left: 0.0,
//             right: 0.0,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context)
//                     .pushNamed(RecordScreen.routeName, arguments: "Dinner");
//               },
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.01,
//                     bottom: MediaQuery.of(context).size.height * 0.05),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.pink[600],
//                       Colors.pink[400],
//                       Colors.pink[200]
//                     ],
//                   ),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(30),
//                   ),
//                 ),
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     //Icon(Icons.night_shelter, color: Colors.white, size: 40),
//                     SizedBox(width: 20),
//                     Text(
//                       "Dinner",
//                       style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.height * 0.03,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: MediaQuery.of(context).size.height * 0.21,
//             left: 0.0,
//             right: 0.0,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context)
//                     .pushNamed(RecordScreen.routeName, arguments: "Snack");
//               },
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.01,
//                     bottom: MediaQuery.of(context).size.height * 0.05),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.orange[600],
//                       Colors.orange[400],
//                       Colors.orange[200]
//                     ],
//                   ),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(30),
//                   ),
//                 ),
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     //Icon(Icons.add_box, color: Colors.white, size: 40),
//                     SizedBox(width: 20),
//                     Text(
//                       "Snack",
//                       style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.height * 0.03,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: MediaQuery.of(context).size.height * 0.28,
//             left: 0.0,
//             right: 0.0,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pushNamed(WaterScreen.routeName);
//               },
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.01,
//                     bottom: MediaQuery.of(context).size.height * 0.05),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.lightGreen[600],
//                       Colors.lightGreen[400],
//                       Colors.lightGreen[200]
//                     ],
//                   ),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(30),
//                   ),
//                 ),
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Icon(Icons.emoji_food_beverage,
//                     //     color: Colors.white, size: 40),
//                     // SizedBox(width: 20),
//                     Text(
//                       "Water",
//                       style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.height * 0.03,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: MediaQuery.of(context).size.height * 0.35,
//             left: 0.0,
//             right: 0.0,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pushNamed(ExerciseScreen.routeName);
//               },
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.01,
//                     bottom: MediaQuery.of(context).size.height * 0.05),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.blueGrey[600],
//                       Colors.blueGrey[400],
//                       Colors.blueGrey[200]
//                     ],
//                   ),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(30),
//                   ),
//                 ),
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Exercise",
//                       style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.height * 0.03,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: MediaQuery.of(context).size.height * 0.42,
//             left: 0.0,
//             right: 0.0,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pushNamed(SleepScreen.routeName);
//               },
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.01,
//                     bottom: MediaQuery.of(context).size.height * 0.05),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.yellow[600],
//                       Colors.yellow[400],
//                       Colors.yellow[200]
//                     ],
//                   ),
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(30),
//                   ),
//                 ),
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Sleep",
//                       style: TextStyle(
//                           fontSize: MediaQuery.of(context).size.height * 0.03,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
