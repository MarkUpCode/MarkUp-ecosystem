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

  Future<String> verifyRegistrationCode({
    required String email,
    required String code,
  }) {
    return _client.request<String>(
      '/api/auth/registration/verify-code',
      method: 'POST',
      authenticated: false,
      body: {'email': email, 'code': code},
      parser: (data) => data.toString(),
    );
  }

  Future<String> resendRegistrationCode(String email) {
    return _client.request<String>(
      '/api/auth/registration/resend-code',
      method: 'POST',
      authenticated: false,
      body: {'email': email},
      parser: (data) => data is Map ? (data['message'] ?? '').toString() : data.toString(),
    );
  }

  Future<String> setRegistrationPassword({
    required String email,
    required String password,
  }) {
    return _client.request<String>(
      '/api/auth/registration/set-password',
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
