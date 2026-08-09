import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../auth_controller.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key, required this.token});

  final String? token;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _message;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tokenController.text = widget.token ?? '';
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final message = await ref.read(authControllerProvider).resetPassword(token: _tokenController.text.trim(), newPassword: _passwordController.text);
      setState(() {
        _message = message;
        _error = null;
      });
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
      appBar: AppBar(title: const Text('Nueva contraseña')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(controller: _tokenController, label: 'Token', prefixIcon: Icons.vpn_key_outlined),
                  const SizedBox(height: 16),
                  AppTextField(controller: _passwordController, label: 'Nueva contraseña', obscureText: true, prefixIcon: Icons.lock_outline),
                  const SizedBox(height: 20),
                  if (_message != null) ...[
                    Text(_message!, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16),
                  ],
                  if (_error != null) ...[
                    AppErrorView(message: _error!),
                    const SizedBox(height: 16),
                  ],
                  AppButton(label: 'Actualizar contraseña', icon: Icons.save_rounded, isLoading: controller.isBusy, onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}