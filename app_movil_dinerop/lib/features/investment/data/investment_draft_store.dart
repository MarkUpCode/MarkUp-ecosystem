import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PendingInvestmentDraft {
  const PendingInvestmentDraft({
    required this.amount,
    required this.termMonths,
    required this.interestPaymentOption,
    required this.productId,
    required this.cooperativeId,
    required this.conditionId,
    required this.annualRate,
    required this.savedAt,
  });
  final double amount;
  final int termMonths;
  final String? interestPaymentOption;
  final int productId;
  final int cooperativeId;
  final int conditionId;
  final double annualRate;
  final DateTime savedAt;

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'termMonths': termMonths,
    'interestPaymentOption': interestPaymentOption,
    'productId': productId,
    'cooperativeId': cooperativeId,
    'conditionId': conditionId,
    'annualRate': annualRate,
    'savedAt': savedAt.toUtc().toIso8601String(),
  };
  factory PendingInvestmentDraft.fromJson(Map<String, dynamic> json) =>
      PendingInvestmentDraft(
        amount: (json['amount'] as num).toDouble(),
        termMonths: (json['termMonths'] as num).toInt(),
        interestPaymentOption: json['interestPaymentOption']?.toString(),
        productId: (json['productId'] as num).toInt(),
        cooperativeId: (json['cooperativeId'] as num).toInt(),
        conditionId: (json['conditionId'] as num).toInt(),
        annualRate: (json['annualRate'] as num).toDouble(),
        savedAt: DateTime.parse(json['savedAt'].toString()),
      );
}

class InvestmentDraftStore {
  InvestmentDraftStore(this._storage);
  final FlutterSecureStorage _storage;
  static const _key = 'dinerop_pending_investment_v1';
  static const _ttl = Duration(minutes: 30);

  Future<void> save(PendingInvestmentDraft draft) =>
      _storage.write(key: _key, value: jsonEncode(draft.toJson()));
  Future<void> clear() => _storage.delete(key: _key);
  Future<PendingInvestmentDraft?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return null;
      final draft = PendingInvestmentDraft.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      if (DateTime.now().toUtc().difference(draft.savedAt.toUtc()) > _ttl ||
          draft.savedAt.isAfter(
            DateTime.now().add(const Duration(minutes: 1)),
          )) {
        await clear();
        return null;
      }
      return draft;
    } catch (_) {
      await clear();
      return null;
    }
  }
}
