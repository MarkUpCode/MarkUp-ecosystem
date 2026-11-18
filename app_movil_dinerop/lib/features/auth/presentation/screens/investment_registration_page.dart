import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../dolarito/providers/dolarito_provider.dart';
import '../../../dolarito/widgets/dolarito_widget.dart';
import '../auth_controller.dart';

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
  String? _error;

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
    super.dispose();
  }

  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? 'Ingresa $label.' : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _email.text.trim().toLowerCase();
    try {
      await ref
          .read(authControllerProvider)
          .startRegistration(
            email: email,
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            identification: _identification.text.trim(),
            phone: _phone.text.trim(),
          );
      if (!mounted) return;
      context.go('/verify-registration?email=${Uri.encodeComponent(email)}');
    } catch (error) {
      if (!mounted) return;
      setState(
        () => _error = error is AppException
            ? error.message
            : 'No se pudo iniciar el registro. Inténtalo nuevamente.',
      );
      ref
          .read(dolaritoProvider.notifier)
          .show(
            ref.read(dolaritoServiceProvider).investmentConnectionError(),
            force: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final dolarito = ref.watch(dolaritoProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta para invertir')),
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
                'Tus datos para continuar',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Usaremos el mismo registro seguro por correo. No enviaremos una solicitud de crédito.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              AppCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _firstName,
                        label: 'Nombres',
                        validator: (value) => _required(value, 'tus nombres'),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _lastName,
                        label: 'Apellidos',
                        validator: (value) => _required(value, 'tus apellidos'),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _identification,
                        label: 'Cédula',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final required = _required(value, 'tu cédula');
                          if (required != null) return required;
                          return RegExp(r'^\d{10}$').hasMatch(value!.trim())
                              ? null
                              : 'Ingresa los 10 dígitos de tu cédula.';
                        },
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _phone,
                        label: 'Celular (opcional)',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _email,
                        label: 'Correo electrónico',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final required = _required(value, 'tu correo');
                          if (required != null) return required;
                          return RegExp(
                                r'^\S+@\S+\.\S+$',
                              ).hasMatch(value!.trim())
                              ? null
                              : 'Ingresa un correo válido.';
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              AppButton(
                label: 'Continuar con mi inversión',
                icon: Icons.arrow_forward_rounded,
                isLoading: auth.isBusy,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
