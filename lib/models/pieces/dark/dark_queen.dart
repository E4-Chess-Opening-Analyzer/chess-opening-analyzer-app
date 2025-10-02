import 'package:app/assets.dart';
import 'package:app/models/pieces/color/dark.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/models/pieces/type/queen.dart';

class DarkQueen extends Piece with Dark, Queen {
  DarkQueen({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_DARK_QUEEN;
  }
}
