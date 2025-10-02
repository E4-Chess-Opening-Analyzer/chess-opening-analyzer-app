import 'package:app/models/pieces/color/color.dart';
import 'package:app/models/game_board.dart';

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

  List<(int, int)> getPossibleMoves(GameBoard gameBoard);
  List<(int, int)> getRawPossibleMoves(GameBoard gameBoard);
  String getAssetPath();
}
