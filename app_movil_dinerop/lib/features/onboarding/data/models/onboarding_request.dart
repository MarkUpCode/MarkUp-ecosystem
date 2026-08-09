class OnboardingAddressRequest {
  const OnboardingAddressRequest({
    required this.provincia,
    required this.canton,
    this.barrio,
    this.callePrincipal,
    this.numero,
    this.referenciaUbicacion,
    this.tipoVivienda,
  });

  final String provincia;
  final String canton;
  final String? barrio;
  final String? callePrincipal;
  final String? numero;
  final String? referenciaUbicacion;
  final String? tipoVivienda;

  Map<String, dynamic> toJson() => {
        'provincia': provincia,
        'canton': canton,
        'barrio': barrio,
        'callePrincipal': callePrincipal,
        'numero': numero,
        'referenciaUbicacion': referenciaUbicacion,
        'tipoVivienda': tipoVivienda,
      };
}

class OnboardingEconomicRequest {
  const OnboardingEconomicRequest({this.nombreNegocio, this.direccionNegocio, this.tiempoActividad, this.telefonoNegocio});

  final String? nombreNegocio;
  final String? direccionNegocio;
  final String? tiempoActividad;
  final String? telefonoNegocio;

  Map<String, dynamic> toJson() => {
        'nombreNegocio': nombreNegocio,
        'direccionNegocio': direccionNegocio,
        'tiempoActividad': tiempoActividad,
        'telefonoNegocio': telefonoNegocio,
      };
}

class OnboardingIncomeRequest {
  const OnboardingIncomeRequest({required this.ingresoMensual, required this.egresoMensual});

  final double ingresoMensual;
  final double egresoMensual;

  Map<String, dynamic> toJson() => {
        'ingresoMensual': ingresoMensual,
        'egresoMensual': egresoMensual,
      };
}

class OnboardingReferenceRequest {
  const OnboardingReferenceRequest({required this.nombreCompleto, required this.tipo, this.parentesco, this.telefono});

  final String nombreCompleto;
  final String tipo;
  final String? parentesco;
  final String? telefono;

  Map<String, dynamic> toJson() => {
        'nombreCompleto': nombreCompleto,
        'tipo': tipo,
        'parentesco': parentesco,
        'telefono': telefono,
      };
}

class OnboardingPersonRequest {
  const OnboardingPersonRequest({
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    required this.fechaNacimiento,
    required this.estadoCivil,
    required this.tieneConyuge,
    required this.direccion,
    required this.ingresoEgreso,
    this.ocupacion,
    this.empresaTrabajo,
    this.telefono,
    this.actividadEconomica,
    this.referencias = const [],
  });

  final String nombres;
  final String apellidos;
  final String cedula;
  final DateTime fechaNacimiento;
  final String estadoCivil;
  final String? ocupacion;
  final String? empresaTrabajo;
  final String? telefono;
  final bool tieneConyuge;
  final OnboardingAddressRequest direccion;
  final OnboardingEconomicRequest? actividadEconomica;
  final OnboardingIncomeRequest ingresoEgreso;
  final List<OnboardingReferenceRequest> referencias;

  Map<String, dynamic> toJson() => {
        'nombres': nombres,
        'apellidos': apellidos,
        'cedula': cedula,
        'fechaNacimiento': fechaNacimiento.toIso8601String().split('T').first,
        'estadoCivil': estadoCivil,
        'ocupacion': ocupacion,
        'empresaTrabajo': empresaTrabajo,
        'telefono': telefono,
        'tieneConyuge': tieneConyuge,
        'direccion': direccion.toJson(),
        'actividadEconomica': actividadEconomica?.toJson(),
        'ingresoEgreso': ingresoEgreso.toJson(),
        'referencias': referencias.map((item) => item.toJson()).toList(),
      };
}

class OnboardingClientRequest {
  const OnboardingClientRequest({required this.destinoCredito, required this.solicitante, this.conyuge});

  final String destinoCredito;
  final OnboardingPersonRequest solicitante;
  final OnboardingPersonRequest? conyuge;

  Map<String, dynamic> toJson() => {
        'destinoCredito': destinoCredito,
        'solicitante': solicitante.toJson(),
        'conyuge': conyuge?.toJson(),
      };
}