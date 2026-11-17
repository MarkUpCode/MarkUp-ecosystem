import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/errors/app_exception.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../dolarito/providers/dolarito_provider.dart';
import '../../dolarito/widgets/dolarito_widget.dart';
import '../../../shared/widgets/app_card.dart';
import '../../investment/data/models/investment_models.dart';
import '../../investment/providers/investment_providers.dart';

const _green = Color(0xFF087A53);
const _navy = Color(0xFF173B57);
const _muted = Color(0xFF64748B);

class InvestmentSimulatorPage extends ConsumerStatefulWidget {
  const InvestmentSimulatorPage({super.key});

  @override
  ConsumerState<InvestmentSimulatorPage> createState() =>
      _InvestmentSimulatorPageState();
}

class _InvestmentSimulatorPageState
    extends ConsumerState<InvestmentSimulatorPage> {
  final _amountController = TextEditingController();
  int? _selectedTerm;
  String? _interestPaymentOption;
  bool _showRequests = false;
  bool _isLoadingAvailability = false;
  bool _isComparing = false;
  int? _sendingOfferId;
  String? _error;
  List<int> _availableTermMonths = const [];
  List<String> _availablePaymentOptions = const [];
  List<InvestmentOffer> _offers = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(dolaritoProvider.notifier)
            .show(
              ref.read(dolaritoServiceProvider).investmentWelcome(),
              force: true,
            );
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount =>
      double.tryParse(_amountController.text.trim().replaceAll(',', '.')) ?? 0;

  Future<void> _loadAvailability({int? termMonths}) async {
    if (_amount <= 0) {
      setState(
        () => _error = 'Ingresa un monto válido para consultar opciones.',
      );
      return;
    }
    setState(() {
      _isLoadingAvailability = true;
      _error = null;
    });
    try {
      final availability = await ref
          .read(investmentRepositoryProvider)
          .getAvailability(amount: _amount, termMonths: termMonths);
      if (!mounted) return;
      setState(() {
        if (termMonths == null) {
          _availableTermMonths = availability.termMonths;
        } else {
          _availablePaymentOptions = availability.interestPaymentOptions;
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _messageFor(error));
      ref
          .read(dolaritoProvider.notifier)
          .show(
            ref.read(dolaritoServiceProvider).investmentConnectionError(),
            force: true,
          );
    } finally {
      if (mounted) setState(() => _isLoadingAvailability = false);
    }
  }

  Future<void> _compare() async {
    if (_amount <= 0 ||
        _selectedTerm == null ||
        !_availableTermMonths.contains(_selectedTerm)) {
      setState(
        () =>
            _error = 'Ingresa un monto y elige uno de los plazos disponibles.',
      );
      return;
    }

    setState(() {
      _isComparing = true;
      _error = null;
      _offers = const [];
    });
    ref
        .read(dolaritoProvider.notifier)
        .show(
          ref.read(dolaritoServiceProvider).investmentThinking(),
          force: true,
        );
    try {
      final offers = await ref
          .read(investmentRepositoryProvider)
          .compareOffers(
            amount: _amount,
            termMonths: _selectedTerm!,
            interestPaymentOption: _interestPaymentOption,
          );
      if (!mounted) return;
      setState(() => _offers = offers);
      ref
          .read(dolaritoProvider.notifier)
          .show(
            offers.isEmpty
                ? ref.read(dolaritoServiceProvider).investmentNoOffers()
                : ref
                      .read(dolaritoServiceProvider)
                      .investmentOffersFound(offers.length),
            force: true,
          );
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _messageFor(error));
      ref
          .read(dolaritoProvider.notifier)
          .show(
            ref.read(dolaritoServiceProvider).investmentConnectionError(),
            force: true,
          );
    } finally {
      if (mounted) setState(() => _isComparing = false);
    }
  }

  Future<void> _selectOffer(InvestmentOffer offer) async {
    final auth = ref.read(authControllerProvider);
    if (!auth.isAuthenticated) {
      final goToLogin = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inicia sesión para continuar'),
          content: const Text(
            'Puedes comparar las tasas sin iniciar sesión. Para enviar una solicitud a una cooperativa necesitas acceder a tu cuenta.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Seguir comparando'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      );
      if (goToLogin == true && mounted) context.push('/login');
      return;
    }

    ref
        .read(dolaritoProvider.notifier)
        .show(
          ref.read(dolaritoServiceProvider).investmentOfferSelected(),
          force: true,
        );
    var consent = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Revisa tu solicitud'),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${offer.cooperativeName} · ${offer.productName}'),
                  const SizedBox(height: 12),
                  _ConfirmationRow('Monto', _money(_amount)),
                  _ConfirmationRow('Plazo', '$_selectedTerm meses'),
                  _ConfirmationRow(
                    'Tasa anual',
                    '${offer.annualRate.toStringAsFixed(2)}%',
                  ),
                  if (offer.estimatedInterest != null)
                    _ConfirmationRow(
                      'Interés estimado',
                      _money(offer.estimatedInterest!),
                    ),
                  if (offer.estimatedTotal != null)
                    _ConfirmationRow(
                      'Total estimado',
                      _money(offer.estimatedTotal!),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    'Esta acción envía una solicitud de contacto. La cooperativa debe confirmar la disponibilidad y formalizar la operación. DINEROP no recibe ni custodia fondos.',
                    style: TextStyle(color: _muted, fontSize: 12, height: 1.45),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: consent,
                    onChanged: (value) =>
                        setDialogState(() => consent = value == true),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'Autorizo compartir mis datos de contacto únicamente con ${offer.cooperativeName} para atender esta solicitud.',
                      style: const TextStyle(fontSize: 13, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Volver'),
            ),
            FilledButton(
              onPressed: consent
                  ? () => Navigator.pop(dialogContext, true)
                  : null,
              child: const Text('Enviar solicitud'),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _sendingOfferId = offer.conditionId;
      _error = null;
    });
    try {
      await ref
          .read(investmentRepositoryProvider)
          .createRequest(
            offer: offer,
            amount: _amount,
            termMonths: _selectedTerm!,
            consent: true,
            interestPaymentOption: _interestPaymentOption,
          );
      if (!mounted) return;
      ref
          .read(dolaritoProvider.notifier)
          .show(
            ref.read(dolaritoServiceProvider).investmentRequestSent(),
            force: true,
          );
      ref.invalidate(investmentRequestsProvider);
      setState(() => _showRequests = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud enviada a la cooperativa.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _messageFor(error));
      ref
          .read(dolaritoProvider.notifier)
          .show(
            ref.read(dolaritoServiceProvider).investmentConnectionError(),
            force: true,
          );
    } finally {
      if (mounted) setState(() => _sendingOfferId = null);
    }
  }

  String _messageFor(Object error) => error is AppException
      ? error.message
      : 'No se pudo completar la acción. Inténtalo nuevamente.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);

    if (_showRequests && auth.isAuthenticated) {
      ref.listen(investmentRequestsProvider, (previous, next) {
        final latest = next.valueOrNull?.firstOrNull;
        if (latest != null &&
            previous?.valueOrNull?.firstOrNull?.status != latest.status) {
          ref
              .read(dolaritoProvider.notifier)
              .show(
                ref
                    .read(dolaritoServiceProvider)
                    .investmentRequestStatus(latest.status),
                force: true,
              );
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),
      appBar: AppBar(
        title: const Text(
          'Inversiones',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: 'Mis solicitudes',
            onPressed: () => setState(() => _showRequests = !_showRequests),
            icon: Icon(
              _showRequests
                  ? Icons.savings_outlined
                  : Icons.receipt_long_outlined,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (auth.isAuthenticated) {
              ref.invalidate(investmentRequestsProvider);
            }
            if (!_showRequests && _amount > 0) await _loadAvailability();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
            children: [
              _SectionSwitch(
                showRequests: _showRequests,
                onChanged: (value) => setState(() => _showRequests = value),
              ),
              const SizedBox(height: 14),
              const DolaritoStateWidget(compact: true),
              const SizedBox(height: 16),
              if (_error != null) ...[
                _ErrorBanner(message: _error!),
                const SizedBox(height: 12),
              ],
              if (_showRequests)
                auth.isAuthenticated
                    ? const InvestmentRequestsList()
                    : _SignInToSeeRequests(
                        onSignIn: () => context.push('/login'),
                      )
              else ...[
                _IntroCard(theme: theme),
                const SizedBox(height: 16),
                AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _StepLabel(
                        number: '1',
                        title: '¿Cuánto deseas invertir?',
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => setState(() {
                          _selectedTerm = null;
                          _availableTermMonths = const [];
                          _availablePaymentOptions = const [];
                          _interestPaymentOption = null;
                          _offers = const [];
                        }),
                        decoration: InputDecoration(
                          prefixText: '\$ ',
                          hintText: 'Ej. 1.000,00',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          helperText:
                              'Solo usamos este monto para consultar ofertas compatibles.',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _StepLabel(
                        number: '2',
                        title: '¿Por cuánto tiempo?',
                      ),
                      const SizedBox(height: 10),
                      if (_availableTermMonths.isEmpty)
                        OutlinedButton.icon(
                          onPressed: _isLoadingAvailability || _amount <= 0
                              ? null
                              : () => _loadAvailability(),
                          icon: _isLoadingAvailability
                              ? const SizedBox.square(
                                  dimension: 17,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.search_rounded),
                          label: Text(
                            _isLoadingAvailability
                                ? 'Buscando plazos…'
                                : 'Ver plazos disponibles',
                          ),
                        )
                      else
                        DropdownButtonFormField<int>(
                          initialValue:
                              _availableTermMonths.contains(_selectedTerm)
                              ? _selectedTerm
                              : null,
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'Elige un plazo disponible',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          items: _availableTermMonths
                              .map(
                                (month) => DropdownMenuItem(
                                  value: month,
                                  child: Text(
                                    '$month ${month == 1 ? 'mes' : 'meses'}',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTerm = value;
                              _offers = const [];
                              _interestPaymentOption = null;
                              _availablePaymentOptions = const [];
                            });
                            if (value != null) {
                              _loadAvailability(termMonths: value);
                            }
                          },
                        ),
                      if (_selectedTerm != null && _isLoadingAvailability)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: LinearProgressIndicator(),
                        ),
                      if (_selectedTerm != null &&
                          _availablePaymentOptions.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const _StepLabel(
                          number: '3',
                          title: '¿Cómo prefieres recibir intereses?',
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String?>(
                          initialValue:
                              _availablePaymentOptions.contains(
                                _interestPaymentOption,
                              )
                              ? _interestPaymentOption
                              : null,
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'Sin preferencia',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Sin preferencia'),
                            ),
                            ..._availablePaymentOptions.map(
                              (option) => DropdownMenuItem<String?>(
                                value: option,
                                child: Text(_paymentOptionLabel(option)),
                              ),
                            ),
                          ],
                          onChanged: (value) => setState(() {
                            _interestPaymentOption = value;
                            _offers = const [];
                          }),
                        ),
                      ],
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed:
                            _isComparing ||
                                _isLoadingAvailability ||
                                _availableTermMonths.isEmpty
                            ? null
                            : _compare,
                        icon: _isComparing
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.compare_arrows_rounded),
                        label: Text(
                          _isComparing
                              ? 'Comparando opciones…'
                              : 'Comparar ofertas',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: _green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_offers.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Ofertas compatibles',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: _navy,
                          ),
                        ),
                      ),
                      Text(
                        '${_offers.length} opciones',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: _green,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ordenadas por ganancia estimada cuando la cooperativa configuró su método de cálculo.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _muted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._offers.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OfferCard(
                        offer: entry.value,
                        amount: _amount,
                        termMonths: _selectedTerm!,
                        paymentOption: _interestPaymentOption,
                        isTopEstimate:
                            entry.key == 0 &&
                            entry.value.estimatedInterest != null,
                        isSending: _sendingOfferId == entry.value.conditionId,
                        onSelect: () => _selectOffer(entry.value),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const _DisclaimerCard(),
                ] else if (!_isComparing &&
                    _error == null &&
                    _selectedTerm != null) ...[
                  const SizedBox(height: 14),
                  const _DisclaimerCard(),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class InvestmentRequestsList extends ConsumerWidget {
  const InvestmentRequestsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(investmentRequestsProvider);
    return requests.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(36),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => _ErrorBanner(
        message: error is AppException
            ? error.message
            : 'No se pudieron cargar tus solicitudes.',
      ),
      data: (items) => items.isEmpty
          ? const AppCard(
              padding: EdgeInsets.all(22),
              child: Text(
                'Todavía no tienes solicitudes de inversión. Compara ofertas para comenzar.',
              ),
            )
          : Column(
              children: items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _InvestmentRequestCard(request: item),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _InvestmentRequestCard extends StatelessWidget {
  const _InvestmentRequestCard({required this.request});
  final InvestmentRequest request;

  @override
  Widget build(BuildContext context) {
    final status = _requestStatus(request.status);
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.cooperativeName,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      request.productName,
                      style: const TextStyle(
                        color: _navy,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: status.$2.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  status.$1,
                  style: TextStyle(
                    color: status.$2,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${_money(request.amount)} · ${request.termMonths} meses · ${request.annualRate.toStringAsFixed(2)}% anual',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          if (request.estimatedInterest != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Estimación guardada: ${_money(request.estimatedInterest!)} de interés · total ${_money(request.estimatedTotal ?? request.amount)}',
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'La cooperativa debe confirmar la ganancia; no se configuró un método de cálculo.',
                style: TextStyle(color: _muted, fontSize: 12),
              ),
            ),
          if (request.statusNote?.isNotEmpty == true) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                request.statusNote!,
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
          ],
          if (request.status == 'CONDITIONS_CONFIRMED')
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'La operación todavía debe formalizarse directamente con la cooperativa.',
                style: TextStyle(
                  color: _green,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.offer,
    required this.amount,
    required this.termMonths,
    required this.paymentOption,
    required this.isTopEstimate,
    required this.isSending,
    required this.onSelect,
  });

  final InvestmentOffer offer;
  final double amount;
  final int termMonths;
  final String? paymentOption;
  final bool isTopEstimate;
  final bool isSending;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _CooperativeLogo(url: offer.cooperativeLogoUrl),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.cooperativeName,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    offer.productName,
                    style: const TextStyle(
                      color: _navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            if (isTopEstimate)
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFD3A447),
                size: 22,
              ),
          ],
        ),
        if (isTopEstimate) ...[
          const SizedBox(height: 8),
          const Text(
            'Mayor ganancia estimada entre estas opciones',
            style: TextStyle(
              color: _green,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'Tasa anual',
                value: '${offer.annualRate.toStringAsFixed(2)}%',
              ),
            ),
            Expanded(
              child: _Metric(label: 'Monto', value: _money(amount)),
            ),
            Expanded(
              child: _Metric(label: 'Plazo', value: '$termMonths meses'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (offer.estimatedInterest != null && offer.estimatedTotal != null)
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _Metric(
                    label: 'Interés estimado',
                    value: _money(offer.estimatedInterest!),
                  ),
                ),
                Expanded(
                  child: _Metric(
                    label: 'Total estimado',
                    value: _money(offer.estimatedTotal!),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Ganancia no estimada: la cooperativa no configuró el método de cálculo. Solicita confirmación antes de decidir.',
              style: TextStyle(
                color: Color(0xFF73551D),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        const SizedBox(height: 11),
        Text(
          'Vigente desde ${_date(offer.validFrom)}${offer.validUntil == null ? '' : ' hasta ${_date(offer.validUntil!)}'}',
          style: const TextStyle(color: _muted, fontSize: 11),
        ),
        if (paymentOption != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Pago de intereses: ${_paymentOptionLabel(paymentOption!)}',
              style: const TextStyle(color: _muted, fontSize: 11),
            ),
          ),
        if (offer.description?.isNotEmpty == true ||
            offer.renewalConditions?.isNotEmpty == true ||
            offer.earlyCancellationConditions?.isNotEmpty == true) ...[
          const SizedBox(height: 10),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: 7),
            title: const Text(
              'Condiciones de la oferta',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
            children: [
              if (offer.description?.isNotEmpty == true)
                _ConditionLine(label: 'Descripción', value: offer.description!),
              if (offer.renewalConditions?.isNotEmpty == true)
                _ConditionLine(
                  label: 'Renovación',
                  value: offer.renewalConditions!,
                ),
              if (offer.earlyCancellationConditions?.isNotEmpty == true)
                _ConditionLine(
                  label: 'Cancelación anticipada',
                  value: offer.earlyCancellationConditions!,
                ),
              if (offer.targetAudience?.isNotEmpty == true)
                _ConditionLine(
                  label: 'Dirigido a',
                  value: offer.targetAudience!,
                ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        FilledButton(
          onPressed: isSending ? null : onSelect,
          style: FilledButton.styleFrom(
            backgroundColor: _green,
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          child: Text(
            isSending ? 'Enviando…' : 'Ver oferta y solicitar contacto',
          ),
        ),
      ],
    ),
  );
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [_green, Color(0xFF07543C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Encuentra dónde hacer crecer tu dinero',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Compara opciones vigentes de distintas cooperativas y revisa sus condiciones antes de elegir.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: .9),
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}

class _SectionSwitch extends StatelessWidget {
  const _SectionSwitch({required this.showRequests, required this.onChanged});
  final bool showRequests;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<bool>(
    segments: const [
      ButtonSegment(
        value: false,
        icon: Icon(Icons.compare_arrows_rounded),
        label: Text('Comparar'),
      ),
      ButtonSegment(
        value: true,
        icon: Icon(Icons.receipt_long_outlined),
        label: Text('Mis solicitudes'),
      ),
    ],
    selected: {showRequests},
    onSelectionChanged: (values) => onChanged(values.first),
  );
}

class _SignInToSeeRequests extends StatelessWidget {
  const _SignInToSeeRequests({required this.onSignIn});
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(22),
    child: Column(
      children: [
        const Icon(Icons.lock_outline_rounded, color: _green, size: 34),
        const SizedBox(height: 10),
        const Text('Inicia sesión para consultar tus solicitudes.'),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onSignIn,
          child: const Text('Iniciar sesión'),
        ),
      ],
    ),
  );
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F3F4),
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Text(
      'Las ganancias mostradas son estimaciones antes de impuestos, retenciones u otros cargos. Si la cooperativa no configuró un método de cálculo, no mostramos una cifra estimada. La cooperativa confirma disponibilidad y formaliza la inversión.',
      style: TextStyle(color: _muted, fontSize: 11, height: 1.45),
    ),
  );
}

class _CooperativeLogo extends StatelessWidget {
  const _CooperativeLogo({required this.url});
  final String? url;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Container(
      width: 45,
      height: 45,
      color: const Color(0xFFEAF4EF),
      child: url?.isNotEmpty == true
          ? Image.network(
              url!,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.account_balance_rounded, color: _green),
            )
          : const Icon(Icons.account_balance_rounded, color: _green),
    ),
  );
}

class _StepLabel extends StatelessWidget {
  const _StepLabel({required this.number, required this.title});
  final String number;
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: 13,
        backgroundColor: const Color(0xFFE7F5ED),
        child: Text(
          number,
          style: const TextStyle(
            color: _green,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      const SizedBox(width: 9),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            color: _navy,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    ],
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: _muted,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          color: _navy,
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

class _ConditionLine extends StatelessWidget {
  const _ConditionLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '$label: $value',
        style: const TextStyle(color: _muted, fontSize: 12, height: 1.4),
      ),
    ),
  );
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF0EF),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      message,
      style: const TextStyle(color: Color(0xFF9B3730), fontSize: 13),
    ),
  );
}

class _ConfirmationRow extends StatelessWidget {
  const _ConfirmationRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _navy,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

String _paymentOptionLabel(String option) => switch (option.toUpperCase()) {
  'MONTHLY' => 'Mensualmente',
  'AT_MATURITY' => 'Al vencimiento',
  'REINVEST' => 'Reinvertir intereses',
  _ => 'Según condiciones de la cooperativa',
};

(String, Color) _requestStatus(String status) => switch (status) {
  'SUBMITTED' => ('Enviada', const Color(0xFF9B6A14)),
  'IN_REVIEW' => ('En revisión', const Color(0xFF2E6D9D)),
  'INFORMATION_REQUIRED' => ('Requiere atención', const Color(0xFF9B6A14)),
  'CONDITIONS_CONFIRMED' => ('Condiciones confirmadas', _green),
  'DECLINED' => ('No continuó', const Color(0xFFAA4B4B)),
  _ => ('Estado pendiente', _muted),
};

String _money(double amount) => NumberFormat.currency(
  locale: 'es_EC',
  symbol: '\$',
  decimalDigits: 2,
).format(amount);

String _date(DateTime date) => DateFormat('dd/MM/yyyy', 'es').format(date);
