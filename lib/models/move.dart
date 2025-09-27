import 'package:app/models/piece.dart';

class Move {
  Move({
    required this.fromRow,
    required this.fromColumn,
    required this.toRow,
    required this.toColumn,
    required this.piece,
    this.capturedPiece,
  });

  final int fromRow;
  final int fromColumn;
  final int toRow;
  final int toColumn;
  final Piece piece;
  final Piece? capturedPiece;
}
