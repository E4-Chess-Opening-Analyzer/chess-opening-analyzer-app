import 'package:app/assets.dart';
import 'package:app/models/pieces/color/dark.dart';
import 'package:app/models/pieces/type/knight.dart';
import 'package:app/models/pieces/piece.dart';

class DarkKnight extends Piece with Dark, Knight {
  DarkKnight({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_DARK_KNIGHT;
  }
}
