import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'config/api_config.dart';
import 'network/api_client.dart';
import 'storage/secure_token_storage.dart';

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage(ref.watch(flutterSecureStorageProvider));
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureTokenStorageProvider);
  final baseUrl = ApiConfig.resolveBaseUrl();
  // Deliberately excludes credentials and request headers.
  debugPrint('[API] BASE URL = $baseUrl');
  return ApiClient(
    baseUrl: baseUrl,
    tokenProvider: storage.readToken,
    onUnauthorized: () async {
      await storage.clear();
    },
    enableLogging: false,
  );
});
