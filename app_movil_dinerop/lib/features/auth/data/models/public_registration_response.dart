class PublicRegistrationResponse {
  const PublicRegistrationResponse({
    required this.requestId,
    required this.message,
  });

  final int? requestId;
  final String message;

  factory PublicRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return PublicRegistrationResponse(
      requestId: (json['requestId'] as num?)?.toInt(),
      message: (json['message'] ?? '').toString(),
    );
  }
}
