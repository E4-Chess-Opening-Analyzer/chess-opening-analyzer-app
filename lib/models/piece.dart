import 'package:app/enums/chess_piece_type.dart';

class Piece {
  ChessPieceType type;
  int row;
  int column;
  bool hasMoved;

  Piece({
    required this.type,
    required this.row,
    required this.column,
    this.hasMoved = false,
  });

  @override
  String toString() {
    return 'Piece(type: $type, row: $row, column: $column, hasMoved: $hasMoved)';
  }
}