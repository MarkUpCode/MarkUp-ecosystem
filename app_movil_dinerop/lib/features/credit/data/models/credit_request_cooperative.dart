import 'credit_enums.dart';

class CreditRequestCooperative {
  const CreditRequestCooperative({
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

  factory CreditRequestCooperative.fromJson(Map<String, dynamic> json) {
    return CreditRequestCooperative(
      cooperativaId: (json['cooperativaId'] as num).toInt(),
      nombreCooperativa: (json['nombreCooperativa'] ?? '').toString(),
      estado: creditRequestStatusFromJson(json['estado']?.toString()),
      fechaActualizacion: DateTime.tryParse((json['fechaActualizacion'] ?? '').toString()),
      monto: (json['monto'] as num?)?.toDouble() ?? 0,
      plazoMeses: (json['plazoMeses'] as num?)?.toInt(),
      tipoCredito: json['tipoCredito']?.toString(),
      tasaAnual: (json['tasaAnual'] as num?)?.toDouble(),
      cuotaMensual: (json['cuotaMensual'] as num?)?.toDouble(),
      totalPagar: (json['totalPagar'] as num?)?.toDouble(),
      interesTotal: (json['interesTotal'] as num?)?.toDouble(),
    );
  }
}