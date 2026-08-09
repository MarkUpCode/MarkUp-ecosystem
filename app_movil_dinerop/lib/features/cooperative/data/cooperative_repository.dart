import '../../../core/network/api_client.dart';
import 'models/cooperative_summary.dart';

class CooperativeRepository {
  CooperativeRepository(this._client);

  final ApiClient _client;

  Future<List<CooperativeSummary>> loadCooperatives() async {
    final data = await _client.request<List<dynamic>>('/api/cooperatives', parser: (data) => List<dynamic>.from(data as List));
    return data.map((item) => CooperativeSummary.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }
}