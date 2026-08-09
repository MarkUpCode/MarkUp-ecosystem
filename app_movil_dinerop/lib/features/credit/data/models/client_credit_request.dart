import 'credit_enums.dart';

class ClientCreditRequestSummary {
  const ClientCreditRequestSummary({
    required this.solicitudId,
    required this.estado,
    required this.monto,
    required this.tipo,
    required this.fechaSolicitud,
    required this.cantidadSolicitudesEnviadas,
  });

  final int solicitudId;
  final CreditRequestStatus estado;
  final double monto;
  final String tipo;
  final DateTime? fechaSolicitud;
  final int cantidadSolicitudesEnviadas;

  factory ClientCreditRequestSummary.fromJson(Map<String, dynamic> json) {
    return ClientCreditRequestSummary(
      solicitudId: (json['solicitudId'] as num).toInt(),
      estado: creditRequestStatusFromJson(json['estado']?.toString()),
      monto: (json['monto'] as num?)?.toDouble() ?? 0,
      tipo: (json['tipo'] ?? '').toString(),
      fechaSolicitud: DateTime.tryParse((json['fechaSolicitud'] ?? '').toString()),
      cantidadSolicitudesEnviadas: (json['cantidadSolicitudesEnviadas'] as num?)?.toInt() ?? 0,
    );
  }
}