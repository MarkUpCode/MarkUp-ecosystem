import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/step_progress.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/models/onboarding_request.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  final _destinoController = TextEditingController(text: 'CREDITO');
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _ocupacionController = TextEditingController();
  final _empresaController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _cantonController = TextEditingController();
  final _barrioController = TextEditingController();
  final _calleController = TextEditingController();
  final _numeroController = TextEditingController();
  final _referenciaUbicacionController = TextEditingController();
  final _nombreNegocioController = TextEditingController();
  final _direccionNegocioController = TextEditingController();
  final _tiempoActividadController = TextEditingController();
  final _telefonoNegocioController = TextEditingController();
  final _ingresoController = TextEditingController();
  final _egresoController = TextEditingController();
  final _estadoCivilController = TextEditingController(text: 'SOLTERO');
  final _conyugeNombresController = TextEditingController();
  final _conyugeApellidosController = TextEditingController();
  final _conyugeCedulaController = TextEditingController();
  final _conyugeTelefonoController = TextEditingController();
  DateTime? _fechaNacimiento;
  bool _tieneConyuge = false;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _error;
  int _step = 0;
  String? _preRegistrationEmail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _destinoController.dispose();
    _nombresController.dispose();
    _apellidosController.dispose();
    _cedulaController.dispose();
    _ocupacionController.dispose();
    _empresaController.dispose();
    _telefonoController.dispose();
    _provinciaController.dispose();
    _cantonController.dispose();
    _barrioController.dispose();
    _calleController.dispose();
    _numeroController.dispose();
    _referenciaUbicacionController.dispose();
    _nombreNegocioController.dispose();
    _direccionNegocioController.dispose();
    _tiempoActividadController.dispose();
    _telefonoNegocioController.dispose();
    _ingresoController.dispose();
    _egresoController.dispose();
    _estadoCivilController.dispose();
    _conyugeNombresController.dispose();
    _conyugeApellidosController.dispose();
    _conyugeCedulaController.dispose();
    _conyugeTelefonoController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final data = await ref.read(onboardingRepositoryProvider).loadPreRegistrationData();
      _nombresController.text = data.firstName ?? '';
      _apellidosController.text = data.lastName ?? '';
      _cedulaController.text = data.identification ?? '';
      _telefonoController.text = data.phone ?? '';
      _preRegistrationEmail = data.email;
      _provinciaController.text = data.province ?? '';
      _cantonController.text = data.city ?? '';
    } catch (_) {
      // Datos de pre-registro son opcionales para arrancar el wizard.
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fechaNacimiento == null) {
      setState(() => _error = 'Selecciona la fecha de nacimiento.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final solicitante = OnboardingPersonRequest(
        nombres: _nombresController.text.trim(),
        apellidos: _apellidosController.text.trim(),
        cedula: _cedulaController.text.trim(),
        fechaNacimiento: _fechaNacimiento!,
        estadoCivil: _estadoCivilController.text.trim(),
        ocupacion: _ocupacionController.text.trim().isEmpty ? null : _ocupacionController.text.trim(),
        empresaTrabajo: _empresaController.text.trim().isEmpty ? null : _empresaController.text.trim(),
        telefono: _telefonoController.text.trim().isEmpty ? null : _telefonoController.text.trim(),
        tieneConyuge: _tieneConyuge,
        direccion: OnboardingAddressRequest(
          provincia: _provinciaController.text.trim(),
          canton: _cantonController.text.trim(),
          barrio: _barrioController.text.trim().isEmpty ? null : _barrioController.text.trim(),
          callePrincipal: _calleController.text.trim().isEmpty ? null : _calleController.text.trim(),
          numero: _numeroController.text.trim().isEmpty ? null : _numeroController.text.trim(),
          referenciaUbicacion: _referenciaUbicacionController.text.trim().isEmpty ? null : _referenciaUbicacionController.text.trim(),
          tipoVivienda: null,
        ),
        actividadEconomica: OnboardingEconomicRequest(
          nombreNegocio: _nombreNegocioController.text.trim().isEmpty ? null : _nombreNegocioController.text.trim(),
          direccionNegocio: _direccionNegocioController.text.trim().isEmpty ? null : _direccionNegocioController.text.trim(),
          tiempoActividad: _tiempoActividadController.text.trim().isEmpty ? null : _tiempoActividadController.text.trim(),
          telefonoNegocio: _telefonoNegocioController.text.trim().isEmpty ? null : _telefonoNegocioController.text.trim(),
        ),
        ingresoEgreso: OnboardingIncomeRequest(
          ingresoMensual: double.tryParse(_ingresoController.text.replaceAll(',', '.')) ?? 0,
          egresoMensual: double.tryParse(_egresoController.text.replaceAll(',', '.')) ?? 0,
        ),
        referencias: const [],
      );

      final conyuge = _tieneConyuge
          ? OnboardingPersonRequest(
              nombres: _conyugeNombresController.text.trim(),
              apellidos: _conyugeApellidosController.text.trim(),
              cedula: _conyugeCedulaController.text.trim(),
              fechaNacimiento: _fechaNacimiento!,
              estadoCivil: 'CASADO',
              tieneConyuge: false,
              direccion: OnboardingAddressRequest(provincia: _provinciaController.text.trim(), canton: _cantonController.text.trim()),
              ingresoEgreso: OnboardingIncomeRequest(ingresoMensual: 0, egresoMensual: 0),
              telefono: _conyugeTelefonoController.text.trim().isEmpty ? null : _conyugeTelefonoController.text.trim(),
            )
          : null;

      final response = await ref.read(onboardingRepositoryProvider).submitClientOnboarding(
            OnboardingClientRequest(destinoCredito: _destinoController.text.trim(), solicitante: solicitante, conyuge: conyuge),
          );

      await ref.read(authControllerProvider).refreshOnboardingState();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Onboarding enviado'),
            content: Text('Solicitud #${response.id} en estado ${response.estado}.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/dashboard');
                },
                child: const Text('Continuar'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      setState(() {
        _error = error is AppException ? error.message : AppErrorMessages.generic;
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _stepScaffold({required String title, required Widget child}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: AppLoader(label: 'Preparando onboarding...'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
        actions: [
          TextButton(
            onPressed: () => context.go('/dashboard'),
            child: const Text('Omitir'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              StepProgress(currentStep: _step + 1, totalSteps: _tieneConyuge ? 6 : 5, label: 'Completa tu perfil'),
              const SizedBox(height: 20),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _stepScaffold(
                        title: 'Destino del crédito',
                        child: AppCard(
                          child: AppTextField(controller: _destinoController, label: 'Destino crédito', prefixIcon: Icons.flag_outlined),
                        ),
                      ),
                      _stepScaffold(
                        title: 'Datos personales',
                        child: AppCard(
                          child: Column(
                            children: [
                              AppTextField(controller: _nombresController, label: 'Nombres', prefixIcon: Icons.badge_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _apellidosController, label: 'Apellidos', prefixIcon: Icons.badge_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _cedulaController, label: 'Cédula', prefixIcon: Icons.credit_card_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _telefonoController, label: 'Teléfono', prefixIcon: Icons.phone_outlined),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                initialValue: _estadoCivilController.text,
                                decoration: const InputDecoration(labelText: 'Estado civil'),
                                items: const [
                                  DropdownMenuItem(value: 'SOLTERO', child: Text('Soltero')),
                                  DropdownMenuItem(value: 'CASADO', child: Text('Casado')),
                                  DropdownMenuItem(value: 'DIVORCIADO', child: Text('Divorciado')),
                                  DropdownMenuItem(value: 'VIUDO', child: Text('Viudo')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _estadoCivilController.text = value ?? 'SOLTERO';
                                    _tieneConyuge = _estadoCivilController.text == 'CASADO';
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Fecha de nacimiento'),
                                subtitle: Text(_fechaNacimiento == null ? 'Seleccionar' : _fechaNacimiento!.toIso8601String().split('T').first),
                                trailing: const Icon(Icons.calendar_month_outlined),
                                onTap: () async {
                                  final selected = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1940),
                                    lastDate: DateTime.now(),
                                    initialDate: _fechaNacimiento ?? DateTime(1990),
                                  );
                                  if (selected != null) {
                                    setState(() => _fechaNacimiento = selected);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      _stepScaffold(
                        title: 'Dirección',
                        child: AppCard(
                          child: Column(
                            children: [
                              AppTextField(controller: _provinciaController, label: 'Provincia', prefixIcon: Icons.location_city_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _cantonController, label: 'Cantón', prefixIcon: Icons.map_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _barrioController, label: 'Barrio', prefixIcon: Icons.home_work_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _calleController, label: 'Calle principal', prefixIcon: Icons.add_road_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _numeroController, label: 'Número', prefixIcon: Icons.numbers_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _referenciaUbicacionController, label: 'Referencia', prefixIcon: Icons.place_outlined),
                            ],
                          ),
                        ),
                      ),
                      _stepScaffold(
                        title: 'Economía',
                        child: AppCard(
                          child: Column(
                            children: [
                              AppTextField(controller: _ocupacionController, label: 'Ocupación', prefixIcon: Icons.work_outline),
                              const SizedBox(height: 12),
                              AppTextField(controller: _empresaController, label: 'Empresa trabajo', prefixIcon: Icons.apartment_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _nombreNegocioController, label: 'Nombre negocio', prefixIcon: Icons.storefront_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _direccionNegocioController, label: 'Dirección negocio', prefixIcon: Icons.location_on_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _tiempoActividadController, label: 'Tiempo de actividad', prefixIcon: Icons.timelapse_outlined),
                              const SizedBox(height: 12),
                              AppTextField(controller: _ingresoController, label: 'Ingreso mensual', prefixIcon: Icons.south_west_outlined, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                              const SizedBox(height: 12),
                              AppTextField(controller: _egresoController, label: 'Egreso mensual', prefixIcon: Icons.north_east_outlined, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                            ],
                          ),
                        ),
                      ),
                      if (_tieneConyuge)
                        _stepScaffold(
                          title: 'Cónyuge',
                          child: AppCard(
                            child: Column(
                              children: [
                                AppTextField(controller: _conyugeNombresController, label: 'Nombres cónyuge', prefixIcon: Icons.person_outline),
                                const SizedBox(height: 12),
                                AppTextField(controller: _conyugeApellidosController, label: 'Apellidos cónyuge', prefixIcon: Icons.person_outline),
                                const SizedBox(height: 12),
                                AppTextField(controller: _conyugeCedulaController, label: 'Cédula cónyuge', prefixIcon: Icons.credit_card_outlined),
                                const SizedBox(height: 12),
                                AppTextField(controller: _conyugeTelefonoController, label: 'Teléfono cónyuge', prefixIcon: Icons.phone_outlined),
                              ],
                            ),
                          ),
                        ),
                      _stepScaffold(
                        title: 'Revisión final',
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Correo precargado: ${_preRegistrationEmail ?? '-'}', style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 12),
                              Text('Nombres: ${_nombresController.text} ${_apellidosController.text}', style: Theme.of(context).textTheme.bodyMedium),
                              Text('Cédula: ${_cedulaController.text}', style: Theme.of(context).textTheme.bodyMedium),
                              Text('Provincia: ${_provinciaController.text}', style: Theme.of(context).textTheme.bodyMedium),
                              Text('Ciudad: ${_cantonController.text}', style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 12),
                              if (_error != null) AppErrorView(message: _error!),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                AppErrorView(message: _error!),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _step == 0 ? null : () {
                        setState(() => _step -= 1);
                        _pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                      },
                      child: const Text('Anterior'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: _step == (_tieneConyuge ? 5 : 4) ? 'Enviar' : 'Siguiente',
                      icon: _step == (_tieneConyuge ? 5 : 4) ? Icons.check_rounded : Icons.arrow_forward_rounded,
                      isLoading: _isSubmitting,
                      onPressed: () {
                        if (_step == (_tieneConyuge ? 5 : 4)) {
                          _submit();
                          return;
                        }
                        setState(() => _step += 1);
                        _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}