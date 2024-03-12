import 'package:flutter/material.dart';

class FriendCircleItem extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function select;
  final List<dynamic> number;

  FriendCircleItem(this.user, this.select, this.number);

  @override
  _FriendCircleItemState createState() => _FriendCircleItemState();
}

class _FriendCircleItemState extends State<FriendCircleItem> {
  bool _isSelected;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.number.contains(widget.user['uid'])) {
        _isSelected = true;
        widget.select(widget.user);
      } else {
        _isSelected = false;
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.select(widget.user);
        });
      },
      child: Container(
        width:55,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(bottom: 0),
              child: _isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    )
                  : Container(),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isSelected ? Colors.teal[100] : Colors.teal[300],
                image: DecorationImage(
                    image: AssetImage('assets/avatar/${widget.user['imgUrl']}'),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.user['firstName'],
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
