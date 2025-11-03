import 'package:flutter/material.dart';

class GameScrollview extends StatelessWidget {
  final String text;

  const GameScrollview({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
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