import 'package:app/assets.dart';
import 'package:app/models/pieces/color/light.dart';
import 'package:app/models/pieces/type/bishop.dart';
import 'package:app/models/pieces/piece.dart';

class LightBishop extends Piece with Light, Bishop {
  LightBishop({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_LIGHT_BISHOP;
  }
}
