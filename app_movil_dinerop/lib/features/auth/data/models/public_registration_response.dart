class PublicRegistrationResponse {
  const PublicRegistrationResponse({
    required this.requestId,
    required this.message,
    required this.status,
  });

  final int? requestId;
  final String message;
  final String? status;

  factory PublicRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return PublicRegistrationResponse(
      requestId: (json['requestId'] as num?)?.toInt(),
      message: (json['message'] ?? '').toString(),
      status: json['status']?.toString(),
    );
  }
}
