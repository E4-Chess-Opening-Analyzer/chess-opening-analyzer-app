import 'package:app/views/atoms/case.dart';
import 'package:app/views/atoms/chessboard.dart';
import 'package:app/models/game_board.dart' as gb;
import 'package:app/views/molecules/positionned_piece.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final gb.GameBoard gameBoard;
  const GameBoard({
    super.key,
    required this.gameBoard,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Chessboard(),
        for (int i = 0; i < Chessboard.nbCasesRows; i++)
          for (int j = 0; j < Chessboard.nbCasesColumns; j++)
            Case(
              row: i,
              column: j,
              onPressed: () {
                print("Case $i, $j");
              },
            ),
        for (var piece in gameBoard.pieces)
          PositionnedPiece(
            piece: piece.type,
            row: piece.row.toDouble(),
            column: piece.column.toDouble(),
            onPressed: () {
              print(piece);
            },
          ),
      ],
    );
  }
}