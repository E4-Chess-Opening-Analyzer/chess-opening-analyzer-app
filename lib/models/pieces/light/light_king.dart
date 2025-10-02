import 'package:app/assets.dart';
import 'package:app/models/pieces/color/light.dart';
import 'package:app/models/pieces/type/king.dart';
import 'package:app/models/pieces/piece.dart';

class LightKing extends Piece with Light, King {
  LightKing({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_LIGHT_KING;
  }
}
