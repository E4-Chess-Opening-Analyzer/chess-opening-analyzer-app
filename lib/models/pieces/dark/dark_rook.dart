import 'package:app/assets.dart';
import 'package:app/models/pieces/color/dark.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/models/pieces/type/rook.dart';

class DarkRook extends Piece with Dark, Rook {
  DarkRook({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_DARK_ROOK;
  }
}
