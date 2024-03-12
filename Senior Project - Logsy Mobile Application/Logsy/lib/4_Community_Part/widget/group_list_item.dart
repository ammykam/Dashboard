import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/screen/group_screen.dart';

class GroupListItem extends StatelessWidget {
  final String groupName;
  final String status;
  final int gid;
  final String imgUrl;

  GroupListItem(this.groupName, this.status, this.gid, this.imgUrl);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 25,
            height: 25,
            margin: EdgeInsets.only(bottom: 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey[100],
              image: DecorationImage(
                  image: imgUrl == ""
                      ? NetworkImage(
                          "https://media.tarkett-image.com/large/TH_24567080_24594080_24596080_24601080_24563080_24565080_24588080_001.jpg")
                      : NetworkImage(imgUrl),
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              groupName,
              style: TextStyle(color: Colors.white),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
