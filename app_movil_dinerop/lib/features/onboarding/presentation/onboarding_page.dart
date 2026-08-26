import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/data/locations/ecuador_locations.dart';
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
  final _destinoController = TextEditingController(text: 'CREDITO');
  final _emailController = TextEditingController();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
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
  final _conyugeEmailController = TextEditingController();
  final _conyugeNombresController = TextEditingController();
  final _conyugeApellidosController = TextEditingController();
  final _conyugeCedulaController = TextEditingController();
  final _conyugeFechaNacimientoController = TextEditingController();
  final _conyugeTelefonoController = TextEditingController();
  final _conyugeOcupacionController = TextEditingController();
  final _conyugeEmpresaController = TextEditingController();

  final List<_ReferenceDraft> _references = [_ReferenceDraft()];

  DateTime? _fechaNacimiento;
  DateTime? _conyugeFechaNacimiento;
  bool _tieneConyuge = false;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _acceptedDeclaration = false;
  bool _showAlreadyCompleted = false;
  String? _error;
  String? _preRegistrationEmail;
  String _estadoCivil = 'SOLTERO';
  String _tipoVivienda = 'PROPIA';
  String? _selectedProvince;
  String? _selectedCanton;
  String? _selectedParish;
  int _step = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  @override
  void dispose() {
    _destinoController.dispose();
    _emailController.dispose();
    _nombresController.dispose();
    _apellidosController.dispose();
    _cedulaController.dispose();
    _fechaNacimientoController.dispose();
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
    _conyugeEmailController.dispose();
    _conyugeNombresController.dispose();
    _conyugeApellidosController.dispose();
    _conyugeCedulaController.dispose();
    _conyugeFechaNacimientoController.dispose();
    _conyugeTelefonoController.dispose();
    _conyugeOcupacionController.dispose();
    _conyugeEmpresaController.dispose();
    for (final reference in _references) {
      reference.dispose();
    }
    super.dispose();
  }

  int get _totalSteps => _tieneConyuge ? 6 : 5;

  bool get _isLastStep => _step == _totalSteps - 1;

  List<String> get _provinceNames =>
      ecuadorProvincias.map((province) => province.provincia).toList();

  Future<void> _loadInitialData() async {
    try {
      final data = await ref.read(onboardingRepositoryProvider).loadPreRegistrationData();
      _nombresController.text = data.firstName ?? '';
      _apellidosController.text = data.lastName ?? '';
      _cedulaController.text = data.identification ?? '';
      _telefonoController.text = data.phone ?? '';
      _preRegistrationEmail = data.email;
      _emailController.text = data.email ?? ref.read(authControllerProvider).user?.email ?? '';
      _selectedProvince = data.province;
      _selectedCanton = data.city;
      _provinciaController.text = data.province ?? '';
      _cantonController.text = data.city ?? '';
    } catch (_) {
      _emailController.text = ref.read(authControllerProvider).user?.email ?? '';
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<String> _availableCantons([String? province]) {
    final provinceName = province ?? _selectedProvince;
    if (provinceName == null || provinceName.isEmpty) return const [];
    final provinceData = ecuadorProvincias.firstWhere(
      (item) => item.provincia == provinceName,
      orElse: () => const EcuadorProvincia(provincia: '', cantones: []),
    );
    return provinceData.cantones.map((item) => item.nombre).toList();
  }

  List<String> _availableParishes([String? canton]) {
    final provinceName = _selectedProvince;
    final cantonName = canton ?? _selectedCanton;
    if (provinceName == null || provinceName.isEmpty || cantonName == null || cantonName.isEmpty) {
      return const [];
    }

    final provinceData = ecuadorProvincias.firstWhere(
      (item) => item.provincia == provinceName,
      orElse: () => const EcuadorProvincia(provincia: '', cantones: []),
    );
    final cantonData = provinceData.cantones.firstWhere(
      (item) => item.nombre == cantonName,
      orElse: () => const EcuadorCanton(nombre: '', parroquias: []),
    );

    return cantonData.parroquias;
  }

  void _ensureStepInRange() {
    if (_step >= _totalSteps) {
      _step = _totalSteps - 1;
    }
  }

  void _goNext() {
    setState(() {
      _step = math.min(_step + 1, _totalSteps - 1);
    });
  }

  void _goPrevious() {
    setState(() {
      _step = math.max(_step - 1, 0);
    });
  }

  void _updateProvince(String? value) {
    setState(() {
      _selectedProvince = value;
      _selectedCanton = null;
      _selectedParish = null;
      _provinciaController.text = value ?? '';
      _cantonController.clear();
      _barrioController.clear();
    });
  }

  void _updateCanton(String? value) {
    setState(() {
      _selectedCanton = value;
      _selectedParish = null;
      _cantonController.text = value ?? '';
      _barrioController.clear();
    });
  }

  void _updateParish(String? value) {
    setState(() {
      _selectedParish = value;
      _barrioController.text = value ?? '';
    });
  }

  Future<void> _pickDate({required bool spouse}) async {
    final current = spouse ? _conyugeFechaNacimiento : _fechaNacimiento;
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      initialDate: current ?? DateTime(1990),
    );

    if (selected == null) return;

    setState(() {
      if (spouse) {
        _conyugeFechaNacimiento = selected;
        _conyugeFechaNacimientoController.text = _formatDate(selected);
      } else {
        _fechaNacimiento = selected;
        _fechaNacimientoController.text = _formatDate(selected);
      }
    });
  }

  void _updateEstadoCivil(String value) {
    setState(() {
      _estadoCivil = value;
      _tieneConyuge = value == 'CASADO';

      if (_tieneConyuge) {
        _ensureSpouseFields();
      } else {
        _conyugeFechaNacimiento = null;
        _conyugeFechaNacimientoController.clear();
        _conyugeNombresController.clear();
        _conyugeApellidosController.clear();
        _conyugeCedulaController.clear();
        _conyugeTelefonoController.clear();
        _conyugeOcupacionController.clear();
        _conyugeEmpresaController.clear();
        _step = math.min(_step, 4);
      }

      _ensureStepInRange();
    });
  }

  void _ensureSpouseFields() {
    if (_conyugeNombresController.text.isEmpty &&
        _conyugeApellidosController.text.isEmpty &&
        _conyugeCedulaController.text.isEmpty &&
        _conyugeTelefonoController.text.isEmpty) {
      _conyugeNombresController.clear();
      _conyugeApellidosController.clear();
      _conyugeCedulaController.clear();
      _conyugeTelefonoController.clear();
    }
  }

  Future<void> _submit() async {
    if (!_acceptedDeclaration) {
      setState(() {
        _error = 'Debes aceptar la declaración para continuar.';
      });
      return;
    }

    if (_fechaNacimiento == null) {
      setState(() {
        _error = 'Selecciona la fecha de nacimiento.';
      });
      return;
    }

    if (_tieneConyuge && _conyugeFechaNacimiento == null) {
      setState(() {
        _error = 'Selecciona la fecha de nacimiento del cónyuge.';
      });
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
        estadoCivil: _estadoCivil,
        email: _emailController.text.trim(),
        ocupacion: _ocupacionController.text.trim(),
        empresaTrabajo: _empresaController.text.trim(),
        telefono: _telefonoController.text.trim(),
        tieneConyuge: _tieneConyuge,
        direccion: OnboardingAddressRequest(
          provincia: _provinciaController.text.trim(),
          canton: _cantonController.text.trim(),
          barrio: _barrioController.text.trim(),
          callePrincipal: _calleController.text.trim(),
          numero: _numeroController.text.trim(),
          referenciaUbicacion: _referenciaUbicacionController.text.trim(),
          tipoVivienda: _tipoVivienda,
        ),
        actividadEconomica: OnboardingEconomicRequest(
          nombreNegocio: _nombreNegocioController.text.trim(),
          direccionNegocio: _direccionNegocioController.text.trim(),
          tiempoActividad: _tiempoActividadController.text.trim(),
          telefonoNegocio: _telefonoNegocioController.text.trim(),
        ),
        ingresoEgreso: OnboardingIncomeRequest(
          ingresoMensual: double.tryParse(_ingresoController.text.replaceAll(',', '.')) ?? 0,
          egresoMensual: double.tryParse(_egresoController.text.replaceAll(',', '.')) ?? 0,
        ),
        referencias: _references.map((reference) => reference.toRequest()).toList(),
      );

      final conyuge = _tieneConyuge
          ? OnboardingPersonRequest(
              nombres: _conyugeNombresController.text.trim(),
              apellidos: _conyugeApellidosController.text.trim(),
              cedula: _conyugeCedulaController.text.trim(),
              fechaNacimiento: _conyugeFechaNacimiento!,
              estadoCivil: 'CASADO',
              email: _conyugeEmailController.text.trim(),
              ocupacion: _conyugeOcupacionController.text.trim(),
              empresaTrabajo: _conyugeEmpresaController.text.trim(),
              telefono: _conyugeTelefonoController.text.trim(),
              tieneConyuge: false,
              direccion: OnboardingAddressRequest(
                provincia: '',
                canton: '',
                barrio: '',
                callePrincipal: '',
                numero: '',
                referenciaUbicacion: '',
                tipoVivienda: 'PROPIA',
              ),
              actividadEconomica: OnboardingEconomicRequest(
                nombreNegocio: '',
                direccionNegocio: '',
                tiempoActividad: '',
                telefonoNegocio: '',
              ),
              ingresoEgreso: const OnboardingIncomeRequest(
                ingresoMensual: 0,
                egresoMensual: 0,
              ),
              referencias: const [],
            )
          : null;

      final response = await ref.read(onboardingRepositoryProvider).submitClientOnboarding(
            OnboardingClientRequest(
              destinoCredito: _destinoController.text.trim(),
              solicitante: solicitante,
              conyuge: conyuge,
            ),
          );

      await ref.read(authControllerProvider).refreshOnboardingState();
      if (!mounted) return;

      await _showSuccessDialog(
        alreadyCompleted: _showAlreadyCompleted,
        responseId: response.id,
        responseEstado: response.estado,
      );

      if (mounted) {
        context.go('/dashboard');
      }
    } on AppException catch (error) {
      final alreadyCompleted =
          error.statusCode == 400 && error.message.contains('ya ha completado el formulario de onboarding');
      if (alreadyCompleted) {
        setState(() {
          _showAlreadyCompleted = true;
        });
        await _showSuccessDialog(
          alreadyCompleted: true,
          responseId: null,
          responseEstado: null,
        );
        if (mounted) {
          context.go('/dashboard');
        }
        return;
      }

      setState(() {
        _error = error.message;
      });
    } catch (_) {
      setState(() {
        _error = AppErrorMessages.generic;
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _showSuccessDialog({
    required bool alreadyCompleted,
    required int? responseId,
    required String? responseEstado,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final isSuccess = !alreadyCompleted;
        final title = isSuccess ? '¡Formulario Guardado!' : 'Formulario Ya Completado';
        final subtitle = isSuccess
            ? 'Tu información ha sido registrada exitosamente'
            : 'Tu información ya está registrada en nuestro sistema';
        final mainMessage = isSuccess
            ? 'Tu información personal y económica ha sido guardada. Ahora puedes solicitar créditos en cooperativas aliadas.'
            : 'Ya tienes un formulario de onboarding completado. Puedes acceder a tu panel para explorar opciones de crédito.';

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? Theme.of(dialogContext).colorScheme.primaryContainer.withValues(alpha: 0.35)
                        : Theme.of(dialogContext).colorScheme.secondaryContainer.withValues(alpha: 0.35),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? Theme.of(dialogContext).colorScheme.primary.withValues(alpha: 0.1)
                              : Theme.of(dialogContext).colorScheme.secondary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSuccess ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
                          color: isSuccess
                              ? Theme.of(dialogContext).colorScheme.primary
                              : Theme.of(dialogContext).colorScheme.secondary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: Theme.of(dialogContext).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? Theme.of(dialogContext).colorScheme.primaryContainer.withValues(alpha: 0.22)
                              : Theme.of(dialogContext).colorScheme.secondaryContainer.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(dialogContext).colorScheme.outlineVariant.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Text(
                          mainMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      if (responseId != null || responseEstado != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          [
                            if (responseId != null) 'Solicitud #$responseId',
                            if (responseEstado != null) 'Estado: $responseEstado',
                          ].join(' · '),
                          textAlign: TextAlign.center,
                          style: Theme.of(dialogContext).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(dialogContext).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lo que puedes hacer ahora:',
                              style: Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            _buildBenefit(dialogContext, 'Solicitar créditos a cooperativas aliadas'),
                            _buildBenefit(dialogContext, 'Ver el estado de tus solicitudes en tiempo real'),
                            _buildBenefit(dialogContext, 'Comparar ofertas de diferentes cooperativas'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        label: 'Ir al Panel de Control',
                        icon: Icons.home_rounded,
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBenefit(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) => DateFormat('yyyy-MM-dd').format(dateTime);

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Completar Información',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Este formulario se llena una sola vez. Luego podras solicitar creditos sin volver a ingresar tus datos.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildStepContent(BuildContext context) {
    switch (_step) {
      case 0:
        return _buildIdentityStep(context);
      case 1:
        return _buildPersonalStep(context);
      case 2:
        return _buildAddressStep(context);
      case 3:
        return _buildEconomicStep(context);
      case 4:
        if (_tieneConyuge) {
          return _buildSpouseStep(context);
        }
        return _buildReviewStep(context);
      case 5:
        return _buildReviewStep(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIdentityStep(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Identidad del Cliente',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _cedulaController,
            label: 'Cédula *',
            hint: 'Ej: 1234567890',
            prefixIcon: Icons.credit_card_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _nombresController,
            label: 'Nombres *',
            hint: 'Ej: Juan',
            prefixIcon: Icons.badge_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _apellidosController,
            label: 'Apellidos *',
            hint: 'Ej: García Pérez',
            prefixIcon: Icons.badge_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _fechaNacimientoController,
            label: 'Fecha de Nacimiento *',
            hint: 'Seleccionar',
            prefixIcon: Icons.calendar_month_outlined,
            readOnly: true,
            onTap: () => _pickDate(spouse: false),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _estadoCivil,
            decoration: const InputDecoration(labelText: 'Estado Civil *'),
            items: const [
              DropdownMenuItem(value: 'SOLTERO', child: Text('SOLTERO')),
              DropdownMenuItem(value: 'CASADO', child: Text('CASADO')),
              DropdownMenuItem(value: 'DIVORCIADO', child: Text('DIVORCIADO')),
              DropdownMenuItem(value: 'VIUDO', child: Text('VIUDO')),
              DropdownMenuItem(value: 'UNIÓN LIBRE', child: Text('UNIÓN LIBRE')),
            ],
            onChanged: (value) {
              if (value != null) {
                _updateEstadoCivil(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalStep(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Datos Personales',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _emailController,
            label: 'Correo precargado',
            prefixIcon: Icons.email_outlined,
            readOnly: true,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _telefonoController,
            label: 'Teléfono *',
            hint: 'Ej: 0987654321',
            prefixIcon: Icons.phone_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _ocupacionController,
            label: 'Ocupación *',
            hint: 'Ej: Ingeniero de Sistemas',
            prefixIcon: Icons.work_outline,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _empresaController,
            label: 'Empresa o Negocio *',
            hint: 'Ej: Empresa XYZ',
            prefixIcon: Icons.apartment_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStep(BuildContext context) {
    final cantons = _availableCantons();
    final parishes = _availableParishes();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Domicilio',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: _selectedProvince,
            decoration: const InputDecoration(labelText: 'Provincia *'),
            items: _provinceNames
                .map((province) => DropdownMenuItem(value: province, child: Text(province)))
                .toList(),
            onChanged: _updateProvince,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedCanton,
            decoration: const InputDecoration(labelText: 'Cantón *'),
            items: cantons
                .map((canton) => DropdownMenuItem(value: canton, child: Text(canton)))
                .toList(),
            onChanged: _selectedProvince == null ? null : _updateCanton,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedParish,
            decoration: const InputDecoration(labelText: 'Parroquia *'),
            items: parishes
                .map((parish) => DropdownMenuItem(value: parish, child: Text(parish)))
                .toList(),
            onChanged: _selectedCanton == null ? null : _updateParish,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _calleController,
            label: 'Calle Principal *',
            hint: 'Ej: Calle 10 de Agosto',
            prefixIcon: Icons.add_road_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _numeroController,
            label: 'Número *',
            hint: 'Ej: 123-45',
            prefixIcon: Icons.numbers_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _referenciaUbicacionController,
            label: 'Referencia de Ubicación',
            hint: 'Ej: Frente al parque',
            prefixIcon: Icons.place_outlined,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _tipoVivienda,
            decoration: const InputDecoration(labelText: 'Tipo de Vivienda *'),
            items: const [
              DropdownMenuItem(value: 'PROPIA', child: Text('PROPIA')),
              DropdownMenuItem(value: 'ALQUILADA', child: Text('ALQUILADA')),
              DropdownMenuItem(value: 'FAMILIAR', child: Text('FAMILIAR')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _tipoVivienda = value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEconomicStep(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Información Económica',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Actividad Económica',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _nombreNegocioController,
                  label: 'Nombre del Negocio',
                  hint: 'Ej: Tienda de abarrotes',
                  prefixIcon: Icons.storefront_outlined,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _direccionNegocioController,
                  label: 'Dirección del Negocio',
                  hint: 'Ej: Calle Principal 123',
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _tiempoActividadController,
                  label: 'Tiempo de Actividad',
                  hint: 'Ej: 5 años',
                  prefixIcon: Icons.timelapse_outlined,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _telefonoNegocioController,
                  label: 'Teléfono del Negocio',
                  hint: 'Ej: 0987654321',
                  prefixIcon: Icons.phone_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ingresos y Egresos Mensuales',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _ingresoController,
                  label: 'Ingreso Mensual (USD) *',
                  hint: 'Ej: 1500',
                  prefixIcon: Icons.south_west_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _egresoController,
                  label: 'Egreso Mensual (USD) *',
                  hint: 'Ej: 1000',
                  prefixIcon: Icons.north_east_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Referencias Personales',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() => _references.add(_ReferenceDraft()));
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Agregar Referencia'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._references.asMap().entries.map((entry) {
                  final index = entry.key;
                  final reference = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            controller: reference.nombreCompletoController,
                            label: 'Nombre Completo *',
                            hint: 'Ej: María García',
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: reference.tipo,
                            decoration: const InputDecoration(labelText: 'Tipo de Referencia *'),
                            items: const [
                              DropdownMenuItem(value: 'PERSONAL', child: Text('PERSONAL')),
                              DropdownMenuItem(value: 'LABORAL', child: Text('LABORAL')),
                              DropdownMenuItem(value: 'COMERCIAL', child: Text('COMERCIAL')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                reference.tipo = value ?? 'PERSONAL';
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            controller: reference.parentescoController,
                            label: 'Parentesco/Relación',
                            hint: 'Ej: Amigo',
                            prefixIcon: Icons.family_restroom_outlined,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            controller: reference.telefonoController,
                            label: 'Teléfono *',
                            hint: 'Ej: 0987654321',
                            prefixIcon: Icons.phone_outlined,
                          ),
                          if (_references.length > 1) ...[
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    reference.dispose();
                                    _references.removeAt(index);
                                  });
                                },
                                child: const Text('Eliminar Referencia'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpouseStep(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Información del Cónyuge',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _conyugeCedulaController,
            label: 'Cédula del Cónyuge *',
            hint: 'Ej: 1234567890',
            prefixIcon: Icons.credit_card_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _conyugeNombresController,
            label: 'Nombres *',
            hint: 'Ej: María',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _conyugeApellidosController,
            label: 'Apellidos *',
            hint: 'Ej: García Pérez',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _conyugeFechaNacimientoController,
            label: 'Fecha de Nacimiento *',
            hint: 'Seleccionar',
            prefixIcon: Icons.calendar_month_outlined,
            readOnly: true,
            onTap: () => _pickDate(spouse: true),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _conyugeTelefonoController,
            label: 'Teléfono *',
            hint: 'Ej: 0987654321',
            prefixIcon: Icons.phone_outlined,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _conyugeOcupacionController,
            label: 'Ocupación *',
            hint: 'Ej: Ingeniera',
            prefixIcon: Icons.work_outline,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _conyugeEmpresaController,
            label: 'Empresa o Negocio *',
            hint: 'Ej: Empresa XYZ',
            prefixIcon: Icons.apartment_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(BuildContext context) {
    final hasSpouse = _tieneConyuge;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Confirmación Final',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Resumen de tu Información',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                _buildReviewSection(
                  context,
                  title: 'Identidad',
                  lines: [
                    'Nombres: ${_nombresController.text}',
                    'Apellidos: ${_apellidosController.text}',
                    'Cédula: ${_cedulaController.text}',
                    'Fecha Nacimiento: ${_fechaNacimientoController.text}',
                    'Estado Civil: $_estadoCivil',
                  ],
                ),
                const SizedBox(height: 16),
                _buildReviewSection(
                  context,
                  title: 'Contacto',
                  lines: [
                    'Teléfono: ${_telefonoController.text}',
                    'Ocupación: ${_ocupacionController.text}',
                    'Empresa: ${_empresaController.text}',
                    'Correo: ${_emailController.text}',
                  ],
                ),
                const SizedBox(height: 16),
                _buildReviewSection(
                  context,
                  title: 'Domicilio',
                  lines: [
                    'Provincia: ${_provinciaController.text}',
                    'Cantón: ${_cantonController.text}',
                    'Parroquia: ${_barrioController.text}',
                    'Calle: ${_calleController.text} ${_numeroController.text}',
                    'Tipo Vivienda: $_tipoVivienda',
                  ],
                ),
                const SizedBox(height: 16),
                _buildReviewSection(
                  context,
                  title: 'Información Económica',
                  lines: [
                    'Ingreso Mensual: ${_ingresoController.text}',
                    'Egreso Mensual: ${_egresoController.text}',
                    'Negocio: ${_nombreNegocioController.text}',
                    'Tiempo Actividad: ${_tiempoActividadController.text}',
                  ],
                ),
                if (hasSpouse) ...[
                  const SizedBox(height: 16),
                  _buildReviewSection(
                    context,
                    title: 'Información del Cónyuge',
                    lines: [
                      'Nombres: ${_conyugeNombresController.text} ${_conyugeApellidosController.text}',
                      'Cédula: ${_conyugeCedulaController.text}',
                      'Fecha Nacimiento: ${_conyugeFechaNacimientoController.text}',
                      'Teléfono: ${_conyugeTelefonoController.text}',
                      'Ocupación: ${_conyugeOcupacionController.text}',
                      'Empresa: ${_conyugeEmpresaController.text}',
                    ],
                  ),
                ],
                if (_preRegistrationEmail != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Correo precargado: ${_preRegistrationEmail!}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Antes de finalizar, certifica que toda la información proporcionada es verdadera, completa y corresponde a tu situación actual.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => setState(() => _acceptedDeclaration = !_acceptedDeclaration),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _acceptedDeclaration,
                    onChanged: (value) => setState(() => _acceptedDeclaration = value ?? false),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Declaro que la información ingresada es verídica, completa y autorizo su uso para la evaluación de solicitudes de crédito.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(
    BuildContext context, {
    required String title,
    required List<String> lines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...lines.map(
          (line) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(line, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: AppLoader(label: 'Cargando tu información...'),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  StepProgress(
                    currentStep: _step + 1,
                    totalSteps: _totalSteps,
                    label: 'Completa tu formulario',
                  ),
                  const SizedBox(height: 16),
                  if (_error != null) ...[
                    AppErrorView(message: _error!),
                    const SizedBox(height: 12),
                  ],
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: SingleChildScrollView(
                        key: ValueKey('step_${_step}_${_tieneConyuge ? 'spouse' : 'no_spouse'}'),
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildStepContent(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Anterior',
                          icon: Icons.arrow_back_rounded,
                          variant: AppButtonVariant.outlined,
                          onPressed: _step == 0 ? null : _goPrevious,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: _isLastStep ? 'Finalizar y Enviar' : 'Siguiente',
                          icon: _isLastStep ? Icons.check_rounded : Icons.arrow_forward_rounded,
                          isLoading: _isSubmitting,
                          onPressed: _isLastStep
                              ? (_acceptedDeclaration ? _submit : null)
                              : _goNext,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Este formulario se llena una sola vez. Luego podras solicitar creditos sin volver a ingresar tus datos.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReferenceDraft {
  _ReferenceDraft({
    String nombreCompleto = '',
    String this.tipo = 'PERSONAL',
    String parentesco = '',
    String telefono = '',
  })  : nombreCompletoController = TextEditingController(text: nombreCompleto),
        parentescoController = TextEditingController(text: parentesco),
        telefonoController = TextEditingController(text: telefono);

  final TextEditingController nombreCompletoController;
  final TextEditingController parentescoController;
  final TextEditingController telefonoController;
  String tipo;

  void dispose() {
    nombreCompletoController.dispose();
    parentescoController.dispose();
    telefonoController.dispose();
  }

  OnboardingReferenceRequest toRequest() {
    return OnboardingReferenceRequest(
      nombreCompleto: nombreCompletoController.text.trim(),
      tipo: tipo,
      parentesco: parentescoController.text.trim(),
      telefono: telefonoController.text.trim(),
    );
  }
}