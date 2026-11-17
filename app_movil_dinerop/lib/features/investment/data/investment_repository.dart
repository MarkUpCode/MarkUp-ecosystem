import '../../../core/network/api_client.dart';
import 'models/investment_models.dart';

class InvestmentRepository {
  InvestmentRepository(this._client);

  final ApiClient _client;

  Future<InvestmentAvailability> getAvailability({
    required double amount,
    int? termMonths,
  }) async {
    final data = await _client.request<Map<String, dynamic>>(
      '/api/investments/availability',
      authenticated: false,
      queryParameters: {
        'amount': amount,
        if (termMonths != null) 'termMonths': termMonths,
      },
      parser: (data) => Map<String, dynamic>.from(data as Map),
    );
    return InvestmentAvailability.fromJson(data);
  }

  Future<List<InvestmentOffer>> compareOffers({
    required double amount,
    required int termMonths,
    String? interestPaymentOption,
  }) async {
    final data = await _client.request<List<dynamic>>(
      '/api/investments/offers',
      authenticated: false,
      queryParameters: {
        'amount': amount,
        'termMonths': termMonths,
        if (interestPaymentOption != null)
          'interestPaymentOption': interestPaymentOption,
      },
      parser: (data) => List<dynamic>.from(data as List),
    );
    return data
        .map(
          (item) =>
              InvestmentOffer.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<InvestmentRequest> createRequest({
    required InvestmentOffer offer,
    required double amount,
    required int termMonths,
    required bool consent,
    String? interestPaymentOption,
  }) async {
    final data = await _client.request<Map<String, dynamic>>(
      '/api/investments/requests',
      method: 'POST',
      body: {
        'productId': offer.productId,
        'conditionId': offer.conditionId,
        'amount': amount,
        'termMonths': termMonths,
        'interestPaymentOption': interestPaymentOption,
        'personalDataConsent': consent,
      },
      parser: (data) => Map<String, dynamic>.from(data as Map),
    );
    return InvestmentRequest.fromJson(data);
  }

  Future<List<InvestmentRequest>> loadMyRequests() async {
    final data = await _client.request<List<dynamic>>(
      '/api/investments/requests/me',
      parser: (data) => List<dynamic>.from(data as List),
    );
    return data
        .map(
          (item) => InvestmentRequest.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
