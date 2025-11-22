import 'package:flutter/material.dart';

class GameScrollview extends StatelessWidget {
  const GameScrollview({required this.text, super.key});
  
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      child:SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          style: const TextStyle(fontSize: 24)
        )
      ),
    );
  }
}
