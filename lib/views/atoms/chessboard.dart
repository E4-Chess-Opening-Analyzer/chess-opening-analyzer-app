import '../../assets.dart';
import 'package:flutter/material.dart';

class Chessboard extends StatelessWidget {

  static const padding = 20;
  static const nbCasesRows = 8;
  static const nbCasesColumns = 8;

  const Chessboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      IMG_CHESSBOARD,
      width: MediaQuery.of(context).size.width - padding
    );
  }
}
