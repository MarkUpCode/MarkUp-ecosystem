import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/models/public_registration_request.dart';
import '../auth_controller.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _identification = TextEditingController();
  final _phone = TextEditingController();
  final _province = TextEditingController();
  final _canton = TextEditingController();
  final _amount = TextEditingController();
  final _term = TextEditingController(text: '12');
  int _step = 0;
  String _creditType = 'MICROCREDITO';
  bool _acceptedTerms = false;
  String? _localError;

  @override
  void dispose() {
    for (final controller in [
      _email,
      _firstName,
      _lastName,
      _identification,
      _phone,
      _province,
      _canton,
      _amount,
      _term,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? 'Ingresa $label.' : null;

  String? _emailValidator(String? value) {
    final required = _required(value, 'tu correo');
    if (required != null) return required;
    return RegExp(r'^\S+@\S+\.\S+$').hasMatch(value!.trim())
        ? null
        : 'Ingresa un correo valido.';
  }

  String? _identificationValidator(String? value) {
    final id = value?.trim() ?? '';
    if (!RegExp(r'^\d{10}$').hasMatch(id)) {
      return 'La cedula debe tener 10 digitos.';
    }
    final digits = id.split('').map(int.parse).toList();
    final province = int.parse(id.substring(0, 2));
    if (province < 1 || province > 24) return 'Cedula ecuatoriana invalida.';
    final verifier = digits.removeLast();
    var sum = 0;
    for (var index = 0; index < digits.length; index++) {
      final doubled = index.isEven ? digits[index] * 2 : digits[index];
      sum += doubled > 9 ? doubled - 9 : doubled;
    }
    return (10 - sum % 10) % 10 == verifier
        ? null
        : 'Cedula ecuatoriana invalida.';
  }

  String? _phoneValidator(String? value) =>
      RegExp(r'^\d{10}$').hasMatch(value?.trim() ?? '')
      ? null
      : 'Ingresa 10 digitos.';

  String? _amountValidator(String? value) {
    final amount = num.tryParse(value?.trim() ?? '');
    return amount != null && amount > 0 ? null : 'Ingresa un monto valido.';
  }

  String? _termValidator(String? value) {
    final months = int.tryParse(value?.trim() ?? '');
    return months != null && months >= 1 && months <= 60
        ? null
        : 'El plazo debe ser entre 1 y 60 meses.';
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _localError = null;
      _step++;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      setState(
        () => _localError =
            'Debes aceptar los terminos y el tratamiento de datos.',
      );
      return;
    }
    final request = PublicRegistrationRequest(
      email: _email.text.trim(),
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      identification: _identification.text.trim(),
      phone: _phone.text.trim(),
      province: _province.text.trim(),
      city: _canton.text.trim(),
      amount: num.parse(_amount.text.trim()),
      plazoMeses: int.parse(_term.text.trim()),
      creditType: _creditType,
    );
    try {
      await ref.read(authControllerProvider).register(request);
      if (mounted) {
        context.go(
          '/pending-activation?email=${Uri.encodeComponent(request.email)}',
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(
        () => _localError = error is AppException
            ? error.message
            : AppErrorMessages.generic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final titles = ['Tus datos', 'Ubicacion', 'Credito', 'Confirmacion'];
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar credito')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${titles[_step]}  (${_step + 1} de ${titles.length})',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: (_step + 1) / titles.length),
                const SizedBox(height: 24),
                AppCard(child: _buildStep()),
                const SizedBox(height: 20),
                if (_localError != null) ...[
                  AppErrorView(
                    message: _localError!,
                    onRetry: _step == 3 ? _submit : _next,
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    if (_step > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: auth.isBusy
                              ? null
                              : () => setState(() => _step--),
                          child: const Text('Atras'),
                        ),
                      ),
                    if (_step > 0) const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: _step == 3 ? 'Enviar solicitud' : 'Continuar',
                        icon: _step == 3
                            ? Icons.send_rounded
                            : Icons.arrow_forward_rounded,
                        isLoading: auth.isBusy,
                        onPressed: _step == 3 ? _submit : _next,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return Column(
          children: [
            AppTextField(
              controller: _firstName,
              label: 'Nombres',
              prefixIcon: Icons.person_outline,
              validator: (v) => _required(v, 'tus nombres'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _lastName,
              label: 'Apellidos',
              prefixIcon: Icons.person_outline,
              validator: (v) => _required(v, 'tus apellidos'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _identification,
              label: 'Cedula',
              prefixIcon: Icons.credit_card_outlined,
              keyboardType: TextInputType.number,
              validator: _identificationValidator,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _phone,
              label: 'Telefono',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: _phoneValidator,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _email,
              label: 'Correo electronico',
              hint: 'tu@email.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usamos esta informacion para encontrar cooperativas en tu zona.',
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _province,
              label: 'Provincia',
              prefixIcon: Icons.map_outlined,
              validator: (v) => _required(v, 'tu provincia'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _canton,
              label: 'Canton',
              prefixIcon: Icons.location_city_outlined,
              validator: (v) => _required(v, 'tu canton'),
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            AppTextField(
              controller: _amount,
              label: 'Monto solicitado (USD)',
              prefixIcon: Icons.attach_money_rounded,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _amountValidator,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _term,
              label: 'Plazo en meses',
              prefixIcon: Icons.calendar_month_outlined,
              keyboardType: TextInputType.number,
              validator: _termValidator,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _creditType,
              decoration: const InputDecoration(
                labelText: 'Tipo de credito',
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'MICROCREDITO',
                  child: Text('Microcredito'),
                ),
                DropdownMenuItem(value: 'CONSUMO', child: Text('Consumo')),
              ],
              onChanged: (value) => setState(() => _creditType = value!),
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirma tu solicitud',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              '${_firstName.text} ${_lastName.text}\n${_province.text}, ${_canton.text}\n${_creditType == 'MICROCREDITO' ? 'Microcredito' : 'Consumo'} - USD ${_amount.text} a ${_term.text} meses',
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _acceptedTerms,
              onChanged: (value) =>
                  setState(() => _acceptedTerms = value ?? false),
              title: const Text(
                'Acepto los terminos y condiciones y autorizo el tratamiento de mis datos personales.',
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        );
    }
  }
}
