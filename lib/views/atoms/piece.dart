import 'package:app/views/atoms/chessboard.dart';
import 'package:app/models/pieces/piece.dart' as model_piece;
import 'package:flutter/material.dart';

class Piece extends StatelessWidget {
  const Piece({
    required this.piece,
    super.key,
  });
  
  final model_piece.Piece piece;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      piece.getAssetPath(),
      width: (MediaQuery.of(context).size.width - Chessboard.padding) / Chessboard.nbCasesRows,
    );
  }
}
