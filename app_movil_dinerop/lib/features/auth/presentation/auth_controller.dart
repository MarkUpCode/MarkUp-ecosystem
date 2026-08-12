import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../../../core/errors/app_exception.dart';
import '../../onboarding/data/models/onboarding_status_response.dart';
import '../../onboarding/data/onboarding_repository.dart';
import '../data/auth_remote_data_source.dart';
import '../data/auth_repository.dart';
import '../data/models/app_user.dart';
import '../data/models/login_response.dart';
import '../data/models/public_registration_request.dart';

class AuthController extends ChangeNotifier {
  AuthController(
    this._authRepository,
    this._onboardingRepository,
  ) {
    unawaited(_bootstrap());
  }

  final AuthRepository _authRepository;
  final OnboardingRepository _onboardingRepository;

  bool _isBootstrapping = true;
  bool _isBusy = false;
  AppUser? _user;
  String? _token;
  bool _onboardingComplete = false;
  String? _errorMessage;
  String? _bootstrapErrorMessage;
  String? _lastEmail;

  bool get isBootstrapping => _isBootstrapping;
  bool get isBusy => _isBusy;
  bool get isAuthenticated => _token != null && _user != null;
  bool get requiresActivation => _user?.isPendingActivation ?? false;
  bool get requiresOnboarding =>
      isAuthenticated &&
      (_user?.isClient ?? false) &&
      !_onboardingComplete &&
      !requiresActivation;
  AppUser? get user => _user;
  String? get token => _token;
  bool get onboardingComplete => _onboardingComplete;
  String? get errorMessage => _errorMessage;
  String? get bootstrapErrorMessage => _bootstrapErrorMessage;
  String? get lastEmail => _lastEmail;

  Future<void> _bootstrap() async {
    debugPrint('[BOOT 5] Bootstrap started');
    try {
      debugPrint('[BOOT 6] Reading secure storage');
      final session = await _authRepository.readSession().timeout(
        const Duration(seconds: 10),
      );
      debugPrint('[BOOT 7] Token found: ${session != null}');
      if (session == null) {
        debugPrint('[BOOT 11] Auth state updated: unauthenticated');
        return;
      }


      debugPrint('[BOOT 8] Restoring session');
      _token = session.token;
      _user = session.user;
      _onboardingComplete = session.onboardingComplete;

      if (_user?.isClient == true && _user?.isActive == true) {
        debugPrint('[BOOT 9] Calling API to refresh onboarding status');
        unawaited(_refreshOnboardingStateFromBackend());
      }
    } catch (error, stackTrace) {
      debugPrint('[BOOT] Bootstrap failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      // Do not await a failing platform-storage operation here: that was able
      // to keep the router in its splash redirect indefinitely.
      _user = null;
      _token = null;
      _onboardingComplete = false;
      _bootstrapErrorMessage = 'No pudimos preparar el almacenamiento seguro.';
      unawaited(_clearSessionAfterBootstrapFailure());
    } finally {
      debugPrint('[BOOT 12] Bootstrap completed');
      _isBootstrapping = false;
      notifyListeners();
      debugPrint(
        '[BOOT 13] Navigation decision: ${isAuthenticated ? 'authenticated' : 'unauthenticated'}',
      );
      debugPrint('[BOOT 14] Application ready');
    }
  }

  Future<void> _clearSessionAfterBootstrapFailure() async {
    try {
      await _authRepository.clearSession().timeout(const Duration(seconds: 10));
    } catch (error) {
      debugPrint('[BOOT] Unable to clear invalid persisted session: $error');
    }
  }

  Future<void> retryBootstrap() async {
    if (_isBootstrapping) return;
    _bootstrapErrorMessage = null;
    _isBootstrapping = true;
    notifyListeners();
    await _bootstrap();
  }

  Future<void> _refreshOnboardingStateFromBackend() async {
    try {
      debugPrint('[BOOT] Checking authentication');
      final status = await _safeLoadOnboardingStatus();
      if (status == null) {
        debugPrint('[BOOT] Onboarding status unavailable');
        return;
      }

      _onboardingComplete = status.formularioCompleto;
      debugPrint('[BOOT 10] API response received');
      await _persistCurrentSession();
      debugPrint('[BOOT] Onboarding refresh completed');
      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('[BOOT] Onboarding refresh failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<OnboardingStatusResponse?> _safeLoadOnboardingStatus() async {
    try {
      return await _onboardingRepository.loadStatus().timeout(
        const Duration(seconds: 8),
      );
    } catch (error, stackTrace) {
      debugPrint('[BOOT] Onboarding status check failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (error is AppException && error.statusCode == 401) {
        debugPrint('[BOOT] Persisted token rejected; signing out');
        await logout(silent: true);
      }
      return null;
    }
  }

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  Future<void> _persistCurrentSession() async {
    if (_token == null || _user == null) {
      return;
    }
    await _authRepository.saveSession(
      token: _token!,
      user: _user!,
      onboardingComplete: _onboardingComplete,
    );
  }

  Future<LoginResponse> login(String email, String password) async {
    _setBusy(true);
    _errorMessage = null;
    _lastEmail = email;
    try {
      final response = await _authRepository.login(email, password);
      _token = response.accessToken;
      _user = response.user;

      if (_user?.isActive == true && _user?.isClient == true) {
        final status = await _safeLoadOnboardingStatus();
        _onboardingComplete = status?.formularioCompleto ?? false;
      } else {
        _onboardingComplete = false;
      }

      await _persistCurrentSession();
      notifyListeners();
      return response;
    } catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> register(PublicRegistrationRequest request) async {
    _setBusy(true);
    _errorMessage = null;
    try {
      await _authRepository.register(request);
      _lastEmail = request.email;
    } catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> activate(String token) async {
    _setBusy(true);
    _errorMessage = null;
    try {
      await _authRepository.activate(token);
    } catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> completeRegistration({
    required String email,
    required String password,
  }) async {
    _setBusy(true);
    _errorMessage = null;
    try {
      await _authRepository.completeRegistration(
        email: email,
        password: password,
      );
      _lastEmail = email;
    } catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<String> forgotPassword(String email) async {
    _setBusy(true);
    _errorMessage = null;
    try {
      return await _authRepository.forgotPassword(email);
    } catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    _setBusy(true);
    _errorMessage = null;
    try {
      return await _authRepository.resetPassword(
        token: token,
        newPassword: newPassword,
      );
    } catch (error) {
      _errorMessage = error.toString();
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> logout({bool silent = false}) async {
    if (!silent) {
      _setBusy(true);
    }
    await _authRepository.clearSession();
    _user = null;
    _token = null;
    _onboardingComplete = false;
    _errorMessage = null;
    _lastEmail = null;
    _isBusy = false;
    notifyListeners();
  }

  Future<void> refreshOnboardingState() async {
    if (!isAuthenticated ||
        _user?.isClient != true ||
        _user?.isActive != true) {
      return;
    }
    final status = await _safeLoadOnboardingStatus();
    if (status != null) {
      _onboardingComplete = status.formularioCompleto;
      await _persistCurrentSession();
      notifyListeners();
    }
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(apiClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(secureTokenStorageProvider),
  );
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(ref.watch(apiClientProvider));
});

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref.watch(onboardingRepositoryProvider),
  );
});

