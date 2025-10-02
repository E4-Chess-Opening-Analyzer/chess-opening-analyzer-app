import 'package:app/assets.dart';
import 'package:app/models/pieces/color/dark.dart';
import 'package:app/models/pieces/type/bishop.dart';
import 'package:app/models/pieces/piece.dart';

class DarkBishop extends Piece with Dark, Bishop {
  DarkBishop({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_DARK_BISHOP;
  }
}
