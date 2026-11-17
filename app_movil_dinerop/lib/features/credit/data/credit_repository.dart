import '../../../core/network/api_client.dart';
import '../../cooperative/data/models/cooperative_summary.dart';
import 'models/client_credit_request.dart';
import 'models/credit_cooperative_status.dart';
import 'models/credit_request_payload.dart';
import 'models/credit_request_response.dart';
import 'models/public_credit_offer.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class CreditRepository {
  CreditRepository(this._client);

  final ApiClient _client;

  Future<List<PublicCreditOffer>> loadPublicOffers({
    required String creditCategory,
    required double amount,
    required int termMonths,
  }) async {
    final data = await _client.request<List<dynamic>>(
      '/api/credits/public-offers',
      authenticated: false,
      queryParameters: {
        'creditCategory': creditCategory,
        'amount': amount,
        'termMonths': termMonths,
      },
      parser: (data) => List<dynamic>.from(data as List),
    );
    return data
        .map(
          (item) => PublicCreditOffer.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<CreditRequestResponse> createCreditRequest(
    CreditRequestPayload payload,
  ) {
    return _client.request<CreditRequestResponse>(
      '/api/credits/me',
      method: 'POST',
      body: payload.toJson(),
      parser: (data) => CreditRequestResponse.fromJson(
        Map<String, dynamic>.from(data as Map),
      ),
    );
  }

  Future<List<ClientCreditRequestSummary>> loadMyRequests() async {
    final response = await _client.request<dynamic>(
      '/api/credits/me',
      parser: (data) => data,
    );
    if (response == null) return <ClientCreditRequestSummary>[];

    final list = response is List ? response : <dynamic>[response];
    return list
        .whereType<Map>()
        .map(
          (item) => ClientCreditRequestSummary.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<List<CreditCooperativeStatus>> loadPreApprovedCooperatives(
    int solicitudId,
  ) async {
    final response = await _client.request<List<dynamic>>(
      '/api/credits/me/$solicitudId/pre-approved',
      parser: (data) => List<dynamic>.from(data as List),
    );
    return response
        .map(
          (item) => CreditCooperativeStatus.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>> loadGuarantorHistory({
    required int solicitudId,
    required int cooperativaId,
  }) async {
    final response = await _client.request<List<dynamic>>(
      '/api/credits/me/$solicitudId/cooperatives/$cooperativaId/garantes/historial',
      parser: (data) => List<dynamic>.from(data as List),
    );
    return response
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> acceptCooperative({
    required int solicitudId,
    required int cooperativaId,
  }) async {
    await _client.request<void>(
      '/api/credits/me/$solicitudId/cooperatives/$cooperativaId/accept',
      method: 'PUT',
      parser: (_) {},
    );
  }

  Future<Uint8List> downloadReferralPdf({
    required int solicitudId,
    required int cooperativaId,
  }) {
    return _client.request<Uint8List>(
      '/api/credits/me/$solicitudId/cooperatives/$cooperativaId/referral.pdf',
      responseType: ResponseType.bytes,
      parser: (data) => Uint8List.fromList(List<int>.from(data as List)),
    );
  }

  Future<List<CooperativeSummary>> loadCatalog() async {
    final response = await _client.request<List<dynamic>>(
      '/api/cooperatives',
      parser: (data) => List<dynamic>.from(data as List),
    );
    return response
        .map(
          (item) => CooperativeSummary.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
