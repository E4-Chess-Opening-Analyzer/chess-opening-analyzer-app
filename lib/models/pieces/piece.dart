import 'package:app/models/board/board_state.dart';
import 'package:app/models/pieces/color/color.dart';

abstract class Piece extends Color {
  Piece({
    required this.row,
    required this.column,
    this.hasMoved = false,
  });

  int row;
  int column;
  bool hasMoved;

  @override
  String toString() {
    return 'Piece(row: $row, column: $column, hasMoved: $hasMoved)';
  }

  List<(int, int)> getRawPossibleMoves(BoardState boardState);
  String getAssetPath();
}
