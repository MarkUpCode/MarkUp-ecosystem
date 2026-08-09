import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../auth_controller.dart';

class CompleteRegistrationPage extends ConsumerStatefulWidget {
  const CompleteRegistrationPage({super.key, required this.email});

  final String? email;

  @override
  ConsumerState<CompleteRegistrationPage> createState() => _CompleteRegistrationPageState();
}

class _CompleteRegistrationPageState extends ConsumerState<CompleteRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showPassword = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email ?? ref.read(authControllerProvider).lastEmail ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmController.text) {
      setState(() => _error = 'Las contraseñas no coinciden.');
      return;
    }

    try {
      await ref.read(authControllerProvider).completeRegistration(email: _emailController.text.trim(), password: _passwordController.text);
      if (!mounted) return;
      context.go('/login');
    } catch (error) {
      setState(() {
        _error = error is AppException ? error.message : AppErrorMessages.generic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Completar registro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Define tu contraseña para continuar.', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  AppTextField(controller: _emailController, label: 'Correo electrónico', enabled: false, prefixIcon: Icons.email_outlined),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    obscureText: !_showPassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    onSuffixTap: () => setState(() => _showPassword = !_showPassword),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(controller: _confirmController, label: 'Confirmar contraseña', obscureText: true, prefixIcon: Icons.lock_reset_outlined),
                  const SizedBox(height: 20),
                  if (_error != null) ...[
                    AppErrorView(message: _error!),
                    const SizedBox(height: 20),
                  ],
                  AppButton(label: 'Guardar contraseña', icon: Icons.check_circle_rounded, isLoading: controller.isBusy, onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}