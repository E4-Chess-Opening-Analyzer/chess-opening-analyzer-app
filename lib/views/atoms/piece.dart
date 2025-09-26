import 'package:app/enums/chess_piece_type.dart';
import 'package:app/views/atoms/chessboard.dart';
import 'package:flutter/material.dart';

class Piece extends StatelessWidget {
  final ChessPieceType piece;
  const Piece({super.key, required this.piece});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      piece.imgPath,
      width: (MediaQuery.of(context).size.width - Chessboard.padding) / Chessboard.nbCasesRows,
    );
  }
}