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
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _identificationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _identificationController.dispose();
    _phoneController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = ref.read(authControllerProvider);
    final request = PublicRegistrationRequest(
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      identification: _identificationController.text.trim(),
      phone: _phoneController.text.trim(),
      province: _provinceController.text.trim(),
      city: _cityController.text.trim(),
    );

    try {
      await controller.register(request);
      if (!mounted) return;
      context.go('/pending-activation');
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
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(controller: _firstNameController, label: 'Nombres', prefixIcon: Icons.badge_outlined),
                  const SizedBox(height: 16),
                  AppTextField(controller: _lastNameController, label: 'Apellidos', prefixIcon: Icons.badge_outlined),
                  const SizedBox(height: 16),
                  AppTextField(controller: _identificationController, label: 'Cédula', prefixIcon: Icons.credit_card_outlined, keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  AppTextField(controller: _phoneController, label: 'Teléfono', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  AppTextField(controller: _provinceController, label: 'Provincia', prefixIcon: Icons.location_city_outlined),
                  const SizedBox(height: 16),
                  AppTextField(controller: _cityController, label: 'Ciudad', prefixIcon: Icons.place_outlined),
                  const SizedBox(height: 16),
                  AppTextField(controller: _emailController, label: 'Correo electrónico', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  if (_localError != null) ...[
                    AppErrorView(message: _localError!),
                    const SizedBox(height: 20),
                  ],
                  AppButton(label: 'Registrarme', icon: Icons.person_add_alt_1_rounded, isLoading: controller.isBusy, onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}