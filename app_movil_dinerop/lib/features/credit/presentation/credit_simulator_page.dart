import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';

class CreditSimulatorPage extends StatefulWidget {
  const CreditSimulatorPage({super.key});

  @override
  State<CreditSimulatorPage> createState() => _CreditSimulatorPageState();
}

class _CreditSimulatorPageState extends State<CreditSimulatorPage> {
  final _amountController = TextEditingController(text: '5000');
  final _termController = TextEditingController(text: '12');

  double _amount = 5000;
  int _months = 12;

  final List<_CreditOffer> _offers = const [
    _CreditOffer(
      name: 'Alianza del Valle',
      rate: 0.15,
      color: Color(0xFF123E7A),
      icon: Icons.account_balance_rounded,
    ),
    _CreditOffer(
      name: 'Tulcán Ltda.',
      rate: 0.14,
      color: Color(0xFF176B87),
      icon: Icons.account_balance_rounded,
    ),
    _CreditOffer(
      name: 'Unión El Ejido',
      rate: 0.16,
      color: Color(0xFF315B91),
      icon: Icons.account_balance_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _amountController.addListener(_recalculate);
    _termController.addListener(_recalculate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    super.dispose();
  }

  void _recalculate() {
    final amount = double.tryParse(
      _amountController.text
          .replaceAll('\$', '')
          .replaceAll(',', '.')
          .trim(),
    ) ??
        0;

    final months =
        int.tryParse(_termController.text.trim()) ?? 12;

    setState(() {
      _amount = amount;
      _months = math.max(months, 1);
    });
  }

  double _monthlyPayment(double annualRate) {
    if (_amount <= 0) return 0;

    final monthlyRate = annualRate / 12;

    if (monthlyRate == 0) {
      return _amount / _months;
    }

    final factor = math.pow(
      1 + monthlyRate,
      _months,
    );

    return _amount *
        (monthlyRate * factor) /
        (factor - 1);
  }

  double _totalPayment(double annualRate) {
    return _monthlyPayment(annualRate) * _months;
  }

  double _totalInterest(double annualRate) {
    return _totalPayment(annualRate) - _amount;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simular crédito',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─────────────────────────────────────────────
              // HEADER
              // ─────────────────────────────────────────────

              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0F3A7D),
                      Color(0xFF123E7A),
                      Color(0xFF0B172B),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F3A7D)
                          .withValues(alpha: 0.20),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.calculate_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Encuentra una opción para ti',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Simula tu crédito y compara '
                                'diferentes alternativas en un solo lugar.',
                            style: TextStyle(
                              color: Colors.white
                                  .withValues(alpha: 0.80),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ─────────────────────────────────────────────
              // INPUTS
              // ─────────────────────────────────────────────

              Text(
                '¿Qué necesitas?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 12),

              AppCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    AppTextField(
                      controller: _amountController,
                      label: 'Monto que necesitas',
                      hint: 'Ej. 5000',
                      prefixIcon: Icons.payments_outlined,
                      keyboardType:
                      const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    const SizedBox(height: 14),

                    AppTextField(
                      controller: _termController,
                      label: 'Plazo',
                      hint: 'Ej. 12',
                      prefixIcon: Icons.calendar_month_outlined,
                      suffixIcon: null,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ingresa el plazo en meses.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                          theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ─────────────────────────────────────────────
              // TITLE
              // ─────────────────────────────────────────────

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Opciones para comparar',
                      style:
                      theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                      theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      '${_offers.length} opciones',
                      style:
                      theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                'Compara valores estimados antes de enviar tu solicitud.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────────────────────
              // COOPERATIVE OFFERS
              // ─────────────────────────────────────────────

              ..._offers.map(
                    (offer) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _CreditOfferCard(
                    offer: offer,
                    amount: _amount,
                    months: _months,
                    monthlyPayment:
                    _monthlyPayment(offer.rate),
                    totalPayment:
                    _totalPayment(offer.rate),
                    totalInterest:
                    _totalInterest(offer.rate),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // ─────────────────────────────────────────────
              // DISCLAIMER
              // ─────────────────────────────────────────────

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color:
                      theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Las tasas y cuotas mostradas son '
                            'referenciales. Las condiciones finales '
                            'dependerán de la evaluación y oferta '
                            'real de cada cooperativa.',
                        style:
                        theme.textTheme.bodySmall?.copyWith(
                          color: theme
                              .colorScheme
                              .onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
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
// CREDIT OFFER MODEL
// ═══════════════════════════════════════════════════════════

class _CreditOffer {
  const _CreditOffer({
    required this.name,
    required this.rate,
    required this.color,
    required this.icon,
  });

  final String name;
  final double rate;
  final Color color;
  final IconData icon;
}

// ═══════════════════════════════════════════════════════════
// CREDIT OFFER CARD
// ═══════════════════════════════════════════════════════════

class _CreditOfferCard extends StatelessWidget {
  const _CreditOfferCard({
    required this.offer,
    required this.amount,
    required this.months,
    required this.monthlyPayment,
    required this.totalPayment,
    required this.totalInterest,
  });

  final _CreditOffer offer;
  final double amount;
  final int months;
  final double monthlyPayment;
  final double totalPayment;
  final double totalInterest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: offer.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  offer.icon,
                  color: offer.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.name,
                      style:
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Cooperativa aliada',
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color: theme
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${(offer.rate * 100).toStringAsFixed(1)}%',
                  style:
                  theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer
                  .withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cuota mensual estimada',
                        style:
                        theme.textTheme.bodySmall?.copyWith(
                          color: theme
                              .colorScheme
                              .onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${monthlyPayment.toStringAsFixed(2)}',
                        style: theme
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 42,
                  color: theme.colorScheme.outlineVariant,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Plazo',
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color: theme
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$months meses',
                      style:
                      theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _CreditData(
                  label: 'Monto',
                  value:
                  '\$${amount.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _CreditData(
                  label: 'Intereses',
                  value:
                  '\$${totalInterest.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _CreditData(
                  label: 'Total',
                  value:
                  '\$${totalPayment.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreditData extends StatelessWidget {
  const _CreditData({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}