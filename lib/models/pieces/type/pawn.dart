import 'package:app/models/game_board.dart';
import 'package:app/models/move.dart';
import 'package:app/models/pieces/piece.dart';

mixin Pawn on Piece {
  @override
  List<(int, int)> getRawPossibleMoves(GameBoard gameBoard) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    int direction = isDark() ? -1 : 1; // Dark pawns move down, light pawns move up

    // Move forward one square
    if (gameBoard.getPieceAt(row + direction, column) == null) {
      possibleMoves.add((row + direction, column));

      // Move forward two squares from starting position
      if (!hasMoved && gameBoard.getPieceAt(row + 2 * direction, column) == null) {
        possibleMoves.add((row + 2 * direction, column));
      }
    }

    // Capture diagonally
    if (column - 1 >= 0) {
      Piece? targetPiece = gameBoard.getPieceAt(row + direction, column - 1);
      if (targetPiece != null && targetPiece.isDark() != isDark()) {
        possibleMoves.add((row + direction, column - 1));
      }
    }
    if (column + 1 < 8) {
      Piece? targetPiece = gameBoard.getPieceAt(row + direction, column + 1);
      if (targetPiece != null && targetPiece.isDark() != isDark()) {
        possibleMoves.add((row + direction, column + 1));
      }
    }

    // En passant
    if (gameBoard.moveHistory.isNotEmpty) {
      Move lastMove = gameBoard.moveHistory.last;
      int fromRow = isDark() ? 1 : 6;
      int toRow = isDark() ? 3 : 4;
      int rowForEnPassant = isDark() ? 3 : 4; 
      if (lastMove.piece is Pawn &&
          lastMove.piece.isDark() != isDark() &&
          lastMove.fromRow == fromRow &&
          lastMove.toRow == toRow &&
          (lastMove.toColumn == column - 1 || lastMove.toColumn == column + 1) &&
          row == rowForEnPassant) {
        possibleMoves.add((row + direction, lastMove.toColumn));
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
