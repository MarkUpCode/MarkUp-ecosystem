import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../dolarito/providers/dolarito_provider.dart';
import '../../dolarito/widgets/dolarito_widget.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../data/models/public_credit_offer.dart';
import '../data/credit_simulation_draft_store.dart';

class CreditSimulatorPage extends ConsumerStatefulWidget {
  const CreditSimulatorPage({super.key});

  @override
  ConsumerState<CreditSimulatorPage> createState() =>
      _CreditSimulatorPageState();
}

class _CreditSimulatorPageState extends ConsumerState<CreditSimulatorPage> {
  final _amountController = TextEditingController();
  final _termController = TextEditingController(text: '12');
  String _creditCategory = 'CONSUMO';
  List<PublicCreditOffer> _offers = const [];
  String? _error;
  bool _loading = false;
  String? _draftNotice;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreDraft());
  }

  Future<void> _restoreDraft() async {
    final draft = await ref.read(creditSimulationDraftStoreProvider).read();
    if (!mounted || draft == null) return;
    _amountController.text = draft.amount.toStringAsFixed(2);
    _termController.text = draft.termMonths.toString();
    _creditCategory = draft.creditCategory;
    setState(
      () => _draftNotice =
          'Recuperamos tu simulación. Estamos consultando otra vez las ofertas vigentes.',
    );
    await _compare();
    if (mounted) {
      setState(
        () => _draftNotice =
            'Revisa las alternativas actuales antes de iniciar tu solicitud.',
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    super.dispose();
  }

  Future<void> _compare() async {
    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    final months = int.tryParse(_termController.text.trim());
    if (amount == null ||
        amount <= 0 ||
        months == null ||
        months < 1 ||
        months > 60) {
      setState(
        () => _error = 'Ingresa un monto válido y un plazo entre 1 y 60 meses.',
      );
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _offers = const [];
    });
    ref
        .read(dolaritoProvider.notifier)
        .show(
          ref.read(dolaritoServiceProvider).creditSimulationThinking(),
          force: true,
        );
    try {
      final offers = await ref
          .read(creditRepositoryProvider)
          .loadPublicOffers(
            creditCategory: _creditCategory,
            amount: amount,
            termMonths: months,
          );
      if (!mounted) return;
      setState(
        () =>
            _offers = offers
              ..sort((a, b) => a.annualRate.compareTo(b.annualRate)),
      );
      ref
          .read(dolaritoProvider.notifier)
          .show(
            offers.isEmpty
                ? ref.read(dolaritoServiceProvider).creditSimulationNoOffers()
                : ref
                      .read(dolaritoServiceProvider)
                      .creditSimulationOffers(offers.length),
            force: true,
          );
      if (offers.isEmpty) {
        setState(
          () => _error =
              'No encontramos productos vigentes compatibles con ese monto y plazo.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'No se pudieron consultar las ofertas actuales. Revisa tu conexión e inténtalo de nuevo.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _continueWithOffer(PublicCreditOffer offer) async {
    ref
        .read(dolaritoProvider.notifier)
        .show(
          ref.read(dolaritoServiceProvider).creditApplicationMotivation(),
          force: true,
        );
    final auth = ref.read(authControllerProvider);
    if (!auth.isAuthenticated) {
      await ref
          .read(creditSimulationDraftStoreProvider)
          .save(
            CreditSimulationDraft(
              amount: offer.amount,
              termMonths: offer.termMonths,
              creditCategory: offer.creditCategory,
              savedAt: DateTime.now().toUtc(),
            ),
          );
      if (mounted) context.push('/login');
      return;
    }
    if (mounted) {
      context.push(
        '/request-credit',
        extra: {
          'amount': offer.amount,
          'termMonths': offer.termMonths,
          'creditCategory': offer.creditCategory,
        },
      );
    }
    await ref.read(creditSimulationDraftStoreProvider).clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simular crédito',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
          children: [
            const DolaritoStateWidget(compact: true),
            const SizedBox(height: 12),
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Compara cooperativas',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Consulta productos publicados sin compartir tus datos. La comparación no representa una aprobación.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    initialValue: _creditCategory,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de crédito',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'CONSUMO',
                        child: Text('Consumo'),
                      ),
                      DropdownMenuItem(
                        value: 'MICROCREDITO',
                        child: Text('Microcrédito'),
                      ),
                    ],
                    onChanged: (value) => setState(() {
                      _creditCategory = value ?? 'CONSUMO';
                      _offers = const [];
                    }),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _amountController,
                    label: 'Monto que necesitas (USD)',
                    hint: 'Ej. 5000',
                    prefixIcon: Icons.payments_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _termController,
                    label: 'Plazo en meses',
                    hint: 'Ej. 12',
                    prefixIcon: Icons.calendar_month_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _loading ? null : _compare,
                    icon: _loading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    label: Text(
                      _loading ? 'Consultando…' : 'Comparar opciones',
                    ),
                  ),
                ],
              ),
            ),
            if (_draftNotice != null) ...[
              const SizedBox(height: 12),
              AppCard(
                child: Text(_draftNotice!, style: theme.textTheme.bodySmall),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              AppCard(
                child: Text(
                  _error!,
                  style: TextStyle(
                    color: _offers.isEmpty
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.error,
                  ),
                ),
              ),
            ],
            if (_offers.isNotEmpty) ...[
              const SizedBox(height: 22),
              Text(
                '${_offers.length} opciones compatibles',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              for (final offer in _offers) ...[
                _CreditOfferCard(
                  offer: offer,
                  onApply: () => _continueWithOffer(offer),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                'La cooperativa evaluará y confirmará las condiciones. No mostramos cuotas estimadas porque el simulador no cuenta con cargos y parámetros completos para calcularlas con precisión.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CreditOfferCard extends StatelessWidget {
  const _CreditOfferCard({required this.offer, required this.onApply});
  final PublicCreditOffer offer;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_rounded,
                color: Color(0xFF176B87),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.cooperativeName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(offer.productName, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Text(
                '${offer.annualRate.toStringAsFixed(2)}% anual',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${offer.creditCategory == 'CONSUMO' ? 'Consumo' : 'Microcrédito'} · USD ${offer.amount.toStringAsFixed(2)} · ${offer.termMonths} meses',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (offer.description?.isNotEmpty == true) ...[
            const SizedBox(height: 5),
            Text(offer.description!, style: theme.textTheme.bodySmall),
          ],
          const SizedBox(height: 8),
          Text(
            offer.conditions,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onApply,
            child: const Text('Continuar con la solicitud'),
          ),
        ],
      ),
    );
  }
}
