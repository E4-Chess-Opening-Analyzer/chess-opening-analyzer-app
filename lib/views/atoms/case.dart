import 'package:app/views/atoms/chessboard.dart';
import 'package:flutter/material.dart';

class Case extends StatelessWidget {
  final int row;
  final int column;
  final VoidCallback onPressed;

  const Case({
    super.key,
    required this.row,
    required this.column,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (Chessboard.nbCasesRows - row - 1) * (MediaQuery.of(context).size.width - Chessboard.padding) / Chessboard.nbCasesRows,
      left: column * (MediaQuery.of(context).size.width - Chessboard.padding) / Chessboard.nbCasesColumns,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: (MediaQuery.of(context).size.width - Chessboard.padding) / Chessboard.nbCasesRows,
          height: (MediaQuery.of(context).size.width - Chessboard.padding) / Chessboard.nbCasesColumns,
          color: Colors.transparent
        ),
      ),
    );
  }
}