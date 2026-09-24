import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../auth_controller.dart';

class RegistrationVerificationPage extends ConsumerStatefulWidget {
  const RegistrationVerificationPage({super.key, required this.email});

  final String? email;

  @override
  ConsumerState<RegistrationVerificationPage> createState() =>
      _RegistrationVerificationPageState();
}

class _RegistrationVerificationPageState
    extends ConsumerState<RegistrationVerificationPage> {
  final _codeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _verified = false;
  bool _showPassword = false;
  bool _editingEmail = false;
  int _resendSeconds = 45;
  Timer? _resendTimer;
  late String _currentEmail;
  String? _error;

  String get _email => _emailController.text.trim();

  @override
  void initState() {
    super.initState();
    _currentEmail = widget.email?.trim() ?? '';
    _emailController.text = _currentEmail;
    _startResendCountdown();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 45);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSeconds <= 1) {
        timer.cancel();
        setState(() => _resendSeconds = 0);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _codeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      setState(() => _error = 'Ingresa el código de 6 dígitos.');
      return;
    }

    try {
      await ref.read(authControllerProvider).verifyRegistrationCode(
            email: _email,
            code: code,
          );
      if (mounted) setState(() { _verified = true; _error = null; });
    } catch (error) {
      if (mounted) {
        setState(() => _error = error is AppException
            ? error.message
            : AppErrorMessages.generic);
      }
    }
  }

  Future<void> _resendCode() async {
    if (_resendSeconds > 0) return;

    try {
      await ref.read(authControllerProvider).resendRegistrationCode(_email);
      if (mounted) {
        setState(() { _error = null; _codeController.clear(); });
        _startResendCountdown();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enviamos un nuevo código a tu correo.')),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = error is AppException
            ? error.message
            : AppErrorMessages.generic);
      }
    }
  }

  Future<void> _changeEmail() async {
    final newEmail = _emailController.text.trim();
    if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(newEmail)) {
      setState(() => _error = 'Ingresa un correo electrónico válido.');
      return;
    }

    try {
      await ref.read(authControllerProvider).changeRegistrationEmail(
            currentEmail: _currentEmail,
            newEmail: newEmail,
          );
      if (mounted) {
        setState(() {
          _currentEmail = newEmail;
          _editingEmail = false;
          _error = null;
          _codeController.clear();
        });
        _startResendCountdown();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enviamos un nuevo código al correo actualizado.')),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = error is AppException
            ? error.message
            : AppErrorMessages.generic);
      }
    }
  }

  Future<void> _setPassword() async {
    final password = _passwordController.text;
    if (password.length < 8) {
      setState(() => _error = 'La contraseña debe tener al menos 8 caracteres.');
      return;
    }
    if (password != _confirmController.text) {
      setState(() => _error = 'Las contraseñas no coinciden.');
      return;
    }

    try {
      await ref.read(authControllerProvider).setRegistrationPassword(
            email: _email,
            password: password,
          );
      await ref.read(authControllerProvider).login(_email, password);
      if (mounted) context.go('/dashboard');
    } catch (error) {
      if (mounted) {
        setState(() => _error = error is AppException
            ? error.message
            : AppErrorMessages.generic);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _verified ? 'Define tu contraseña' : 'Verifica tu correo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (_editingEmail) ...[
                  AppTextField(
                    controller: _emailController,
                    label: 'Nuevo correo electrónico',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.isBusy
                              ? null
                              : () => setState(() {
                                    _emailController.text = _currentEmail;
                                    _editingEmail = false;
                                  }),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: 'Enviar código',
                          isLoading: controller.isBusy,
                          onPressed: _changeEmail,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Text('Código enviado a $_email'),
                  TextButton.icon(
                    onPressed: controller.isBusy
                        ? null
                        : () => setState(() => _editingEmail = true),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Cambiar correo'),
                  ),
                ],
                const SizedBox(height: 20),
                if (!_verified) ...[
                  AppTextField(
                    controller: _codeController,
                    label: 'Código de 6 dígitos',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.mark_email_read_outlined,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: 'Verificar correo',
                    icon: Icons.verified_outlined,
                    isLoading: controller.isBusy,
                    onPressed: _verifyCode,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: controller.isBusy || _resendSeconds > 0
                        ? null
                        : _resendCode,
                    child: Text(
                      _resendSeconds > 0
                          ? 'Reenviar código en ${_resendSeconds}s'
                          : 'Reenviar código',
                    ),
                  ),
                ] else ...[
                  AppTextField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    obscureText: !_showPassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onSuffixTap: () => setState(() => _showPassword = !_showPassword),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _confirmController,
                    label: 'Confirmar contraseña',
                    obscureText: true,
                    prefixIcon: Icons.lock_reset_outlined,
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Crear contraseña e ingresar',
                    icon: Icons.login_rounded,
                    isLoading: controller.isBusy,
                    onPressed: _setPassword,
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 20),
                  AppErrorView(message: _error!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
