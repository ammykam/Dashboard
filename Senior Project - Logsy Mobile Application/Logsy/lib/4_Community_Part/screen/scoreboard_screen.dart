import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/widget/rank_score.dart';
import 'package:provider/provider.dart';

class ScoreboardScreen extends StatefulWidget {
  static const routeName = "/scoreboard-screen";

  @override
  _ScoreboardScreenState createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  List<Scoreboard> _scoreBoard = [];
  List<Scoreboard> _belowScoreBoard = [];
  bool _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final gid = ModalRoute.of(context).settings.arguments as int;
      final group = Provider.of<GroupProvider>(context, listen: false);
      final user = Provider.of<UserProvider>(context, listen: false);

      await group.getScoreboard(gid,user.loginUser).then((value) {
        setState(() {
          _scoreBoard = value;
          if (_scoreBoard.length > 3) {
            _belowScoreBoard = value.sublist(3);
          }
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.teal[50],
          Colors.teal[200],
        ], begin: Alignment.topRight, end: Alignment.bottomLeft),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "SCOREBOARD",
            style: TextStyle(
                fontSize: 18, color: Colors.teal, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.teal),
        ),
        body: _scoreBoard.length == 0
            ? Column(
                children: [
                  SizedBox(height: 50),
                  RankScore(_scoreBoard),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      child: Container(),
                    ),
                  )
                ],
              )
            : Column(
                children: [
                  SizedBox(height: 50),
                  RankScore(_scoreBoard),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      child: _scoreBoard.length > 3 &&
                              _belowScoreBoard.length > 0
                          //? ListView.builder(itemBuilder: (ctx,i) => Text(i.toString()), itemCount: _belowScoreBoard.length,)
                          ? ListView.builder(
                              itemBuilder: (ctx, i) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: ListTile(
                                  leading: Text(
                                    (i + 4).toString(),
                                    style: TextStyle(
                                        color: Colors.teal[200],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/avatar/${_belowScoreBoard[i].imgUrl}'),
                                        backgroundColor: Colors.teal[100],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(_belowScoreBoard[i].name),
                                    ],
                                  ),
                                  trailing: Text(
                                      _belowScoreBoard[i].score.toString()),
                                ),
                              ),
                              itemCount: _belowScoreBoard.length,
                            )
                          : Container(),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
