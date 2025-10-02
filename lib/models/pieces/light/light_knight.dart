import 'package:app/assets.dart';
import 'package:app/models/pieces/color/light.dart';
import 'package:app/models/pieces/type/knight.dart';
import 'package:app/models/pieces/piece.dart';

class LightKnight extends Piece with Light, Knight {
  LightKnight({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_LIGHT_KNIGHT;
  }
}
