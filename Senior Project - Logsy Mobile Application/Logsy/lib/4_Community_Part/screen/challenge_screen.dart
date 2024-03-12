import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/challenge.dart';
import 'package:logsy_app/4_Community_Part/provider/user.dart';
import 'package:logsy_app/4_Community_Part/screen/challenge_detail_screen.dart';
import 'package:logsy_app/4_Community_Part/widget/challnge_post_item.dart';
import 'package:provider/provider.dart';

import 'create_challenge_screen.dart';

class ChallengeScreen extends StatefulWidget {
  static const routeName = "/challenge-screen";

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  List<Challenge> _challengeCurrent;
  List<Challenge> _challengeUpcoming;
  List<Challenge> _challengeExpired;
  String status;
  int gid;

  @override
  void didChangeDependencies() async {
    gid = ModalRoute.of(context).settings.arguments as int;
    final challenge = Provider.of<ChallengeProvider>(context, listen: false);

    await challenge.getChallengeGroupCurrent(gid).then((value) {
      _challengeCurrent = value;
    });

    await challenge.getChallengeGroupUpcoming(gid).then((value) {
      _challengeUpcoming = value;
    });

    await challenge.getChallengeGroupExpired(gid).then((value) {
      setState(() {
        _challengeExpired = value;
      });
    });

    super.didChangeDependencies();
  }

  Future<void> _reItem() async {
    print('re');
    final gid = ModalRoute.of(context).settings.arguments as int;
    final challenge = Provider.of<ChallengeProvider>(context, listen: false);

    await challenge.getChallengeGroupCurrent(gid).then((value) {
      setState(() {
        _challengeCurrent = value;
        print(value);
        print(value.length);
      });
    });

    await challenge.getChallengeGroupUpcoming(gid).then((value) {
      setState(() {
        _challengeUpcoming = value;
      });
    });

    await challenge.getChallengeGroupExpired(gid).then((value) {
      setState(() {
        _challengeExpired = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final challenge = Provider.of<ChallengeProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false);
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Colors.amber[300],
                Colors.red,
                Colors.purple[300],
              ],
            ).createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Text(
              "CHALLENGE",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.teal),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black38,
            indicatorColor: Colors.teal,
            indicatorWeight: 3.0,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Upcoming",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "Current",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "Expired",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(CreateChallengeScreen.routeName, arguments: gid)
                .then((value)  {
               _reItem();
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.red[400],
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: _challengeUpcoming == null
                  ? LinearProgressIndicator(
                      minHeight: 0.0001,
                    )
                  : _challengeUpcoming.length == 0
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(
                            child: Text('No upcoming challenge'),
                          ),
                        )
                      : Column(
                          children: _challengeUpcoming
                              .map((e) => ChallengePostItem(
                                  e,
                                  "upcoming",
                                  challenge.getChallengeUserStatus(
                                      user.loginUser, e.cid),
                                  _reItem))
                              .toList(),
                        ),
            ),
            SingleChildScrollView(
              child: _challengeCurrent == null
                  ? LinearProgressIndicator(
                      minHeight: 0.0001,
                    )
                  : _challengeCurrent.length == 0
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(
                            child: Text('No current challenge'),
                          ),
                        )
                      : Column(
                          children: _challengeCurrent
                              .map(
                                (e) => ChallengePostItem(
                                    e,
                                    "current",
                                    challenge.getChallengeUserStatus(
                                        user.loginUser, e.cid),
                                    _reItem),
                              )
                              .toList(),
                        ),
            ),
            SingleChildScrollView(
              child: _challengeExpired == null
                  ? LinearProgressIndicator(
                      minHeight: 0.0001,
                    )
                  : _challengeExpired.length == 0
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(
                            child: Text('No expired challenge'),
                          ),
                        )
                      : Column(
                          children: _challengeExpired
                              .map((e) => ChallengePostItem(
                                  e,
                                  "expired",
                                  challenge.getChallengeUserStatus(
                                      user.loginUser, e.cid),
                                  _reItem))
                              .toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
