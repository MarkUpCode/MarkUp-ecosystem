import '../../../core/network/api_client.dart';
import 'models/cooperative_summary.dart';

class CooperativeRepository {
  CooperativeRepository(this._client);

  final ApiClient _client;

  Future<List<CooperativeSummary>> loadCooperatives() async {
    final data = await _client.request<List<dynamic>>('/api/cooperatives', parser: (data) => List<dynamic>.from(data as List));
    return data.map((item) => CooperativeSummary.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }

  Future<List<InvestmentProductOffer>> loadInvestmentProducts(CooperativeSummary cooperative) async {
    final data = await _client.request<List<dynamic>>(
      '/api/cooperatives/${cooperative.id}/products',
      authenticated: false,
      parser: (data) => List<dynamic>.from(data as List),
    );
    final offers = <InvestmentProductOffer>[];
    for (final raw in data) {
      final product = Map<String, dynamic>.from(raw as Map);
      if (product['type'] != 'INVESTMENT' || product['active'] != true) continue;
      for (final rawCondition in List<dynamic>.from(product['conditions'] as List? ?? const [])) {
        final condition = Map<String, dynamic>.from(rawCondition as Map);
        offers.add(InvestmentProductOffer(
          cooperativeId: cooperative.id,
          cooperativeName: cooperative.nombre,
          cooperativeLogoUrl: cooperative.logoUrl,
          productId: (product['id'] as num).toInt(),
          conditionId: (condition['id'] as num).toInt(),
          productName: (product['name'] ?? '').toString(),
          description: product['description']?.toString(),
          minimumAmount: (condition['minimumAmount'] as num).toDouble(),
          maximumAmount: (condition['maximumAmount'] as num).toDouble(),
          minimumMonths: (condition['minimumTermMonths'] as num).toInt(),
          maximumMonths: (condition['maximumTermMonths'] as num).toInt(),
          annualRate: (condition['annualRate'] as num).toDouble() / 100,
          validFrom: DateTime.parse(condition['validFrom'].toString()),
          validUntil: condition['validUntil'] == null
              ? null
              : DateTime.parse(condition['validUntil'].toString()),
          interestPaymentOptions: List<String>.from(
            product['interestPaymentOptions'] as List? ?? const [],
          ),
          calculationMethod: (product['calculationMethod'] ?? 'UNSPECIFIED')
              .toString(),
          renewalConditions: product['renewalConditions']?.toString(),
          earlyCancellationConditions: product['earlyCancellationConditions']
              ?.toString(),
          targetAudience: product['targetAudience']?.toString(),
        ));
      }
    }
    return offers;
  }

  Future<List<InvestmentProductOffer>> loadInvestmentCatalog() async {
    final cooperatives = await loadCooperatives();
    final results = await Future.wait(cooperatives.map(loadInvestmentProducts));
    return results.expand((items) => items).toList();
  }
}

class InvestmentProductOffer {
  const InvestmentProductOffer({
    required this.cooperativeId,
    required this.cooperativeName,
    required this.cooperativeLogoUrl,
    required this.productId,
    required this.conditionId,
    required this.productName,
    required this.description,
    required this.minimumAmount,
    required this.maximumAmount,
    required this.minimumMonths,
    required this.maximumMonths,
    required this.annualRate,
    required this.validFrom,
    required this.validUntil,
    required this.interestPaymentOptions,
    required this.calculationMethod,
    required this.renewalConditions,
    required this.earlyCancellationConditions,
    required this.targetAudience,
  });
  final int cooperativeId;
  final String cooperativeName;
  final String? cooperativeLogoUrl;
  final int productId;
  final int conditionId;
  final String productName;
  final String? description;
  final double minimumAmount;
  final double maximumAmount;
  final int minimumMonths;
  final int maximumMonths;
  final double annualRate;
  final DateTime validFrom;
  final DateTime? validUntil;
  final List<String> interestPaymentOptions;
  final String calculationMethod;
  final String? renewalConditions;
  final String? earlyCancellationConditions;
  final String? targetAudience;
}
