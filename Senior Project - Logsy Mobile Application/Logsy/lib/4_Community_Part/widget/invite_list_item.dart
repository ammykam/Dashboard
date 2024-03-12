import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:provider/provider.dart';

class InviteListItem extends StatefulWidget {
  final List<User> list;
  final int i;
  final int currentGid;

  InviteListItem(this.list, this.i, this.currentGid);
  @override
  _InviteListItemState createState() => _InviteListItemState();
}

class _InviteListItemState extends State<InviteListItem> {
  bool _isInit = true;
  String _status;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final group = Provider.of<GroupProvider>(context, listen: false);

      await group
          .getGroupStatus(widget.list[widget.i].uid, widget.currentGid)
          .then((value) {
        setState(() {
          _status = value;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _sendInvitation() async{
    final group = Provider.of<GroupProvider>(context, listen: false);
    List<Map<String, dynamic>> body = [{
      "user_uid":widget.list[widget.i].uid,
      "logsygroup_gid":widget.currentGid,
      "status":"invited",
    }];
    await group.createGroupInvite(body).then((value) {
      setState(() {
        _status = "invited";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.teal[300],
        backgroundImage:AssetImage('assets/avatar/${widget.list[widget.i].imgUrl}'),
      ),
      title: Text(
        "${widget.list[widget.i].firstName} ${widget.list[widget.i].lastName}",
        style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        widget.list[widget.i].des,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: Colors.teal),
      ),
      trailing: _status == "blank"
          ? ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.25,
              height: 35,
              child: FlatButton(
                color: Colors.teal[100],
                child: Text("INVITE",
                    style: TextStyle(color: Colors.teal, fontSize: 12)),
                onPressed: () {
                  _sendInvitation();
                },
              ),
            )
          : _status == "invited"
              ? ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width * 0.25,
                  height: 35,
                  child: FlatButton(
                    color: Colors.teal[100],
                    child: Text("INVITED",
                        style: TextStyle(color: Colors.teal, fontSize: 12)),
                    onPressed: () {},
                  ),
                )
              : _status == "member"
                  ? ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.25,
                      height: 35,
                      child: FlatButton(
                        color: Colors.teal[100],
                        child: Text("MEMBER",
                            style: TextStyle(color: Colors.teal, fontSize: 12)),
                        onPressed: () {},
                      ),
                    )
                  : ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.25,
                      height: 35,
                      child: FlatButton(
                        color: Colors.teal[100],
                        child: Text("",
                            style: TextStyle(color: Colors.teal, fontSize: 12)),
                        onPressed: () {},
                      ),
                    ),
    );
  }
}
