import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreditSimulationDraft {
  const CreditSimulationDraft({
    required this.amount,
    required this.termMonths,
    required this.creditCategory,
    required this.savedAt,
  });
  final double amount;
  final int termMonths;
  final String creditCategory;
  final DateTime savedAt;
  Map<String, dynamic> toJson() => {
    'amount': amount,
    'termMonths': termMonths,
    'creditCategory': creditCategory,
    'savedAt': savedAt.toUtc().toIso8601String(),
  };
  factory CreditSimulationDraft.fromJson(Map<String, dynamic> json) =>
      CreditSimulationDraft(
        amount: (json['amount'] as num).toDouble(),
        termMonths: (json['termMonths'] as num).toInt(),
        creditCategory: json['creditCategory'].toString(),
        savedAt: DateTime.parse(json['savedAt'].toString()),
      );
}

class CreditSimulationDraftStore {
  CreditSimulationDraftStore(this._storage);
  final FlutterSecureStorage _storage;
  static const _key = 'dinerop_credit_simulation_v1';
  static const _ttl = Duration(minutes: 30);
  Future<void> save(CreditSimulationDraft draft) =>
      _storage.write(key: _key, value: jsonEncode(draft.toJson()));
  Future<void> clear() => _storage.delete(key: _key);
  Future<CreditSimulationDraft?> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return null;
      final draft = CreditSimulationDraft.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      if (DateTime.now().toUtc().difference(draft.savedAt.toUtc()) > _ttl ||
          draft.savedAt.isAfter(
            DateTime.now().toUtc().add(const Duration(minutes: 1)),
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
