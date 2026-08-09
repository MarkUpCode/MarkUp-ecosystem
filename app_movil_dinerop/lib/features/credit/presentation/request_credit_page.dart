import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../data/models/credit_enums.dart';
import '../data/models/credit_request_payload.dart';

class RequestCreditPage extends ConsumerStatefulWidget {
  const RequestCreditPage({super.key});

  @override
  ConsumerState<RequestCreditPage> createState() => _RequestCreditPageState();
}

class _RequestCreditPageState extends ConsumerState<RequestCreditPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _plazoController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  CreditRequestType _type = CreditRequestType.credito;
  CreditType _creditType = CreditType.microcredito;
  String? _error;
  String? _success;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _plazoController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _success = null;
    });

    try {
      final payload = CreditRequestPayload(
        amount: double.parse(_amountController.text.replaceAll(',', '.')),
        type: _type,
        creditType: _type == CreditRequestType.inversion ? null : _creditType,
        plazoMeses: _plazoController.text.trim().isEmpty ? null : int.tryParse(_plazoController.text.trim()),
        province: _provinceController.text.trim(),
        city: _cityController.text.trim(),
      );
      final response = await ref.read(creditRepositoryProvider).createCreditRequest(payload);
      setState(() {
        _success = response.message.isNotEmpty ? response.message : 'Solicitud enviada correctamente.';
      });
      ref.invalidate(dashboardCreditRequestsProvider);
    } catch (error) {
      setState(() {
        _error = error is AppException ? error.message : AppErrorMessages.generic;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar crédito')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Completa la información mínima que el backend requiere.', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<CreditRequestType>(
                    initialValue: _type,
                    decoration: const InputDecoration(labelText: 'Tipo de solicitud'),
                    items: const [
                      DropdownMenuItem(value: CreditRequestType.credito, child: Text('Crédito')),
                      DropdownMenuItem(value: CreditRequestType.inversion, child: Text('Inversión')),
                    ],
                    onChanged: (value) => setState(() => _type = value ?? CreditRequestType.credito),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CreditType>(
                    initialValue: _creditType,
                    decoration: const InputDecoration(labelText: 'Tipo de crédito'),
                    items: const [
                      DropdownMenuItem(value: CreditType.microcredito, child: Text('Microcrédito')),
                      DropdownMenuItem(value: CreditType.consumo, child: Text('Consumo')),
                    ],
                    onChanged: _type == CreditRequestType.inversion
                        ? null
                        : (value) => setState(() => _creditType = value ?? CreditType.microcredito),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _amountController,
                    label: 'Monto',
                    prefixIcon: Icons.payments_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Ingresa un monto' : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _plazoController,
                    label: 'Plazo en meses (opcional)',
                    prefixIcon: Icons.schedule_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(controller: _provinceController, label: 'Provincia', prefixIcon: Icons.location_city_outlined),
                  const SizedBox(height: 16),
                  AppTextField(controller: _cityController, label: 'Ciudad', prefixIcon: Icons.place_outlined),
                  const SizedBox(height: 16),
                  if (_error != null) ...[
                    AppErrorView(message: _error!),
                    const SizedBox(height: 16),
                  ],
                  if (_success != null) ...[
                    AppBadge(label: _success!),
                    const SizedBox(height: 16),
                  ],
                  AppButton(label: 'Enviar solicitud', icon: Icons.send_rounded, isLoading: _isLoading, onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}