import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';
import 'package:flutter/foundation.dart';

class AccessibilityController extends ChangeNotifier {
  double _fontScale = 1.0;
  ColorThemeType _colorTheme = ColorThemeType.standard;

  double get fontScale => _fontScale;
  ColorThemeType get colorTheme => _colorTheme;

  void setTheme(ColorThemeType theme) {
    if (_colorTheme == theme) return;

    _colorTheme = theme;
    notifyListeners();
  }

  void setFontScale(double scale) {
    if (_fontScale == scale) return;

    _fontScale = scale;
    notifyListeners();
  }
}
