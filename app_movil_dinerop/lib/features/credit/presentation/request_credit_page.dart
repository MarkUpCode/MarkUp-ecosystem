import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/data/locations/ecuador_locations.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../dolarito/models/dolarito_mood.dart';
import '../../dolarito/providers/dolarito_provider.dart';
import '../../dolarito/widgets/dolarito_widget.dart';
import '../data/models/credit_enums.dart';
import '../data/models/credit_request_payload.dart';

class RequestCreditPage extends ConsumerStatefulWidget {
  const RequestCreditPage({super.key});

  @override
  ConsumerState<RequestCreditPage> createState() => _RequestCreditPageState();
}

class _RequestCreditPageState extends ConsumerState<RequestCreditPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _plazoController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  CreditRequestType _type = CreditRequestType.credito;
  CreditType _creditType = CreditType.microcredito;
  String? _selectedProvince;
  String? _selectedCity;
  String? _error;
  String? _success;
  bool _isLoading = false;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLocationData());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _plazoController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  List<String> get _provinceNames =>
      ecuadorProvincias.map((province) => province.provincia).toList();

  List<String> _cityNames([String? province]) {
    final provinceName = province ?? _selectedProvince;
    if (provinceName == null || provinceName.isEmpty) return const [];

    final provinceData = ecuadorProvincias.firstWhere(
      (item) => item.provincia == provinceName,
      orElse: () => const EcuadorProvincia(provincia: '', cantones: []),
    );
    return provinceData.cantones.map((city) => city.nombre).toList();
  }

  Future<void> _loadLocationData() async {
    try {
      final onboarding = await ref
          .read(onboardingRepositoryProvider)
          .loadStatus();
      if (!onboarding.formularioCompleto) return;
      final profile = await ref.read(clientProfileProvider.future);
      final province = profile.province?.trim();
      final city = profile.city?.trim();
      final validProvince =
          province != null && _provinceNames.contains(province)
          ? province
          : null;
      final validCity =
          validProvince != null &&
              city != null &&
              _cityNames(validProvince).contains(city)
          ? city
          : null;

      if (!mounted) return;
      setState(() {
        _selectedProvince = validProvince;
        _selectedCity = validCity;
        _provinceController.text = validProvince ?? '';
        _cityController.text = validCity ?? '';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is AppException
            ? error.message
            : AppErrorMessages.generic;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  void _updateProvince(String? value) {
    setState(() {
      _selectedProvince = value;
      _selectedCity = null;
      _provinceController.text = value ?? '';
      _cityController.clear();
    });
  }

  void _updateCity(String? value) {
    setState(() {
      _selectedCity = value;
      _cityController.text = value ?? '';
    });
  }

  Future<void> _submit() async {
    try {
      final onboarding = await ref
          .read(onboardingRepositoryProvider)
          .loadStatus();
      if (!onboarding.formularioCompleto) {
        ref
            .read(dolaritoProvider.notifier)
            .show(
              ref.read(dolaritoServiceProvider).onboardingRequired(),
              force: true,
            );
        if (mounted) {
          setState(
            () => _error = 'Completa tu perfil antes de enviar una solicitud.',
          );
        }
        return;
      }
    } catch (error) {
      ref
          .read(dolaritoProvider.notifier)
          .show(
            ref.read(dolaritoServiceProvider).profileStatusError(),
            force: true,
          );
      if (mounted) {
        setState(
          () => _error = error is AppException
              ? error.message
              : 'No pudimos comprobar el estado de tu perfil.',
        );
      }
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _success = null;
    });

    try {
      final payload = CreditRequestPayload(
        amount: double.parse(_amountController.text.replaceAll(',', '.')),
        type: _type,
        creditType: _type == CreditRequestType.inversion ? null : _creditType,
        plazoMeses: _plazoController.text.trim().isEmpty
            ? null
            : int.tryParse(_plazoController.text.trim()),
        province: _provinceController.text.trim(),
        city: _cityController.text.trim(),
      );
      final response = await ref
          .read(creditRepositoryProvider)
          .createCreditRequest(payload);
      ref.invalidate(dashboardCreditRequestsProvider);
      ref.invalidate(requestsProvider);

      if (!mounted) return;
      await _showSubmissionConfirmation(response.cooperativasNotificadas);
      if (mounted) context.go('/dashboard');
    } catch (error) {
      if (!mounted) return;
      ref
          .read(dolaritoProvider.notifier)
          .show(
            ref.read(dolaritoServiceProvider).creditLoadError(),
            force: true,
          );
      setState(() {
        _error = error is AppException
            ? error.message
            : AppErrorMessages.generic;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showSubmissionConfirmation(int? cooperativasNotificadas) async {
    final count = cooperativasNotificadas;
    final destination = count == null
        ? 'a las cooperativas disponibles'
        : 'a $count ${count == 1 ? 'cooperativa' : 'cooperativas'}';

    late final Timer autoCloseTimer;
    final dialogFuture = showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.check_circle_rounded,
            color: Theme.of(dialogContext).colorScheme.primary,
            size: 48,
          ),
          title: const Text('Solicitud enviada'),
          content: Text(
            'Enviamos tu solicitud correctamente $destination. '
            'Ahora espera cualquier novedad; te avisaremos cuando haya una respuesta.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Ir al menú principal'),
            ),
          ],
        );
      },
    );
    autoCloseTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
    await dialogFuture;
    autoCloseTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(dashboardOnboardingStatusProvider);
    if (onboarding.isLoading) {
      return const Scaffold(
        appBar: null,
        body: AppLoader(label: 'Verificando que tu perfil esté completo...'),
      );
    }
    if (onboarding.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Solicitar crédito')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: DolaritoWidget(
              mood: DolaritoMood.worried,
              message:
                  'No pudimos comprobar tu perfil con el servidor. Vuelve a intentarlo antes de enviar una solicitud.',
              compact: true,
              actionLabel: 'Volver a comprobar',
              onAction: () => ref.invalidate(dashboardOnboardingStatusProvider),
            ),
          ),
        ),
      );
    }
    if (onboarding.value?.formularioCompleto != true) {
      return Scaffold(
        appBar: AppBar(title: const Text('Completa tu perfil')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: DolaritoWidget(
                mood: DolaritoMood.explaining,
                message:
                    'Antes de enviar tu solicitud, completemos tu perfil. Las cooperativas necesitan esta información para evaluar tu crédito.',
                compact: true,
                actionLabel: 'Completar mi perfil',
                onAction: () => context.push('/onboarding'),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar crédito')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DolaritoWidget(
                    mood: DolaritoMood.motivated,
                    message:
                        'Tu perfil está listo. Revisemos juntos la información de tu solicitud.',
                    compact: true,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Completa la información mínima.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<CreditRequestType>(
                    initialValue: _type,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de solicitud',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: CreditRequestType.credito,
                        child: Text('Crédito'),
                      ),
                      DropdownMenuItem(
                        value: CreditRequestType.inversion,
                        child: Text('Inversión'),
                      ),
                    ],
                    onChanged: (value) => setState(
                      () => _type = value ?? CreditRequestType.credito,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CreditType>(
                    initialValue: _creditType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de crédito',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: CreditType.microcredito,
                        child: Text('Microcrédito'),
                      ),
                      DropdownMenuItem(
                        value: CreditType.consumo,
                        child: Text('Consumo'),
                      ),
                    ],
                    onChanged: _type == CreditRequestType.inversion
                        ? null
                        : (value) => setState(
                            () =>
                                _creditType = value ?? CreditType.microcredito,
                          ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _amountController,
                    label: 'Monto',
                    prefixIcon: Icons.payments_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Ingresa un monto'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _plazoController,
                    label: 'Plazo en meses (opcional)',
                    prefixIcon: Icons.schedule_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedProvince,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Provincia',
                      hintText: 'Selecciona una provincia',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                    items: _provinceNames
                        .map(
                          (province) => DropdownMenuItem(
                            value: province,
                            child: Text(
                              province,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: _isLoadingLocation ? null : _updateProvince,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Selecciona una provincia'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCity,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Ciudad',
                      hintText: _selectedProvince == null
                          ? 'Primero selecciona una provincia'
                          : 'Selecciona una ciudad',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                    ),
                    items: _cityNames()
                        .map(
                          (city) => DropdownMenuItem(
                            value: city,
                            child: Text(city, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: _isLoadingLocation || _selectedProvince == null
                        ? null
                        : _updateCity,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Selecciona una ciudad'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  if (_error != null) ...[
                    AppErrorView(message: _error!),
                    const SizedBox(height: 16),
                  ],
                  if (_success != null) ...[
                    AppBadge(label: _success!),
                    const SizedBox(height: 16),
                  ],
                  AppButton(
                    label: 'Enviar solicitud',
                    icon: Icons.send_rounded,
                    isLoading: _isLoading,
                    onPressed: _submit,
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
