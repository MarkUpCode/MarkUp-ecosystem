import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/models/app_user.dart';
import '../auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  String? _localError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = ref.read(authControllerProvider);
    try {
      final response = await controller.login(_emailController.text.trim(), _passwordController.text);
      if (!mounted) return;
      if (response.user.status == AppUserStatus.pendingActivation) {
        context.go('/pending-activation');
      } else if (controller.requiresOnboarding) {
        context.go('/onboarding');
      } else {
        context.go('/dashboard');
      }
    } catch (error) {
      setState(() {
        _localError = error is AppException ? error.message : AppErrorMessages.generic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E3A8A), Color(0xFF3730A3), Color(0xFF0F172A)],
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.trending_up_rounded, color: Colors.white, size: 36),
                    SizedBox(height: 16),
                    Text('DINEROP', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                    SizedBox(height: 8),
                    Text('Tu app financiera para crédito, onboarding y seguimiento de solicitudes.', style: TextStyle(color: Colors.white70, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text('Iniciar sesión', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Accede con tus credenciales para continuar.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              AppCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _emailController,
                        label: 'Correo electrónico',
                        hint: 'tu@email.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (value) => value == null || value.trim().isEmpty ? 'Ingresa tu correo' : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Contraseña',
                        obscureText: !_showPassword,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        onSuffixTap: () => setState(() => _showPassword = !_showPassword),
                        validator: (value) => value == null || value.isEmpty ? 'Ingresa tu contraseña' : null,
                      ),
                      const SizedBox(height: 20),
                      if (_localError != null) ...[
                        AppErrorView(message: _localError!, onRetry: _submit),
                        const SizedBox(height: 20),
                      ],
                      AppButton(label: 'Entrar', icon: Icons.login_rounded, isLoading: controller.isBusy, onPressed: _submit),
                      const SizedBox(height: 12),
                      TextButton(onPressed: () => context.go('/forgot-password'), child: const Text('¿Olvidaste tu contraseña?')),
                      TextButton(onPressed: () => context.go('/register'), child: const Text('Crear cuenta nueva')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}