import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/app_user.dart';

class SessionSnapshot {
  const SessionSnapshot({
    required this.token,
    required this.user,
    required this.onboardingComplete,
  });

  final String token;
  final AppUser user;
  final bool onboardingComplete;
}

class SecureTokenStorage {
  SecureTokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'dinerop_access_token';
  static const String _userKey = 'dinerop_user';
  static const String _onboardingKey = 'dinerop_onboarding_complete';
  static const String _themeKey = 'dinerop_theme_mode';
  static const _operationTimeout = Duration(seconds: 8);

  Future<void> saveThemeMode(String mode) async {
    await _storage
        .write(key: _themeKey, value: mode)
        .timeout(_operationTimeout);
  }

  Future<String?> readThemeMode() async {
    try {
      return await _storage.read(key: _themeKey).timeout(_operationTimeout);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSession({
    required String token,
    required AppUser user,
    required bool onboardingComplete,
  }) async {
    await _storage
        .write(key: _tokenKey, value: token)
        .timeout(_operationTimeout);
    await _storage
        .write(key: _userKey, value: jsonEncode(user.toJson()))
        .timeout(_operationTimeout);
    await _storage
        .write(key: _onboardingKey, value: onboardingComplete.toString())
        .timeout(_operationTimeout);
  }

  Future<SessionSnapshot?> readSession() async {
    final token = await _storage
        .read(key: _tokenKey)
        .timeout(_operationTimeout);
    final userJson = await _storage
        .read(key: _userKey)
        .timeout(_operationTimeout);
    final onboardingComplete =
        (await _storage.read(key: _onboardingKey).timeout(_operationTimeout)) ==
        'true';

    if (token == null || userJson == null) {
      return null;
    }

    return SessionSnapshot(
      token: token,
      user: AppUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>),
      onboardingComplete: onboardingComplete,
    );
  }

  Future<String?> readToken() =>
      _storage.read(key: _tokenKey).timeout(_operationTimeout);

  Future<void> clear() => _storage.deleteAll().timeout(_operationTimeout);
}

