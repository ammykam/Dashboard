import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsy_app/3_Record_Part/provider/exercise.dart';
import 'package:provider/provider.dart';

class ExerItem extends StatefulWidget {
  final IconData icons;
  final int eid;
  final String value;
  final String duration;
  final DateTime date;

  ExerItem(this.icons, this.eid, this.value, this.duration, this.date);

  @override
  _ExerItemState createState() => _ExerItemState();
}

class _ExerItemState extends State<ExerItem> {
  bool _isInit = true;
  String name = "";
  String imgUrl = "";
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final exercise = Provider.of<ExerciseProvider>(context, listen: false);
      await exercise.getExerciseOne(widget.eid).then((value) {
        setState(() {
          name = value.name;
          imgUrl = value.imgUrl;

        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Material(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          //height: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                imgUrl == "" ? Container() : Image.network(imgUrl, width: 45,),
                //Icon(widget.icons, size: 45, color: Colors.teal[300]),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        name == "" ? "" : name,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ),
                    Text(
                      "${widget.value} KCAL",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.duration,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                       DateFormat('dd MMM y').format(widget.date),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
