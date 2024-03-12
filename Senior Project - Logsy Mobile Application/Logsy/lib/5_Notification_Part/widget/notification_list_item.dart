import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/badges.dart';

class NotificationListItem extends StatelessWidget {
  final Badge badge;

  NotificationListItem(this.badge);
  @override
  Widget build(BuildContext context) {
    String _getDiffTime(DateTime oldTime) {
      final different = DateTime.now().difference(badge.timestamp);
      // year, month, day
      if (different.inDays >= 1) {
        if (different.inDays == 1) {
          return "${different.inDays.toString()} d";
        }
        return "${different.inDays.toString()} d";
      }
      //hour
      else if (different.inHours >= 1) {
        if (different.inHours == 1) {
          return "${different.inHours.toString()} h";
        }
        return "${different.inHours.toString()} h";
      }
      //minutes
      else if (different.inMinutes >= 1) {
        if (different.inMinutes == 1) {
          return "${different.inMinutes.toString()} m";
        }
        return "${different.inMinutes.toString()} m";
      }
      //seconds
      else {
        return "${different.inSeconds.toString()} s";
      }
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              content: Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/Badge/${badge.imgUrl}",
                          height: 100, width: 100),
                      Text(
                        badge.name,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${badge.des}",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal[200],
          backgroundImage: AssetImage(
            ("assets/Badge/${badge.imgUrl}"),
          ),
        ),
        title: Text(
          "Congratulations! You have earned ${badge.name} Badge.",
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 13,
          ),
          maxLines: 2,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle:
            Text(_getDiffTime(badge.timestamp), style: TextStyle(fontSize: 10)),
        trailing: Icon(Icons.more_horiz, color: Colors.teal[200]),
      ),
    );
  }
}
