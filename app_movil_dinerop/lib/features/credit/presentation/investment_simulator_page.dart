import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';

class InvestmentSimulatorPage extends StatefulWidget {
  const InvestmentSimulatorPage({super.key});

  @override
  State<InvestmentSimulatorPage> createState() =>
      _InvestmentSimulatorPageState();
}

class _InvestmentSimulatorPageState
    extends State<InvestmentSimulatorPage> {
  final _amountController = TextEditingController(text: '5000');
  final _termController = TextEditingController(text: '12');

  double _amount = 5000;
  int _months = 12;

  final List<_InvestmentOffer> _offers = const [
    _InvestmentOffer(
      name: 'Alianza del Valle',
      rate: 0.08,
      color: Color(0xFF07865D),
    ),
    _InvestmentOffer(
      name: 'Tulcán Ltda.',
      rate: 0.075,
      color: Color(0xFF087F8C),
    ),
    _InvestmentOffer(
      name: 'Unión El Ejido',
      rate: 0.085,
      color: Color(0xFF16826D),
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

  double _finalValue(double annualRate) {
    if (_amount <= 0) return 0;

    final monthlyRate = annualRate / 12;

    return _amount *
        math.pow(
          1 + monthlyRate,
          _months,
        );
  }

  double _profit(double annualRate) {
    return _finalValue(annualRate) - _amount;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simular inversión',
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
                      Color(0xFF087A53),
                      Color(0xFF0A9368),
                      Color(0xFF063B2C),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF07865D)
                          .withValues(alpha: 0.20),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                        Colors.white.withValues(alpha: 0.13),
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Haz crecer tu dinero',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'Simula cuánto podría crecer tu '
                                'inversión con diferentes alternativas.',
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
                'Configura tu inversión',
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
                      label: '¿Cuánto quieres invertir?',
                      hint: 'Ej. 5000',
                      prefixIcon:
                      Icons.account_balance_wallet_outlined,
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
                      prefixIcon:
                      Icons.calendar_month_outlined,
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
              // OFFERS TITLE
              // ─────────────────────────────────────────────

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Compara alternativas',
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
                      color: const Color(0xFFE9F7F1),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      '${_offers.length} opciones',
                      style:
                      theme.textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF087A53),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                'Visualiza una estimación del rendimiento '
                    'según el plazo que elijas.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────────────────────
              // INVESTMENT OFFERS
              // ─────────────────────────────────────────────

              ..._offers.map(
                    (offer) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _InvestmentOfferCard(
                    offer: offer,
                    amount: _amount,
                    months: _months,
                    finalValue:
                    _finalValue(offer.rate),
                    profit:
                    _profit(offer.rate),
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
                        'Los rendimientos mostrados son '
                            'referenciales. Las condiciones reales '
                            'dependerán del producto y oferta vigente '
                            'de cada cooperativa.',
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
// INVESTMENT OFFER MODEL
// ═══════════════════════════════════════════════════════════

class _InvestmentOffer {
  const _InvestmentOffer({
    required this.name,
    required this.rate,
    required this.color,
  });

  final String name;
  final double rate;
  final Color color;
}

// ═══════════════════════════════════════════════════════════
// INVESTMENT OFFER CARD
// ═══════════════════════════════════════════════════════════

class _InvestmentOfferCard extends StatelessWidget {
  const _InvestmentOfferCard({
    required this.offer,
    required this.amount,
    required this.months,
    required this.finalValue,
    required this.profit,
  });

  final _InvestmentOffer offer;
  final double amount;
  final int months;
  final double finalValue;
  final double profit;

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
                  color:
                  offer.color.withValues(alpha: 0.10),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.account_balance_rounded,
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
                  color: const Color(0xFFE9F7F1),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${(offer.rate * 100).toStringAsFixed(1)}%',
                  style:
                  theme.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF087A53),
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
              color: const Color(0xFFE9F7F1)
                  .withValues(alpha: 0.65),
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
                        'Valor estimado al final',
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
                        '\$${finalValue.toStringAsFixed(2)}',
                        style: theme
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                          color: const Color(0xFF087A53),
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
                child: _InvestmentData(
                  label: 'Invertido',
                  value:
                  '\$${amount.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _InvestmentData(
                  label: 'Rendimiento',
                  value:
                  '\$${profit.toStringAsFixed(2)}',
                ),
              ),
              Expanded(
                child: _InvestmentData(
                  label: 'Tasa',
                  value:
                  '${(offer.rate * 100).toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InvestmentData extends StatelessWidget {
  const _InvestmentData({
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