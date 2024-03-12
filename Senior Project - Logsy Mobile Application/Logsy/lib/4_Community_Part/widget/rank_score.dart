import 'package:flutter/material.dart';
import 'package:logsy_app/4_Community_Part/provider/group.dart';

class RankScore extends StatelessWidget {
  final List<Scoreboard> scoreBoard;

  RankScore(this.scoreBoard);

  Widget _rank(String name, String imgUrl, String score, double height,
      String rank, double stackHeight, double squareHeight, Color color) {
    return Column(
      children: [
        Container(
          height: height,
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(bottom: 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 3),
                  image: DecorationImage(
                      image: AssetImage(imgUrl), fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: stackHeight,
                left: 0.0,
                right: 0.0,
                child: Container(
                  width: 90,
                  height: 25,
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          score,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        Container(
          height: squareHeight,
          width: 90,
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rank,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return scoreBoard.length == 0
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _rank(
                  "-",
                  "assets/greyAvatar.png",
                  "-",
                  MediaQuery.of(context).size.height * 0.13,
                  "2",
                  80,
                  100,
                  Colors.amber),
              _rank(
                  "-",
                  "assets/greyAvatar.png",
                  "-",
                  MediaQuery.of(context).size.height * 0.13,
                  "1",
                  80,
                  160,
                  Colors.teal[400]),
              _rank(
                  "-",
                  "assets/greyAvatar.png",
                  "-",
                  MediaQuery.of(context).size.height * 0.13,
                  "3",
                  80,
                  80,
                  Colors.red[400])
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _rank(
                  scoreBoard.length > 1 ? scoreBoard[1].name : "-",
                  scoreBoard.length > 1
                      ? 'assets/avatar/${scoreBoard[1].imgUrl}'
                      : "assets/greyAvatar.png",
                  scoreBoard.length > 1 ? scoreBoard[1].score.toString() : "-",
                  MediaQuery.of(context).size.height * 0.13,
                  "2",
                  80,
                  100,
                  Colors.amber),
              _rank(
                  scoreBoard.length > 0 ? scoreBoard[0].name : "-",
                  scoreBoard.length > 0
                      ? 'assets/avatar/${scoreBoard[0].imgUrl}'
                      : "assets/greyAvatar.png",
                  scoreBoard.length > 0 ? scoreBoard[0].score.toString() : "-",
                  MediaQuery.of(context).size.height * 0.13,
                  "1",
                  80,
                  160,
                  Colors.teal[400]),
              _rank(
                  scoreBoard.length > 2 ? scoreBoard[2].name : "-",
                  scoreBoard.length > 2
                      ? 'assets/avatar/${scoreBoard[2].imgUrl}'
                      : "assets/greyAvatar.png",
                  scoreBoard.length > 2 ? scoreBoard[2].score.toString() : "-",
                  MediaQuery.of(context).size.height * 0.13,
                  "3",
                  80,
                  80,
                  Colors.red[400])
            ],
          );
  }
}
