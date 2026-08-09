import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../auth_controller.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _message;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final message = await ref.read(authControllerProvider).forgotPassword(_emailController.text.trim());
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
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Te enviaremos un enlace seguro al correo registrado.', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  AppTextField(controller: _emailController, label: 'Correo electrónico', keyboardType: TextInputType.emailAddress, prefixIcon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  if (_message != null) ...[
                    Text(_message!, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16),
                  ],
                  if (_error != null) ...[
                    AppErrorView(message: _error!),
                    const SizedBox(height: 16),
                  ],
                  AppButton(label: 'Enviar enlace', icon: Icons.send_rounded, isLoading: controller.isBusy, onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}