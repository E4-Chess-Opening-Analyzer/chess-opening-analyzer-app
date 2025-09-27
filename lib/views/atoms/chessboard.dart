import 'package:app/assets.dart';
import 'package:flutter/material.dart';

class Chessboard extends StatelessWidget {
  const Chessboard({super.key});

  static const int padding = 20;
  static const int nbCasesRows = 8;
  static const int nbCasesColumns = 8;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      IMG_CHESSBOARD,
      width: MediaQuery.of(context).size.width - padding
    );
  }
}
