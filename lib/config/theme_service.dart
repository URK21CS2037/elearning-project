import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeServiceProvider = Provider<ThemeService>((ref) => ThemeService());

class ThemeService {
  static const String _themeKey = 'theme_mode';
  late Box _prefsBox;

  Future<void> initialize() async {
    _prefsBox = await Hive.openBox('preferences');
  }

  ThemeMode getThemeMode() {
    final String? themeName = _prefsBox.get(_themeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == themeName,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefsBox.put(_themeKey, mode.name);
  }
} 