import '../../../core/network/api_client.dart';
import 'models/login_response.dart';
import 'models/public_registration_request.dart';
import 'models/public_registration_response.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<LoginResponse> login(String email, String password) {
    return _client.request<LoginResponse>(
      '/api/auth/login',
      method: 'POST',
      authenticated: false,
      body: {'email': email, 'password': password},
      parser: (data) =>
          LoginResponse.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<PublicRegistrationResponse> register(
    PublicRegistrationRequest request,
  ) {
    return _client.request<PublicRegistrationResponse>(
      '/api/credits/public-request',
      method: 'POST',
      authenticated: false,
      body: request.toJson(),
      parser: (data) => PublicRegistrationResponse.fromJson(
        Map<String, dynamic>.from(data as Map),
      ),
    );
  }

  Future<String> activate(String token) {
    return _client.request<String>(
      '/api/auth/activate',
      method: 'GET',
      authenticated: false,
      queryParameters: {'token': token},
      parser: (data) => data.toString(),
    );
  }

  Future<String> completeRegistration({
    required String email,
    required String password,
  }) {
    return _client.request<String>(
      '/api/auth/complete-registration',
      method: 'POST',
      authenticated: false,
      body: {'email': email, 'password': password},
      parser: (data) => data.toString(),
    );
  }

  Future<String> forgotPassword(String email) {
    return _client.request<String>(
      '/api/auth/password/forgot',
      method: 'POST',
      authenticated: false,
      body: {'email': email},
      parser: (data) => data.toString(),
    );
  }

  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) {
    return _client.request<String>(
      '/api/auth/password/reset',
      method: 'POST',
      authenticated: false,
      body: {'token': token, 'newPassword': newPassword},
      parser: (data) => data.toString(),
    );
  }
}
