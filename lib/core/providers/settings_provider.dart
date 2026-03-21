import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for font size settings
final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  return FontSizeNotifier();
});

const String _fontSizeKey = 'adhkar_font_size';
const double _defaultFontSize = 18.0;
const double _minFontSize = 14.0;
const double _maxFontSize = 28.0;
const double _fontSizeStep = 2.0;

class FontSizeNotifier extends StateNotifier<double> {
  FontSizeNotifier() : super(_defaultFontSize) {
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSize = prefs.getDouble(_fontSizeKey);
    if (savedSize != null && savedSize >= _minFontSize && savedSize <= _maxFontSize) {
      state = savedSize;
    }
  }

  Future<void> setFontSize(double size) async {
    final clampedSize = size.clamp(_minFontSize, _maxFontSize);
    state = clampedSize;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, clampedSize);
  }

  Future<void> increaseFontSize() async {
    final newSize = (state + _fontSizeStep).clamp(_minFontSize, _maxFontSize);
    await setFontSize(newSize);
  }

  Future<void> decreaseFontSize() async {
    final newSize = (state - _fontSizeStep).clamp(_minFontSize, _maxFontSize);
    await setFontSize(newSize);
  }

  bool get canIncrease => state < _maxFontSize;
  bool get canDecrease => state > _minFontSize;
  
  double get minSize => _minFontSize;
  double get maxSize => _maxFontSize;
}
