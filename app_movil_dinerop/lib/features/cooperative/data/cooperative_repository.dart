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
          cooperativeName: cooperative.nombre,
          productName: (product['name'] ?? '').toString(),
          minimumAmount: (condition['minimumAmount'] as num).toDouble(),
          maximumAmount: (condition['maximumAmount'] as num).toDouble(),
          minimumMonths: (condition['minimumTermMonths'] as num).toInt(),
          maximumMonths: (condition['maximumTermMonths'] as num).toInt(),
          annualRate: (condition['annualRate'] as num).toDouble() / 100,
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
  const InvestmentProductOffer({required this.cooperativeName, required this.productName,
    required this.minimumAmount, required this.maximumAmount, required this.minimumMonths,
    required this.maximumMonths, required this.annualRate});
  final String cooperativeName;
  final String productName;
  final double minimumAmount;
  final double maximumAmount;
  final int minimumMonths;
  final int maximumMonths;
  final double annualRate;
}
