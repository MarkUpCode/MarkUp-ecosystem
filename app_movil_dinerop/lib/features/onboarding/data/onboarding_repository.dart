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
    OnboardingPersonRequest request, {
    required int solicitudId,
    required int cooperativaId,
    int? guarantorProfileId,
  }
  ) {
    return _client.request<OnboardingSubmissionResponse>(
      '/api/onboarding/cliente/garante/completar?solicitudId=$solicitudId&cooperativaId=$cooperativaId${guarantorProfileId == null ? '' : '&guarantorProfileId=$guarantorProfileId'}',
      method: 'POST',
      // PersonaOnboardingRequest in Spring does not contain the email field
      // used by the applicant flow, so keep this body exact.
      body: request.toJson()..remove('email'),
      parser: (data) => OnboardingSubmissionResponse.fromJson(
        Map<String, dynamic>.from(data as Map),
      ),
    );
  }

  Future<List<GuarantorProfile>> loadMyGuarantorProfiles() {
    return _client.request<List<GuarantorProfile>>(
      '/api/onboarding/cliente/garantes',
      parser: (data) => (data as List<dynamic>)
          .whereType<Map>()
          .map((item) => GuarantorProfile.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }
}

class GuarantorProfile {
  const GuarantorProfile({required this.id, required this.persona});
  final int id;
  final OnboardingPersonRequest persona;

  factory GuarantorProfile.fromJson(Map<String, dynamic> json) {
    final persona = Map<String, dynamic>.from(json['persona'] as Map);
    final direccion = Map<String, dynamic>.from(persona['direccion'] as Map? ?? const {});
    final actividad = persona['actividadEconomica'] == null
        ? null
        : Map<String, dynamic>.from(persona['actividadEconomica'] as Map);
    final ingreso = Map<String, dynamic>.from(persona['ingresoEgreso'] as Map? ?? const {});
    final referencias = (persona['referencias'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map((item) => OnboardingReferenceRequest(
              nombreCompleto: (item['nombreCompleto'] ?? '').toString(),
              tipo: (item['tipo'] ?? 'PERSONAL').toString(),
              parentesco: item['parentesco']?.toString(),
              telefono: item['telefono']?.toString(),
            ))
        .toList();
    return GuarantorProfile(
      id: (json['id'] as num).toInt(),
      persona: OnboardingPersonRequest(
        nombres: (persona['nombres'] ?? '').toString(),
        apellidos: (persona['apellidos'] ?? '').toString(),
        cedula: (persona['cedula'] ?? '').toString(),
        fechaNacimiento: DateTime.tryParse((persona['fechaNacimiento'] ?? '').toString()) ?? DateTime(2000),
        estadoCivil: (persona['estadoCivil'] ?? '').toString(),
        email: '',
        tieneConyuge: false,
        ocupacion: persona['ocupacion']?.toString(),
        empresaTrabajo: persona['empresaTrabajo']?.toString(),
        telefono: persona['telefono']?.toString(),
        direccion: OnboardingAddressRequest(
          provincia: (direccion['provincia'] ?? '').toString(),
          canton: (direccion['canton'] ?? '').toString(),
          barrio: direccion['barrio']?.toString(),
          callePrincipal: direccion['callePrincipal']?.toString(),
          calleSecundaria: direccion['calleSecundaria']?.toString(),
          numero: direccion['numero']?.toString(),
          referenciaUbicacion: direccion['referenciaUbicacion']?.toString(),
          tipoVivienda: direccion['tipoVivienda']?.toString() ?? 'PROPIA',
        ),
        actividadEconomica: actividad == null
            ? null
            : OnboardingEconomicRequest(
                nombreNegocio: actividad['nombreNegocio']?.toString(),
                direccionNegocio: actividad['direccionNegocio']?.toString(),
                tiempoActividad: actividad['tiempoActividad']?.toString(),
                telefonoNegocio: actividad['telefonoNegocio']?.toString(),
              ),
        ingresoEgreso: OnboardingIncomeRequest(
          ingresoMensual: (ingreso['ingresoMensual'] as num?)?.toDouble() ?? 0,
          egresoMensual: (ingreso['egresoMensual'] as num?)?.toDouble() ?? 0,
        ),
        referencias: referencias,
      ),
    );
  }
}
