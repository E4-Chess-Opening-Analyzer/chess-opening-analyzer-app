import 'package:app/models/pieces/piece.dart';
import 'package:app/models/move.dart';

class BoardState {
  final List<Piece> pieces = <Piece>[];
  final List<Move> moveHistory = <Move>[];

  Piece? getPieceAt(int row, int column) {
    for (Piece piece in pieces) {
      if (piece.row == row && piece.column == column) {
        return piece;
      }
    }
    return null;
  }

  void addPiece(Piece piece) {
    pieces.add(piece);
  }

  void removePiece(Piece piece) {
    pieces.remove(piece);
  }

  void addMove(Move move) {
    moveHistory.add(move);
  }

  bool isLightTurn() => moveHistory.length % 2 == 0;
  bool isDarkTurn() => moveHistory.length % 2 == 1;
}
