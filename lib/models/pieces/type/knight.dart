import 'package:app/models/game_board.dart';
import 'package:app/models/pieces/piece.dart';

mixin Knight on Piece {
  @override
  List<(int, int)> getRawPossibleMoves(GameBoard gameBoard) {
    List<(int, int)> possibleMoves = <(int, int)>[];

    // L-shaped moves
    List<(int, int)> moves = <(int, int)>[
      (2, 1),
      (2, -1),
      (-2, 1),
      (-2, -1),
      (1, 2),
      (1, -2),
      (-1, 2),
      (-1, -2)
    ];

    for (var (int dRow, int dCol) in moves) {
      int newRow = row + dRow;
      int newCol = column + dCol;
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = gameBoard.getPieceAt(newRow, newCol);
        if (targetPiece == null || targetPiece.isDark() != isDark()) {
          possibleMoves.add((newRow, newCol));
        }
      }
    }

    return possibleMoves;
  }

  @override
  List<(int, int)> getPossibleMoves(GameBoard gameBoard) {
    List<(int, int)> rawMoves = getRawPossibleMoves(gameBoard);
    return gameBoard.filterMovesForCheck(this, rawMoves);
  }
}
