import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/locations/ecuador_locations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../dolarito/providers/dolarito_provider.dart';
import '../../../dolarito/widgets/dolarito_widget.dart';
import '../../../investment/data/models/investment_models.dart';
import '../../../investment/providers/investment_providers.dart';

class InvestmentRegistrationPage extends ConsumerStatefulWidget {
  const InvestmentRegistrationPage({super.key});

  @override
  ConsumerState<InvestmentRegistrationPage> createState() =>
      _InvestmentRegistrationPageState();
}

class _InvestmentRegistrationPageState
    extends ConsumerState<InvestmentRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _identification = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _amount = TextEditingController();
  final _term = TextEditingController();
  int _step = 0;
  String? _province;
  String? _canton;
  String? _parish;
  String? _paymentOption;
  InvestmentOffer? _selectedOffer;
  List<String> _paymentOptions = [];
  bool _optionsLoaded = false;
  List<InvestmentOffer> _offers = [];
  bool _busy = false;
  bool _acceptedTerms = false;
  String? _error;

  static const _steps = [
    'Tus datos',
    'Ubicación',
    'Tu inversión',
    'Ofertas',
    'Confirmar',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(dolaritoProvider.notifier)
            .show(
              ref.read(dolaritoServiceProvider).investmentRegistration(),
              force: true,
            );
      }
    });
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _identification.dispose();
    _phone.dispose();
    _email.dispose();
    _amount.dispose();
    _term.dispose();
    super.dispose();
  }

  List<String> get _cantons => ecuadorProvincias
      .where((item) => item.provincia == _province)
      .expand((item) => item.cantones.map((canton) => canton.nombre))
      .toList();

  List<String> get _parishes => ecuadorProvincias
      .where((item) => item.provincia == _province)
      .expand((item) => item.cantones)
      .where((item) => item.nombre == _canton)
      .expand((item) => item.parroquias)
      .toList();

  double get _amountValue =>
      double.tryParse(_amount.text.trim().replaceAll(',', '.')) ?? 0;
  int get _termValue => int.tryParse(_term.text.trim()) ?? 0;
  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? 'Ingresa $label.' : null;

  Future<void> _next() async {
    if (_step <= 1 && !(_formKey.currentState?.validate() ?? false)) return;
    if (_step == 2 && !_optionsLoaded) {
      if (_amountValue <= 0 || _termValue < 1 || _termValue > 360) {
        _formKey.currentState?.validate();
        return;
      }
      setState(() {
        _busy = true;
        _error = null;
      });
      try {
        final availability = await ref
            .read(investmentRepositoryProvider)
            .getAvailability(amount: _amountValue, termMonths: _termValue);
        if (!mounted) return;
        setState(() {
          _paymentOptions = availability.interestPaymentOptions;
          _optionsLoaded = true;
          if (!_paymentOptions.contains(_paymentOption)) _paymentOption = null;
          if (_paymentOptions.isEmpty)
            _error =
                'No hay formas de recibir intereses disponibles para ese monto y plazo.';
        });
      } catch (error) {
        if (mounted) setState(() => _error = _message(error));
      } finally {
        if (mounted) setState(() => _busy = false);
      }
      return;
    }
    if (_step == 2 && !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _error = null);
    if (_step == 3) {
      if (_selectedOffer == null) {
        setState(() => _error = 'Selecciona una oferta para continuar.');
        return;
      }
    }
    if (_step == 4) {
      await _submit();
      return;
    }
    if (_step == 2 && _paymentOption == null) {
      setState(() => _error = 'Elige cómo prefieres recibir los intereses.');
      return;
    }
    if (_step == 2) {
      await _loadOffers();
      return;
    }
    setState(() => _step++);
  }

  Future<void> _loadOffers() async {
    if (_paymentOption == null) {
      setState(() => _error = 'Elige cómo prefieres recibir los intereses.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final offers = await ref
          .read(investmentRepositoryProvider)
          .compareOffers(
            amount: _amountValue,
            termMonths: _termValue,
            interestPaymentOption: _paymentOption,
          );
      if (!mounted) return;
      setState(() {
        _offers = offers;
        _selectedOffer = null;
        if (offers.isEmpty)
          _error =
              'No encontramos ofertas que coincidan. Prueba otro monto, plazo o forma de pago.';
        else
          _step++;
      });
    } catch (error) {
      if (mounted) setState(() => _error = _message(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _message(Object error) => error is AppException
      ? error.message
      : 'No se pudo completar este paso. Inténtalo nuevamente.';

  Future<void> _submit() async {
    if (!_acceptedTerms) {
      setState(
        () => _error =
            'Autoriza el envío de tus datos a la cooperativa elegida para continuar.',
      );
      return;
    }
    final offer = _selectedOffer;
    if (offer == null ||
        _province == null ||
        _canton == null ||
        _parish == null)
      return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final email = _email.text.trim().toLowerCase();
    try {
      await ref
          .read(investmentRepositoryProvider)
          .createPublicRequest(
            email: email,
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            identification: _identification.text.trim(),
            phone: _phone.text.trim(),
            province: _province!,
            canton: _canton!,
            parish: _parish!,
            offer: offer,
            amount: _amountValue,
            termMonths: _termValue,
            interestPaymentOption: _paymentOption!,
          );
      if (mounted)
        context.go(
          '/verify-registration?email=${Uri.encodeComponent(email)}&flow=investment',
        );
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _message(error));
      ref
          .read(dolaritoProvider.notifier)
          .show(
            ref.read(dolaritoServiceProvider).investmentConnectionError(),
            force: true,
          );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dolarito = ref.watch(dolaritoProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _busy
              ? null
              : () {
                  if (_step == 0)
                    context.pop();
                  else
                    setState(() {
                      _step--;
                      _error = null;
                    });
                },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Solicitar inversión'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (dolarito.visible) ...[
                DolaritoWidget(
                  mood: dolarito.mood,
                  message: dolarito.message,
                  compact: true,
                ),
                const SizedBox(height: 16),
              ],
              Text(
                _steps[_step],
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text('Paso ${_step + 1} de ${_steps.length}'),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: (_step + 1) / _steps.length),
              const SizedBox(height: 16),
              Text(
                _step == 3
                    ? 'Compara las opciones reales de las cooperativas y selecciona la que prefieras.'
                    : _step == 4
                    ? 'Revisa los datos de tu solicitud antes de enviarla.'
                    : 'Completa la información para comparar opciones de inversión.',
              ),
              const SizedBox(height: 18),
              AppCard(
                child: Form(
                  key: _formKey,
                  child: _step < 3
                      ? _buildFields()
                      : _step == 3
                      ? _buildOffers()
                      : _buildConfirmation(),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              ],
              const SizedBox(height: 16),
              AppButton(
                label: _step == 4
                    ? 'Enviar solicitud y verificar correo'
                    : _step == 2
                    ? (_optionsLoaded
                          ? 'Buscar ofertas'
                          : 'Consultar opciones de intereses')
                    : _step == 3
                    ? 'Revisar solicitud'
                    : 'Continuar',
                icon: _step == 4
                    ? Icons.mark_email_read_outlined
                    : Icons.arrow_forward_rounded,
                isLoading: _busy,
                onPressed: _busy ? null : _next,
              ),
              if (_step == 4) ...[
                const SizedBox(height: 8),
                Text(
                  'Después confirmarás tu correo con OTP, crearás tu contraseña e ingresarás a Dinerop.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFields() {
    if (_step == 0)
      return Column(
        children: [
          AppTextField(
            controller: _firstName,
            label: 'Nombres',
            validator: (v) => _required(v, 'tus nombres'),
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: _lastName,
            label: 'Apellidos',
            validator: (v) => _required(v, 'tus apellidos'),
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: _identification,
            label: 'Cédula',
            keyboardType: TextInputType.number,
            validator: (v) => RegExp(r'^\d{10}$').hasMatch((v ?? '').trim())
                ? null
                : 'Ingresa los 10 dígitos de tu cédula.',
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: _phone,
            label: 'Celular',
            keyboardType: TextInputType.phone,
            validator: (v) => _required(v, 'tu celular'),
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: _email,
            label: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                RegExp(r'^\S+@\S+\.\S+$').hasMatch((v ?? '').trim())
                ? null
                : 'Ingresa un correo válido.',
          ),
        ],
      );
    if (_step == 1)
      return Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: _province,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Provincia'),
            items: ecuadorProvincias
                .map(
                  (e) => DropdownMenuItem(
                    value: e.provincia,
                    child: Text(e.provincia),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() {
              _province = v;
              _canton = null;
              _parish = null;
            }),
            validator: (v) => v == null ? 'Selecciona tu provincia.' : null,
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _canton,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Cantón'),
            items: _cantons
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: _province == null
                ? null
                : (v) => setState(() {
                    _canton = v;
                    _parish = null;
                  }),
            validator: (v) => v == null ? 'Selecciona tu cantón.' : null,
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _parish,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Parroquia'),
            items: _parishes
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: _canton == null
                ? null
                : (v) => setState(() => _parish = v),
            validator: (v) => v == null ? 'Selecciona tu parroquia.' : null,
          ),
        ],
      );
    return Column(
      children: [
        TextFormField(
          controller: _amount,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: '¿Cuánto deseas invertir?',
            prefixText: r'$ ',
          ),
          onChanged: (_) => setState(() {
            _optionsLoaded = false;
            _paymentOptions = [];
            _paymentOption = null;
          }),
          validator: (v) =>
              _amountValue > 0 ? null : 'Ingresa un monto válido.',
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _term,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '¿Por cuánto tiempo? (meses)',
          ),
          onChanged: (_) => setState(() {
            _optionsLoaded = false;
            _paymentOptions = [];
            _paymentOption = null;
          }),
          validator: (v) => _termValue > 0 && _termValue <= 360
              ? null
              : 'Ingresa un plazo válido.',
        ),
        const SizedBox(height: 16),
        if (!_optionsLoaded)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'Consulta las opciones disponibles según el monto y el plazo ingresados.',
            ),
          )
        else
          DropdownButtonFormField<String>(
            initialValue: _paymentOption,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: '¿Cómo prefieres recibir los intereses?',
            ),
            items: _paymentOptions
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(_paymentLabel(value)),
                  ),
                )
                .toList(),
            onChanged: _paymentOptions.isEmpty
                ? null
                : (value) => setState(() => _paymentOption = value),
            validator: (value) =>
                value == null ? 'Selecciona una forma de pago.' : null,
          ),
      ],
    );
  }

  String _paymentLabel(String value) => switch (value) {
    'MONTHLY' => 'Mensualmente',
    'AT_MATURITY' => 'Al finalizar el plazo',
    'REINVEST' => 'Reinvertir los intereses',
    _ => value,
  };

  Widget _buildOffers() => Column(
    children: _offers.map((offer) {
      final selected =
          _selectedOffer?.productId == offer.productId &&
          _selectedOffer?.conditionId == offer.conditionId;
      return Card(
        color: selected ? Theme.of(context).colorScheme.primaryContainer : null,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() {
            _selectedOffer = offer;
            _error = null;
          }),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${offer.cooperativeName} · ${offer.productName}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${offer.annualRate.toStringAsFixed(2)}% anual  •  Interés estimado: \$${(offer.estimatedInterest ?? 0).toStringAsFixed(2)}\nTotal estimado: \$${(offer.estimatedTotal ?? _amountValue).toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );

  Widget _buildConfirmation() {
    final offer = _selectedOffer!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _summary(
          'Titular',
          '${_firstName.text.trim()} ${_lastName.text.trim()}',
        ),
        _summary('Correo', _email.text.trim()),
        _summary('Ubicación', '$_parish, $_canton, $_province'),
        _summary(
          'Monto y plazo',
          '\$${_amountValue.toStringAsFixed(2)} · $_termValue meses',
        ),
        _summary('Pago de intereses', _paymentLabel(_paymentOption!)),
        _summary(
          'Cooperativa y oferta',
          '${offer.cooperativeName} · ${offer.productName}',
        ),
        _summary('Tasa anual', '${offer.annualRate.toStringAsFixed(2)}%'),
        const Divider(height: 24),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _acceptedTerms,
          onChanged: (v) => setState(() {
            _acceptedTerms = v == true;
            _error = null;
          }),
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text(
            'Autorizo enviar mis datos a esta cooperativa para gestionar esta solicitud de inversión.',
          ),
        ),
      ],
    );
  }

  Widget _summary(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 125,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
