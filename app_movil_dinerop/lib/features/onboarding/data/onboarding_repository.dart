import '../../../core/network/api_client.dart';
import 'models/onboarding_request.dart';
import 'models/onboarding_status_response.dart';
import 'models/onboarding_submission_response.dart';
import 'models/pre_registration_data.dart';

class OnboardingRepository {
  OnboardingRepository(this._client);

  final ApiClient _client;

  Future<OnboardingStatusResponse> loadStatus() {
    return _client.request<OnboardingStatusResponse>(
      '/api/onboarding/cliente/formulario-status',
      parser: (data) => OnboardingStatusResponse.fromJson(
        Map<String, dynamic>.from(data as Map),
      ),
    );
  }

  Future<PreRegistrationData> loadPreRegistrationData() {
    return _client.request<PreRegistrationData>(
      '/api/onboarding/cliente/pre-registration',
      parser: (data) =>
          PreRegistrationData.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<OnboardingSubmissionResponse> submitClientOnboarding(
    OnboardingClientRequest request,
  ) {
    return _client.request<OnboardingSubmissionResponse>(
      '/api/onboarding/cliente/solicitante',
      method: 'POST',
      body: request.toJson(),
      parser: (data) => OnboardingSubmissionResponse.fromJson(
        Map<String, dynamic>.from(data as Map),
      ),
    );
  }

  /// The guarantor endpoint receives the same person structure as the
  /// applicant, but it must not include a spouse or the wrapper payload.
  Future<OnboardingSubmissionResponse> submitGuarantorOnboarding(
    OnboardingPersonRequest request,
  ) {
    return _client.request<OnboardingSubmissionResponse>(
      '/api/onboarding/cliente/garante/completar',
      method: 'POST',
      // PersonaOnboardingRequest in Spring does not contain the email field
      // used by the applicant flow, so keep this body exact.
      body: request.toJson()..remove('email'),
      parser: (data) => OnboardingSubmissionResponse.fromJson(
        Map<String, dynamic>.from(data as Map),
      ),
    );
  }
}
