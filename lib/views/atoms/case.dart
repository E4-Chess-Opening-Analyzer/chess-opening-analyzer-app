import 'package:app/views/atoms/chessboard.dart';
import 'package:flutter/material.dart';

class Case extends StatelessWidget {
  const Case({
    required this.row,
    required this.column,
    required this.onPressed,
    super.key,
    this.isAPossibleMove = false,
  });

  final int row;
  final int column;
  final VoidCallback onPressed;
  final bool isAPossibleMove;

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
          color: Colors.transparent,
          child: isAPossibleMove
              ? Container(
                  margin: EdgeInsets.all(((MediaQuery.of(context).size.width - Chessboard.padding) / Chessboard.nbCasesRows) / 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 89, 152, 183).withAlpha(150),
                    shape: BoxShape.circle,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
