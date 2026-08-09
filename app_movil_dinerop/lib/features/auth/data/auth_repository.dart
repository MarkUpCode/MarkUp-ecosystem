import '../../../core/storage/secure_token_storage.dart';
import 'models/app_user.dart';
import 'models/login_response.dart';
import 'models/public_registration_request.dart';
import 'models/public_registration_response.dart';
import 'auth_remote_data_source.dart';

class AuthRepository {
  AuthRepository(this._remote, this._storage);

  final AuthRemoteDataSource _remote;
  final SecureTokenStorage _storage;

  Future<SessionSnapshot?> readSession() => _storage.readSession();

  Future<void> saveSession({
    required String token,
    required AppUser user,
    required bool onboardingComplete,
  }) {
    return _storage.saveSession(token: token, user: user, onboardingComplete: onboardingComplete);
  }

  Future<void> clearSession() => _storage.clear();

  Future<LoginResponse> login(String email, String password) => _remote.login(email, password);

  Future<PublicRegistrationResponse> register(PublicRegistrationRequest request) => _remote.register(request);

  Future<String> activate(String token) => _remote.activate(token);

  Future<String> completeRegistration({required String email, required String password}) =>
      _remote.completeRegistration(email: email, password: password);

  Future<String> forgotPassword(String email) => _remote.forgotPassword(email);

  Future<String> resetPassword({required String token, required String newPassword}) =>
      _remote.resetPassword(token: token, newPassword: newPassword);
}