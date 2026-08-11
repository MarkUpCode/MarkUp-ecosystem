import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/locations/ecuador_locations.dart';
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

  final _email = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _identification = TextEditingController();
  final _phone = TextEditingController();

  final _amount = TextEditingController();
  final _term = TextEditingController(text: '12');

  int _step = 0;

  String _creditType = 'MICROCREDITO';

  bool _acceptedTerms = false;

  String? _localError;

  // ============================================================
  // UBICACIÓN
  // ============================================================

  String? _selectedProvince;
  String? _selectedCanton;
  String? _selectedParish;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _email.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _identification.dispose();
    _phone.dispose();
    _amount.dispose();
    _term.dispose();

    super.dispose();
  }

  // ============================================================
  // VALIDACIONES
  // ============================================================

  String? _required(String? value, String label) {
    return value == null || value.trim().isEmpty
        ? 'Ingresa $label.'
        : null;
  }

  String? _emailValidator(String? value) {
    final required = _required(value, 'tu correo');

    if (required != null) {
      return required;
    }

    return RegExp(r'^\S+@\S+\.\S+$').hasMatch(value!.trim())
        ? null
        : 'Ingresa un correo valido.';
  }

  String? _identificationValidator(String? value) {
    final id = value?.trim() ?? '';

    if (!RegExp(r'^\d{10}$').hasMatch(id)) {
      return 'La cedula debe tener 10 digitos.';
    }

    final digits = id.split('').map(int.parse).toList();

    final province = int.parse(id.substring(0, 2));

    if (province < 1 || province > 24) {
      return 'Cedula ecuatoriana invalida.';
    }

    final verifier = digits.removeLast();

    var sum = 0;

    for (var index = 0; index < digits.length; index++) {
      final doubled = index.isEven ? digits[index] * 2 : digits[index];

      sum += doubled > 9 ? doubled - 9 : doubled;
    }

    return (10 - sum % 10) % 10 == verifier
        ? null
        : 'Cedula ecuatoriana invalida.';
  }

  String? _phoneValidator(String? value) {
    return RegExp(r'^\d{10}$').hasMatch(value?.trim() ?? '')
        ? null
        : 'Ingresa 10 digitos.';
  }

  String? _amountValidator(String? value) {
    final amount = num.tryParse(value?.trim() ?? '');

    return amount != null && amount > 0
        ? null
        : 'Ingresa un monto valido.';
  }

  String? _termValidator(String? value) {
    final months = int.tryParse(value?.trim() ?? '');

    return months != null && months >= 1 && months <= 60
        ? null
        : 'El plazo debe ser entre 1 y 60 meses.';
  }

  // ============================================================
  // PROVINCIAS
  // ============================================================

  List<String> get _provinces {
    return ecuadorProvincias
        .map((province) => province.provincia)
        .toList();
  }

  // ============================================================
  // CANTONES SEGÚN PROVINCIA
  // ============================================================

  List<String> get _cantons {
    if (_selectedProvince == null) {
      return [];
    }

    final province = ecuadorProvincias.where(
          (item) => item.provincia == _selectedProvince,
    );

    if (province.isEmpty) {
      return [];
    }

    return province.first.cantones
        .map((canton) => canton.nombre)
        .toList();
  }

  // ============================================================
  // PARROQUIAS SEGÚN CANTÓN
  // ============================================================

  List<String> get _parishes {
    if (_selectedProvince == null || _selectedCanton == null) {
      return [];
    }

    final province = ecuadorProvincias.where(
          (item) => item.provincia == _selectedProvince,
    );

    if (province.isEmpty) {
      return [];
    }

    final canton = province.first.cantones.where(
          (item) => item.nombre == _selectedCanton,
    );

    if (canton.isEmpty) {
      return [];
    }

    return canton.first.parroquias;
  }

  // ============================================================
  // CAMBIO DE PROVINCIA
  // ============================================================

  void _onProvinceChanged(String? value) {
    setState(() {
      _selectedProvince = value;

      // Al cambiar provincia:
      // el cantón anterior deja de ser válido.
      _selectedCanton = null;

      // La parroquia anterior también deja de ser válida.
      _selectedParish = null;

      _localError = null;
    });
  }

  // ============================================================
  // CAMBIO DE CANTÓN
  // ============================================================

  void _onCantonChanged(String? value) {
    setState(() {
      _selectedCanton = value;

      // Al cambiar cantón:
      // la parroquia anterior deja de ser válida.
      _selectedParish = null;

      _localError = null;
    });
  }

  // ============================================================
  // CAMBIO DE PARROQUIA
  // ============================================================

  void _onParishChanged(String? value) {
    setState(() {
      _selectedParish = value;

      _localError = null;
    });
  }

  // ============================================================
  // SIGUIENTE PASO
  // ============================================================

  void _next() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _localError = null;
      _step++;
    });
  }

  // ============================================================
  // ENVIAR SOLICITUD
  // ============================================================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptedTerms) {
      setState(
            () => _localError =
        'Debes aceptar los terminos y el tratamiento de datos.',
      );

      return;
    }

    // ==========================================================
    // IMPORTANTE:
    //
    // El backend actual todavía recibe:
    // province
    // city
    //
    // La parroquia todavía NO forma parte del contrato backend.
    //
    // Por eso enviamos:
    // province = provincia seleccionada
    // city     = cantón seleccionado
    //
    // La parroquia se mantiene seleccionada en la interfaz y
    // aparecerá en la confirmación.
    // ==========================================================

    final request = PublicRegistrationRequest(
      email: _email.text.trim(),
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      identification: _identification.text.trim(),
      phone: _phone.text.trim(),
      province: _selectedProvince!,
      city: _selectedCanton!,
      amount: num.parse(_amount.text.trim()),
      plazoMeses: int.parse(_term.text.trim()),
      creditType: _creditType,
    );

    try {
      await ref.read(authControllerProvider).register(request);

      if (mounted) {
        context.go(
          '/pending-activation?email=${Uri.encodeComponent(
            request.email,
          )}',
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(
            () => _localError = error is AppException
            ? error.message
            : AppErrorMessages.generic,
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    final titles = [
      'Tus datos',
      'Ubicacion',
      'Credito',
      'Confirmacion',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar credito'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ========================================================
                // TITULO DEL PASO
                // ========================================================

                Text(
                  '${titles[_step]}  (${_step + 1} de ${titles.length})',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 8),

                // ========================================================
                // PROGRESO
                // ========================================================

                LinearProgressIndicator(
                  value: (_step + 1) / titles.length,
                ),

                const SizedBox(height: 24),

                // ========================================================
                // CONTENIDO DEL PASO
                // ========================================================

                AppCard(
                  child: _buildStep(),
                ),

                const SizedBox(height: 20),

                // ========================================================
                // ERROR
                // ========================================================

                if (_localError != null) ...[
                  AppErrorView(
                    message: _localError!,
                    onRetry: _step == 3 ? _submit : _next,
                  ),
                  const SizedBox(height: 16),
                ],

                // ========================================================
                // BOTONES
                // ========================================================

                Row(
                  children: [
                    if (_step > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: auth.isBusy
                              ? null
                              : () {
                            setState(() {
                              _step--;
                              _localError = null;
                            });
                          },
                          child: const Text('Atras'),
                        ),
                      ),

                    if (_step > 0)
                      const SizedBox(width: 12),

                    Expanded(
                      child: AppButton(
                        label: _step == 3
                            ? 'Enviar solicitud'
                            : 'Continuar',
                        icon: _step == 3
                            ? Icons.send_rounded
                            : Icons.arrow_forward_rounded,
                        isLoading: auth.isBusy,
                        onPressed: _step == 3
                            ? _submit
                            : _next,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PASOS DEL FORMULARIO
  // ============================================================

  Widget _buildStep() {
    switch (_step) {
    // ==========================================================
    // PASO 1 - DATOS PERSONALES
    // ==========================================================

      case 0:
        return Column(
          children: [
            AppTextField(
              controller: _firstName,
              label: 'Nombres',
              prefixIcon: Icons.person_outline,
              validator: (value) =>
                  _required(value, 'tus nombres'),
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: _lastName,
              label: 'Apellidos',
              prefixIcon: Icons.person_outline,
              validator: (value) =>
                  _required(value, 'tus apellidos'),
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: _identification,
              label: 'Cedula',
              prefixIcon: Icons.credit_card_outlined,
              keyboardType: TextInputType.number,
              validator: _identificationValidator,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: _phone,
              label: 'Telefono',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: _phoneValidator,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: _email,
              label: 'Correo electronico',
              hint: 'tu@email.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
          ],
        );

    // ==========================================================
    // PASO 2 - UBICACIÓN
    // ==========================================================

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usamos esta informacion para encontrar cooperativas en tu zona.',
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // PROVINCIA
            // ----------------------------------------------------

            DropdownButtonFormField<String>(
              initialValue: _selectedProvince,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Provincia',
                hintText: 'Selecciona una provincia',
                prefixIcon: Icon(Icons.map_outlined),
              ),
              items: _provinces.map((province) {
                return DropdownMenuItem<String>(
                  value: province,
                  child: Text(
                    province,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: _onProvinceChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecciona tu provincia.';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // ----------------------------------------------------
            // CANTÓN
            // ----------------------------------------------------

            DropdownButtonFormField<String>(
              initialValue: _selectedCanton,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Canton',
                hintText: _selectedProvince == null
                    ? 'Primero selecciona una provincia'
                    : 'Selecciona un canton',
                prefixIcon: const Icon(
                  Icons.location_city_outlined,
                ),
              ),
              items: _cantons.map((canton) {
                return DropdownMenuItem<String>(
                  value: canton,
                  child: Text(
                    canton,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: _selectedProvince == null
                  ? null
                  : _onCantonChanged,
              validator: (value) {
                if (_selectedProvince == null) {
                  return 'Selecciona primero una provincia.';
                }

                if (value == null || value.isEmpty) {
                  return 'Selecciona tu canton.';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // ----------------------------------------------------
            // PARROQUIA
            // ----------------------------------------------------

            DropdownButtonFormField<String>(
              initialValue: _selectedParish,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Parroquia',
                hintText: _selectedCanton == null
                    ? 'Primero selecciona un canton'
                    : 'Selecciona una parroquia',
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                ),
              ),
              items: _parishes.map((parish) {
                return DropdownMenuItem<String>(
                  value: parish,
                  child: Text(
                    parish,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: _selectedCanton == null
                  ? null
                  : _onParishChanged,
              validator: (value) {
                if (_selectedProvince == null) {
                  return 'Selecciona primero una provincia.';
                }

                if (_selectedCanton == null) {
                  return 'Selecciona primero un canton.';
                }

                if (value == null || value.isEmpty) {
                  return 'Selecciona tu parroquia.';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            // ----------------------------------------------------
            // AYUDA
            // ----------------------------------------------------

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    'Los cantones disponibles dependen de la provincia seleccionada y las parroquias dependen del canton.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                ),
              ],
            ),
          ],
        );

    // ==========================================================
    // PASO 3 - CRÉDITO
    // ==========================================================

      case 2:
        return Column(
          children: [
            AppTextField(
              controller: _amount,
              label: 'Monto solicitado (USD)',
              prefixIcon: Icons.attach_money_rounded,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _amountValidator,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller: _term,
              label: 'Plazo en meses',
              prefixIcon: Icons.calendar_month_outlined,
              keyboardType: TextInputType.number,
              validator: _termValidator,
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _creditType,
              decoration: const InputDecoration(
                labelText: 'Tipo de credito',
                prefixIcon: Icon(
                  Icons.account_balance_wallet_outlined,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'MICROCREDITO',
                  child: Text('Microcredito'),
                ),
                DropdownMenuItem(
                  value: 'CONSUMO',
                  child: Text('Consumo'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _creditType = value;
                });
              },
            ),
          ],
        );

    // ==========================================================
    // PASO 4 - CONFIRMACIÓN
    // ==========================================================

      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirma tu solicitud',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // DATOS PERSONALES
            // ----------------------------------------------------

            _SummaryItem(
              icon: Icons.person_outline,
              label: 'Solicitante',
              value:
              '${_firstName.text} ${_lastName.text}',
            ),

            const SizedBox(height: 12),

            _SummaryItem(
              icon: Icons.credit_card_outlined,
              label: 'Cedula',
              value: _identification.text,
            ),

            const SizedBox(height: 12),

            _SummaryItem(
              icon: Icons.phone_outlined,
              label: 'Telefono',
              value: _phone.text,
            ),

            const SizedBox(height: 12),

            _SummaryItem(
              icon: Icons.email_outlined,
              label: 'Correo',
              value: _email.text,
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // UBICACIÓN
            // ----------------------------------------------------

            Text(
              'Ubicacion',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            _SummaryItem(
              icon: Icons.map_outlined,
              label: 'Provincia',
              value: _selectedProvince ?? '-',
            ),

            const SizedBox(height: 8),

            _SummaryItem(
              icon: Icons.location_city_outlined,
              label: 'Canton',
              value: _selectedCanton ?? '-',
            ),

            const SizedBox(height: 8),

            _SummaryItem(
              icon: Icons.location_on_outlined,
              label: 'Parroquia',
              value: _selectedParish ?? '-',
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // CRÉDITO
            // ----------------------------------------------------

            Text(
              'Credito',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            _SummaryItem(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Tipo',
              value: _creditType == 'MICROCREDITO'
                  ? 'Microcredito'
                  : 'Consumo',
            ),

            const SizedBox(height: 8),

            _SummaryItem(
              icon: Icons.attach_money_rounded,
              label: 'Monto',
              value: 'USD ${_amount.text}',
            ),

            const SizedBox(height: 8),

            _SummaryItem(
              icon: Icons.calendar_month_outlined,
              label: 'Plazo',
              value: '${_term.text} meses',
            ),

            const SizedBox(height: 20),

            // ----------------------------------------------------
            // TÉRMINOS
            // ----------------------------------------------------

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _acceptedTerms,
              onChanged: (value) {
                setState(() {
                  _acceptedTerms = value ?? false;
                  _localError = null;
                });
              },
              title: const Text(
                'Acepto los terminos y condiciones y autorizo el tratamiento de mis datos personales.',
              ),
              controlAffinity:
              ListTileControlAffinity.leading,
            ),
          ],
        );
    }
  }
}

// ============================================================================
// RESUMEN
// ============================================================================

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}