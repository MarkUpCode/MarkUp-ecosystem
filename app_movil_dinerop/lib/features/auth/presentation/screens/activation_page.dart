import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../auth_controller.dart';

class ActivationPage extends ConsumerStatefulWidget {
  const ActivationPage({super.key, required this.token});

  final String? token;

  @override
  ConsumerState<ActivationPage> createState() => _ActivationPageState();
}

class _ActivationPageState extends ConsumerState<ActivationPage> {
  bool _done = false;
  String? _message;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _activate());
  }

  Future<void> _activate() async {
    final token = widget.token;
    if (token == null || token.isEmpty) {
      setState(() => _error = 'Falta el token de activación.');
      return;
    }

    try {
      await ref.read(authControllerProvider).activate(token);
      if (!mounted) return;
      setState(() {
        _done = true;
        _message = 'Tu cuenta fue activada correctamente.';
      });
    } catch (error) {
      setState(() {
        _error = error is AppException ? error.message : AppErrorMessages.generic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activación')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_done ? Icons.verified_rounded : Icons.mark_email_unread_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(_done ? 'Cuenta activada' : 'Activando cuenta...', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(_done ? (_message ?? 'Tu cuenta fue activada correctamente.') : 'Estamos validando tu enlace de activación.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                if (_error != null) ...[
                  const SizedBox(height: 20),
                  AppErrorView(message: _error!),
                ],
                const SizedBox(height: 24),
                AppButton(label: 'Completar registro', icon: Icons.lock_reset_rounded, onPressed: () => context.go('/complete-registration')),
                TextButton(onPressed: () => context.go('/login'), child: const Text('Ir a iniciar sesión')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}