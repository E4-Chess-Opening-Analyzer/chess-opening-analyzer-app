import 'package:flutter/material.dart';

class GameScrollview extends StatelessWidget {
  final double width;
  final String text;

  const GameScrollview({super.key, required this.width, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.9,
      height: 50,
      child:SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          style: TextStyle(fontSize: 24)
        )
      ),
    );
  }
}