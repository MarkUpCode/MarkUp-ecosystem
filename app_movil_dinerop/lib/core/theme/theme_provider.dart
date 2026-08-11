import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di.dart';
import '../storage/secure_token_storage.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(this._storage) : super(ThemeMode.light) {
    _loadTheme();
  }

  final SecureTokenStorage _storage;

  Future<void> _loadTheme() async {
    try {
      final savedMode = await _storage.readThemeMode();
      if (savedMode != null) {
        switch (savedMode) {
          case 'dark':
            state = ThemeMode.dark;
            break;
          case 'light':
            state = ThemeMode.light;
            break;
          case 'system':
            state = ThemeMode.system;
            break;
          default:
            state = ThemeMode.light;
        }
      }
    } catch (_) {
      // Fallback a ThemeMode.light por defecto
      state = ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _storage.saveThemeMode(mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final storage = ref.watch(secureTokenStorageProvider);
  return ThemeNotifier(storage);
});
