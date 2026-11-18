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

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  Timer? _resendTimer;
  String? _resetGrant;
  String? _error;
  int _step = 0;
  int _resendSeconds = 45;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 45);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      if (_resendSeconds <= 1) {
        timer.cancel();
        setState(() => _resendSeconds = 0);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String _friendlyError(Object error) =>
      error is AppException ? error.message : AppErrorMessages.generic;

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      setState(
        () =>
            _error = 'Ingresa el código de 6 dígitos que enviamos a tu correo.',
      );
      return;
    }
    setState(() => _error = null);
    try {
      final grant = await ref
          .read(authControllerProvider)
          .verifyPasswordResetCode(email: widget.email, code: code);
      if (!mounted) return;
      setState(() {
        _resetGrant = grant;
        _step = 1;
        _error = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = _friendlyError(error));
    }
  }

  Future<void> _resendCode() async {
    setState(() => _error = null);
    try {
      await ref.read(authControllerProvider).forgotPassword(widget.email);
      if (!mounted) return;
      _codeController.clear();
      _startResendCooldown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Si el correo existe, recibirás un nuevo código.'),
        ),
      );
    } catch (error) {
      if (mounted) setState(() => _error = _friendlyError(error));
    }
  }

  Future<void> _saveNewPassword() async {
    final password = _passwordController.text;
    if (password.length < 8) {
      setState(
        () => _error = 'La contraseña debe tener al menos 8 caracteres.',
      );
      return;
    }
    if (password != _confirmController.text) {
      setState(() => _error = 'Las contraseñas no coinciden.');
      return;
    }
    final grant = _resetGrant;
    if (grant == null) {
      setState(() => _error = 'Valida primero el código enviado a tu correo.');
      return;
    }
    setState(() => _error = null);
    try {
      await ref
          .read(authControllerProvider)
          .resetPassword(token: grant, newPassword: password);
      if (mounted) {
        setState(() {
          _step = 2;
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = _friendlyError(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _step == 2
              ? null
              : _step == 1
              ? () => setState(() {
                  _step = 0;
                  _error = null;
                })
              : () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          _step == 0
              ? 'Verificar correo'
              : _step == 1
              ? 'Nueva contraseña'
              : 'Listo',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: AppCard(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: _step == 0
                      ? _buildCodeStep(controller, theme)
                      : _step == 1
                      ? _buildPasswordStep(controller, theme)
                      : _buildSuccessStep(theme),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeStep(AuthController controller, ThemeData theme) => Column(
    key: const ValueKey('password-reset-code'),
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Icon(
        Icons.mark_email_read_outlined,
        size: 42,
        color: theme.colorScheme.primary,
      ),
      const SizedBox(height: 12),
      Text(
        'Ingresa el código de recuperación',
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Si el correo está registrado, enviamos un código a ${widget.email}. Tiene una vigencia de 10 minutos.',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      AppTextField(
        controller: _codeController,
        label: 'Código de 6 dígitos',
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        prefixIcon: Icons.password_rounded,
        validator: (value) => RegExp(r'^\d{6}$').hasMatch((value ?? '').trim())
            ? null
            : 'Ingresa el código de 6 dígitos.',
      ),
      if (_error != null) ...[
        const SizedBox(height: 14),
        AppErrorView(message: _error!),
      ],
      const SizedBox(height: 18),
      AppButton(
        label: 'Validar código',
        icon: Icons.verified_outlined,
        isLoading: controller.isBusy,
        onPressed: _verifyCode,
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: controller.isBusy || _resendSeconds > 0 ? null : _resendCode,
        child: Text(
          _resendSeconds > 0
              ? 'Reenviar código en ${_resendSeconds}s'
              : 'Reenviar código',
        ),
      ),
    ],
  );

  Widget _buildPasswordStep(
    AuthController controller,
    ThemeData theme,
  ) => Column(
    key: const ValueKey('password-reset-new-password'),
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Icon(
        Icons.lock_reset_rounded,
        size: 42,
        color: theme.colorScheme.primary,
      ),
      const SizedBox(height: 12),
      Text(
        'Crea una nueva contraseña',
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Usa al menos 8 caracteres. Tu código ya fue validado y no podrá volver a utilizarse.',
      ),
      const SizedBox(height: 20),
      AppTextField(
        controller: _passwordController,
        label: 'Nueva contraseña',
        keyboardType: TextInputType.visiblePassword,
        obscureText: !_showPassword,
        prefixIcon: Icons.lock_outline,
        suffixIcon: _showPassword
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        onSuffixTap: () => setState(() => _showPassword = !_showPassword),
      ),
      const SizedBox(height: 14),
      AppTextField(
        controller: _confirmController,
        label: 'Confirmar contraseña',
        keyboardType: TextInputType.visiblePassword,
        obscureText: !_showConfirmPassword,
        prefixIcon: Icons.lock_reset_outlined,
        suffixIcon: _showConfirmPassword
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        onSuffixTap: () =>
            setState(() => _showConfirmPassword = !_showConfirmPassword),
      ),
      if (_error != null) ...[
        const SizedBox(height: 14),
        AppErrorView(message: _error!),
      ],
      const SizedBox(height: 20),
      AppButton(
        label: 'Guardar nueva contraseña',
        icon: Icons.save_rounded,
        isLoading: controller.isBusy,
        onPressed: _saveNewPassword,
      ),
    ],
  );

  Widget _buildSuccessStep(ThemeData theme) => Column(
    key: const ValueKey('password-reset-success'),
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Icon(
        Icons.check_circle_rounded,
        size: 58,
        color: theme.colorScheme.primary,
      ),
      const SizedBox(height: 16),
      Text(
        '¡Contraseña restablecida! Ya puedes iniciar sesión',
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 22),
      AppButton(
        label: 'Ir al inicio de sesión',
        icon: Icons.login_rounded,
        onPressed: () => context.go('/login'),
      ),
    ],
  );
}
