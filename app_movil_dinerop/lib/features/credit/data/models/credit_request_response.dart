class CreditRequestResponse {
  const CreditRequestResponse({required this.requestId, required this.estado, required this.cooperativasNotificadas, required this.message});

  final int requestId;
  final String? estado;
  final int? cooperativasNotificadas;
  final String message;

  factory CreditRequestResponse.fromJson(Map<String, dynamic> json) {
    return CreditRequestResponse(
      requestId: (json['requestId'] as num).toInt(),
      estado: json['estado']?.toString(),
      cooperativasNotificadas: (json['cooperativasNotificadas'] as num?)?.toInt(),
      message: (json['message'] ?? '').toString(),
    );
  }
}