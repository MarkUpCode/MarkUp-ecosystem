import 'credit_enums.dart';

class CreditRequestPayload {
  const CreditRequestPayload({
    required this.amount,
    required this.type,
    this.creditType,
    this.plazoMeses,
    this.province,
    this.city,
  });

  final double amount;
  final CreditRequestType type;
  final CreditType? creditType;
  final int? plazoMeses;
  final String? province;
  final String? city;

  Map<String, dynamic> toJson() => {
        'monto': amount,
        'type': type.name.toUpperCase(),
        'creditType': creditType == null || creditType == CreditType.unknown ? null : creditType!.name.toUpperCase(),
        'plazoMeses': plazoMeses,
        'province': province,
        'city': city,
      };
}