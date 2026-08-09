class PublicRegistrationResponse {
  const PublicRegistrationResponse({required this.email, required this.message});

  final String email;
  final String message;

  factory PublicRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return PublicRegistrationResponse(
      email: (json['email'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
    );
  }
}