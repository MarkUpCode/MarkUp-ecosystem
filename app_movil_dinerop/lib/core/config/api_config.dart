import 'dart:io' show Platform;

class ApiConfig {
  static const String _envBaseUrl = String.fromEnvironment('DINEROP_API_BASE_URL');
  static const String _envHostIp = String.fromEnvironment('DINEROP_HOST_IP');

  static String resolveBaseUrl() {
    final baseUrl = _envBaseUrl.trim();
    if (baseUrl.isNotEmpty) {
      return _normalize(baseUrl);
    }

    final hostIp = _envHostIp.trim();
    if (hostIp.isNotEmpty) {
      return _normalize(hostIp);
    }

    if (Platform.isAndroid) {
      return 'https://markup-ecosystem-production-ec11.up.railway.app';
    }

    return 'https://markup-ecosystem-production-ec11.up.railway.app';
  }

  static String _normalize(String value) => value.replaceAll(RegExp(r'/+$'), '');
}