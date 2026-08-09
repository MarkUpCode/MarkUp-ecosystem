class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AppException(statusCode: $statusCode, message: $message)';
}

class AppErrorMessages {
  static const String network = 'No pudimos conectar con el servidor.';
  static const String unauthorized = 'Tu sesión expiró. Inicia sesión nuevamente.';
  static const String generic = 'No pudimos completar la solicitud.';
}