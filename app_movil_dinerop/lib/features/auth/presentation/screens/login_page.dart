import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/models/app_user.dart';
import '../auth_controller.dart';

/// ═══════════════════════════════════════════════════════════
/// LANDING / LOGIN PAGE
/// ═══════════════════════════════════════════════════════════
///
/// Jerarquía:
///   1º Solicitar mi crédito
///   2º Invertir con cooperativas
///   3º Iniciar sesión
///
/// Los dos servicios principales tienen el mismo peso visual.
/// La solicitud de crédito ya es funcional.
/// La inversión está presente visualmente, pero todavía no
/// ejecuta ninguna acción.
///
/// Cada servicio cuenta además con su propio simulador.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void _openLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _LoginSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─────────────────────────────────────────────
              // BRAND
              // ─────────────────────────────────────────────

              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.account_balance_rounded,
                      color: theme.colorScheme.primary,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Text(
                    'DINEROP',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 44),

              // ─────────────────────────────────────────────
              // SERVICIOS PRINCIPALES
              // ─────────────────────────────────────────────

              _CreditServiceCard(
                onPressed: () => context.go('/register'),
                onSimulationPressed: () =>
                    context.push('/simulate-credit'),
              ),

              const SizedBox(height: 16),

              _InvestmentServiceCard(
                onSimulationPressed: () =>
                    context.push('/simulate-investment'),
              ),

              const SizedBox(height: 48),

              // ─────────────────────────────────────────────
              // LOGIN SECUNDARIO
              // ─────────────────────────────────────────────

              _LoginLink(
                onTap: () => _openLoginSheet(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// CREDIT SERVICE CARD
// ═══════════════════════════════════════════════════════════

class _CreditServiceCard extends StatelessWidget {
  const _CreditServiceCard({
    required this.onPressed,
    required this.onSimulationPressed,
  });

  final VoidCallback onPressed;
  final VoidCallback onSimulationPressed;

  @override
  Widget build(BuildContext context) {
    return _ServiceCard(
      onPressed: onPressed,
      onSimulationPressed: onSimulationPressed,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0F3A7D),
          Color(0xFF16407F),
          Color(0xFF0B1220),
        ],
      ),
      iconBackground: Colors.white.withValues(alpha: 0.14),
      icon: Icons.credit_score_rounded,
      iconColor: Colors.white,
      title: 'Solicitar mi crédito',
      description:
      'Completa una sola solicitud y conecta con cooperativas aliadas.',
      buttonText: 'Solicitar',
      simulationText: 'Simulador',
      buttonBackground: Colors.white,
      buttonTextColor: const Color(0xFF0F172A),
      buttonIconColor: const Color(0xFF0F3A7D),
      shadowColor: const Color(0xFF0F3A7D),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// INVESTMENT SERVICE CARD
// ═══════════════════════════════════════════════════════════

class _InvestmentServiceCard extends StatelessWidget {
  const _InvestmentServiceCard({
    required this.onSimulationPressed,
  });

  final VoidCallback onSimulationPressed;

  @override
  Widget build(BuildContext context) {
    return _ServiceCard(
      // La inversión mantiene el mismo protagonismo visual
      // que el crédito, pero su acción principal todavía
      // no ejecuta ninguna funcionalidad.
      onPressed: null,
      onSimulationPressed: onSimulationPressed,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0B6B57),
          Color(0xFF087F68),
          Color(0xFF063D35),
        ],
      ),
      iconBackground: Colors.white.withValues(alpha: 0.14),
      icon: Icons.trending_up_rounded,
      iconColor: Colors.white,
      title: 'Invertir con cooperativas',
      description:
      'Encuentra oportunidades de inversión entre cooperativas aliadas.',
      buttonText: 'Invertir',
      simulationText: 'Simulador',
      buttonBackground: Colors.white,
      buttonTextColor: const Color(0xFF063D35),
      buttonIconColor: const Color(0xFF0B6B57),
      shadowColor: const Color(0xFF0B6B57),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// GENERIC SERVICE CARD
// ═══════════════════════════════════════════════════════════

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.onPressed,
    required this.onSimulationPressed,
    required this.gradient,
    required this.iconBackground,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.simulationText,
    required this.buttonBackground,
    required this.buttonTextColor,
    required this.buttonIconColor,
    required this.shadowColor,
  });

  final VoidCallback? onPressed;
  final VoidCallback onSimulationPressed;
  final Gradient gradient;
  final Color iconBackground;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String buttonText;
  final String simulationText;
  final Color buttonBackground;
  final Color buttonTextColor;
  final Color buttonIconColor;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─────────────────────────────────────────────
          // ICON
          // ─────────────────────────────────────────────

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBackground,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),

          const SizedBox(height: 13),

          // ─────────────────────────────────────────────
          // TITLE
          // ─────────────────────────────────────────────

          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.08,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 6),

          // ─────────────────────────────────────────────
          // DESCRIPTION
          // ─────────────────────────────────────────────

          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ─────────────────────────────────────────────
          // ACTIONS
          // ─────────────────────────────────────────────

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onPressed,
                      borderRadius: BorderRadius.circular(13),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: buttonBackground,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                buttonText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: buttonTextColor,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: buttonIconColor,
                              size: 17,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onSimulationPressed,
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.38),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calculate_outlined,
                              color: Colors.white,
                              size: 17,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              simulationText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// LOGIN LINK
// ═══════════════════════════════════════════════════════════

class _LoginLink extends StatelessWidget {
  const _LoginLink({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: TextButton(
        onPressed: onTap,
        child: RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            children: [
              const TextSpan(
                text: '¿Ya tienes una cuenta? ',
              ),
              TextSpan(
                text: 'Iniciar sesión',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// LOGIN — BOTTOM SHEET
// ═══════════════════════════════════════════════════════════

class _LoginSheet extends ConsumerStatefulWidget {
  const _LoginSheet();

  @override
  ConsumerState<_LoginSheet> createState() => _LoginSheetState();
}

class _LoginSheetState extends ConsumerState<_LoginSheet> {
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
      final response = await controller.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (response.user.status == AppUserStatus.pendingActivation) {
        Navigator.of(context).pop();

        context.go(
          '/pending-activation?email=${Uri.encodeComponent(
            _emailController.text.trim(),
          )}',
        );
      } else {
        Navigator.of(context).pop();
        context.go('/dashboard');
      }
    } catch (error) {
      if (error is AppException &&
          error.message.toLowerCase().contains('no activada')) {
        if (mounted) {
          Navigator.of(context).pop();

          context.go(
            '/pending-activation?email=${Uri.encodeComponent(
              _emailController.text.trim(),
            )}',
          );
        }

        return;
      }

      if (!mounted) return;

      setState(() {
        _localError = error is AppException
            ? error.message
            : AppErrorMessages.generic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),

                Text(
                  'Iniciar sesión',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Accede a tu cuenta para consultar tus solicitudes.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                // Email
                AppTextField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  hint: 'tu@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa tu correo';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Password
                AppTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  obscureText: !_showPassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: _showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                if (_localError != null) ...[
                  AppErrorView(
                    message: _localError!,
                    onRetry: _submit,
                  ),
                  const SizedBox(height: 18),
                ],

                // Login button
                AppButton(
                  label: 'Entrar a mi cuenta',
                  icon: Icons.login_rounded,
                  isLoading: controller.isBusy,
                  onPressed: _submit,
                ),

                const SizedBox(height: 8),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/forgot-password');
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}