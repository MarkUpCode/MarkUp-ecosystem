import '../../../core/network/api_client.dart';
import '../../cooperative/data/models/cooperative_summary.dart';
import 'models/client_credit_request.dart';
import 'models/credit_cooperative_status.dart';
import 'models/credit_request_payload.dart';
import 'models/credit_request_response.dart';

class CreditRepository {
  CreditRepository(this._client);

  final ApiClient _client;

  Future<CreditRequestResponse> createCreditRequest(CreditRequestPayload payload) {
    return _client.request<CreditRequestResponse>(
      '/api/credits/me',
      method: 'POST',
      body: payload.toJson(),
      parser: (data) => CreditRequestResponse.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<List<ClientCreditRequestSummary>> loadMyRequests() async {
    final response = await _client.request<dynamic>('/api/credits/me', parser: (data) => data);
    if (response == null) return <ClientCreditRequestSummary>[];

    final list = response is List ? response : <dynamic>[response];
    return list
        .whereType<Map>()
        .map((item) => ClientCreditRequestSummary.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<List<CreditCooperativeStatus>> loadPreApprovedCooperatives(int solicitudId) async {
    final response = await _client.request<List<dynamic>>(
      '/api/credits/me/$solicitudId/pre-approved',
      parser: (data) => List<dynamic>.from(data as List),
    );
    return response.map((item) => CreditCooperativeStatus.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }

  Future<void> acceptCooperative({required int solicitudId, required int cooperativaId}) async {
    await _client.request<void>(
      '/api/credits/me/$solicitudId/cooperatives/$cooperativaId/accept',
      method: 'PUT',
      parser: (_) {},
    );
  }

  Future<List<CooperativeSummary>> loadCatalog() async {
    final response = await _client.request<List<dynamic>>('/api/cooperatives', parser: (data) => List<dynamic>.from(data as List));
    return response.map((item) => CooperativeSummary.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }
}