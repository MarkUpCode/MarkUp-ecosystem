import 'credit_enums.dart';

class CreditCooperativeStatus {
  const CreditCooperativeStatus({
    required this.cooperativaId,
    required this.nombreCooperativa,
    required this.estado,
    required this.fechaActualizacion,
    required this.monto,
    required this.plazoMeses,
    required this.tipoCredito,
    required this.tasaAnual,
    required this.cuotaMensual,
    required this.totalPagar,
    required this.interesTotal,
    this.direccion,
    this.mapsUrl,
    this.requisitos = const [],
  });

  final int cooperativaId;
  final String nombreCooperativa;
  final CreditRequestStatus estado;
  final DateTime? fechaActualizacion;
  final double monto;
  final int? plazoMeses;
  final String? tipoCredito;
  final double? tasaAnual;
  final double? cuotaMensual;
  final double? totalPagar;
  final double? interesTotal;
  final String? direccion;
  final String? mapsUrl;
  final List<CreditRequirement> requisitos;

  factory CreditCooperativeStatus.fromJson(Map<String, dynamic> json) {
    return CreditCooperativeStatus(
      cooperativaId: (json['cooperativaId'] as num).toInt(),
      nombreCooperativa: (json['nombreCooperativa'] ?? '').toString(),
      estado: creditRequestStatusFromJson(json['estado']?.toString()),
      fechaActualizacion: DateTime.tryParse(
        (json['fechaActualizacion'] ?? '').toString(),
      ),
      monto: (json['monto'] as num?)?.toDouble() ?? 0,
      plazoMeses: (json['plazoMeses'] as num?)?.toInt(),
      tipoCredito: json['tipoCredito']?.toString(),
      tasaAnual: (json['tasaAnual'] as num?)?.toDouble(),
      cuotaMensual: (json['cuotaMensual'] as num?)?.toDouble(),
      totalPagar: (json['totalPagar'] as num?)?.toDouble(),
      interesTotal: (json['interesTotal'] as num?)?.toDouble(),
      direccion: json['direccion']?.toString(),
      mapsUrl: json['mapsUrl']?.toString(),
      requisitos: (json['requisitos'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map(
            (item) =>
                CreditRequirement.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );
  }
}

class CreditRequirement {
  const CreditRequirement({
    required this.title,
    this.description,
    this.category,
    this.mandatory = true,
  });
  final String title;
  final String? description;
  final String? category;
  final bool mandatory;

  factory CreditRequirement.fromJson(Map<String, dynamic> json) =>
      CreditRequirement(
        title: (json['title'] ?? '').toString(),
        description: json['description']?.toString(),
        category: json['category']?.toString(),
        mandatory: json['mandatory'] != false,
      );
}
