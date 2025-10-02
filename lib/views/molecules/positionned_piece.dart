import 'package:app/views/atoms/chessboard.dart';
import 'package:app/views/atoms/piece.dart';
import 'package:app/models/pieces/piece.dart' as model_piece;
import 'package:flutter/material.dart';

class PositionnedPiece extends StatelessWidget {
  const PositionnedPiece({
    required this.piece,
    required this.row,
    required this.column,
    super.key,
    this.onPressed,
  });

  final model_piece.Piece piece;
  final double row;
  final double column;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (Chessboard.nbCasesRows - row - 1) * (MediaQuery.of(context).size.width - Chessboard.padding) / Chessboard.nbCasesRows,
      left: column * (MediaQuery.of(context).size.width - Chessboard.padding) / Chessboard.nbCasesColumns,
      child: GestureDetector(
        onTap: onPressed,
        child: Piece(piece: piece),
      ),
    );
  }
}
