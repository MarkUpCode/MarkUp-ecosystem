class OnboardingSubmissionResponse {
  const OnboardingSubmissionResponse({required this.id, required this.estado, required this.destinoCredito, required this.fechaCreacion});

  final int id;
  final String estado;
  final String destinoCredito;
  final DateTime? fechaCreacion;

  factory OnboardingSubmissionResponse.fromJson(Map<String, dynamic> json) {
    return OnboardingSubmissionResponse(
      id: (json['id'] as num).toInt(),
      estado: (json['estado'] ?? '').toString(),
      destinoCredito: (json['destinoCredito'] ?? '').toString(),
      fechaCreacion: DateTime.tryParse((json['fechaCreacion'] ?? '').toString()),
    );
  }
}