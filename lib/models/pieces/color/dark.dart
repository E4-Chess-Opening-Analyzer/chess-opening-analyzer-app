import 'package:app/models/pieces/color/color.dart';

mixin Dark on Color {
  @override
  bool isLight() {
    return false;
  }
  @override
  bool isDark() {
    return true;
  }
}
