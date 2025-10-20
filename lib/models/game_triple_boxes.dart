import 'package:flutter/material.dart';

class GameTripleBoxes extends StatelessWidget {
  final String move;
  final int whiteProb;
  final int drawProb;
  final int blackProb;

  const GameTripleBoxes({super.key, required this.move, required this.whiteProb, required this.drawProb, required this.blackProb});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(children: [
      Container(
        width: width/10,
        child: Text(move, style: TextStyle(fontSize: 20)),
      ),
      Container(
        width: width/3,
        color: Colors.white,
        child: Text('$whiteProb%', style: TextStyle(fontSize: 16, color: Colors.black)),
      ),
      Container(
        width: width/3,
        color: Colors.grey,
        child: Text('$drawProb%', style: TextStyle(fontSize: 16, color: Colors.black)),
      ),
      Container(
        width: width/3,
        color: Colors.black,
        child: Text('$blackProb%', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    ]);
  }
}