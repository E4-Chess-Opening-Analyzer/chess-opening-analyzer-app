import 'package:app/assets.dart';
import 'package:app/models/pieces/color/dark.dart';
import 'package:app/models/pieces/type/king.dart';
import 'package:app/models/pieces/piece.dart';

class DarkKing extends Piece with Dark, King {
  DarkKing({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_DARK_KING;
  }
}
