import 'package:app/models/game_board.dart';
import 'package:app/models/pieces/piece.dart';

mixin Rook on Piece {
  @override
  List<(int, int)> getRawPossibleMoves(GameBoard gameBoard) {
    List<(int, int)> possibleMoves = <(int, int)>[];

    // Vertical and horizontal moves
    List<(int, int)> directions = <(int, int)>[(1, 0), (-1, 0), (0, 1), (0, -1)];
    for (var (int dRow, int dCol) in directions) {
      int newRow = row + dRow;
      int newCol = column + dCol;
      while (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = gameBoard.getPieceAt(newRow, newCol);
        if (targetPiece == null) {
          possibleMoves.add((newRow, newCol));
        } else {
          if (targetPiece.isDark() != isDark()) {
            possibleMoves.add((newRow, newCol));
          }
          break; // Stop if we hit another piece
        }
        newRow += dRow;
        newCol += dCol;
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
