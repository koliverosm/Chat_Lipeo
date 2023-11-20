import 'package:flutter/material.dart';

const Color _customColor = Color(0xFF164863);

const List<Color> _colorTheme = [
  _customColor,
  Colors.green,
  Colors.purple,
  Colors.yellow,
  Colors.blue
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0 && selectedColor <= _colorTheme.length -1,
            "La lista de colores va de 0 hasta ${_colorTheme.length}");

  ThemeData theme() {
    return ThemeData(
        useMaterial3: true, 
        colorSchemeSeed: _colorTheme[selectedColor]
        );
  }
}
