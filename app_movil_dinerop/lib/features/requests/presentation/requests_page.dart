import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../credit/data/models/client_credit_request.dart';
import '../../credit/data/models/credit_cooperative_status.dart';
import '../../credit/data/models/credit_enums.dart';
import '../../credit/presentation/widgets/credit_request_card.dart';
import '../../dolarito/providers/dolarito_provider.dart';
import '../../dolarito/models/dolarito_mood.dart';
import '../../dolarito/widgets/dolarito_widget.dart';
import '../../investment/data/models/investment_models.dart';
import '../../investment/providers/investment_providers.dart';

class RequestsPage extends ConsumerStatefulWidget {
  const RequestsPage({
    super.key,
    this.initialCreditId,
    this.initialInvestmentId,
  });

  final int? initialCreditId;
  final int? initialInvestmentId;

  @override
  ConsumerState<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends ConsumerState<RequestsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  CreditRequestStatus? _statusFilter;
  String? _typeFilter;
  late int _selectedTab = widget.initialInvestmentId == null ? 0 : 1;
  bool _initialDetailsOpened = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showDetails(
    BuildContext context,
    WidgetRef ref,
    ClientCreditRequestSummary request,
  ) async {
    final repo = ref.read(creditRepositoryProvider);
    try {
      final offers = await repo.loadPreApprovedCooperatives(
        request.solicitudId,
      );
      if (!context.mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _RequestDetailsSheet(request: request, offers: offers),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : AppErrorMessages.generic,
          ),
        ),
      );
    }
  }

  List<ClientCreditRequestSummary> _filteredRequests(
    List<ClientCreditRequestSummary> requests,
  ) {
    final query = _searchQuery.trim().toLowerCase();
    return requests.where((request) {
      final matchesSearch =
          query.isEmpty ||
          request.solicitudId.toString().contains(query) ||
          request.monto.toString().contains(query);
      final matchesStatus =
          _statusFilter == null || request.estado == _statusFilter;
      final matchesType =
          _typeFilter == null || request.tipo.toUpperCase() == _typeFilter;
      return matchesSearch && matchesStatus && matchesType;
    }).toList();
  }

  Widget _requestTabs() => SegmentedButton<int>(
    segments: const [
      ButtonSegment(
        value: 0,
        icon: Icon(Icons.credit_score_outlined),
        label: Text('Créditos'),
      ),
      ButtonSegment(
        value: 1,
        icon: Icon(Icons.savings_outlined),
        label: Text('Inversiones'),
      ),
    ],
    selected: {_selectedTab},
    onSelectionChanged: (selection) =>
        setState(() => _selectedTab = selection.first),
  );

  Future<void> _showInvestmentDetails(
    BuildContext context,
    InvestmentRequest request,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _InvestmentDetailsSheet(request: request),
    );
  }

  void _openInitialCreditDetailsIfRequested(
    BuildContext context,
    WidgetRef ref,
    List<ClientCreditRequestSummary> requests,
  ) {
    final id = widget.initialCreditId;
    if (_initialDetailsOpened || id == null) return;
    final matches = requests.where((item) => item.solicitudId == id);
    if (matches.isEmpty) return;
    final request = matches.first;
    _initialDetailsOpened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showDetails(context, ref, request);
    });
  }

  void _openInitialInvestmentDetailsIfRequested(
    BuildContext context,
    List<InvestmentRequest> requests,
  ) {
    final id = widget.initialInvestmentId;
    if (_initialDetailsOpened || id == null) return;
    final matches = requests.where((item) => item.id == id);
    if (matches.isEmpty) return;
    final request = matches.first;
    _initialDetailsOpened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showInvestmentDetails(context, request);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final requests = ref.watch(requestsProvider);
    final investments = ref.watch(investmentRequestsProvider);
    final theme = Theme.of(context);
    if (_selectedTab == 1) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: _requestTabs(),
              ),
              Expanded(
                child: investments.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      DolaritoWidget(
                        mood: ref
                            .read(dolaritoServiceProvider)
                            .investmentConnectionError()
                            .mood,
                        message: ref
                            .read(dolaritoServiceProvider)
                            .investmentConnectionError()
                            .message,
                        compact: true,
                        actionLabel: 'Reintentar',
                        onAction: () =>
                            ref.invalidate(investmentRequestsProvider),
                      ),
                      const SizedBox(height: 14),
                      AppErrorView(
                        message: error is AppException
                            ? error.message
                            : AppErrorMessages.generic,
                      ),
                    ],
                  ),
                  data: (items) {
                    _openInitialInvestmentDetailsIfRequested(context, items);
                    return RefreshIndicator(
                      onRefresh: () async =>
                          ref.invalidate(investmentRequestsProvider),
                      child: items.isEmpty
                          ? ListView(
                              children: [
                                const SizedBox(height: 60),
                                AppEmptyState(
                                  title:
                                      'Todavía no tienes inversiones solicitadas',
                                  message:
                                      'Compara ofertas y envía una solicitud para consultar aquí las respuestas de la cooperativa.',
                                  actionLabel: 'Comenzar a invertir',
                                  icon: Icons.savings_outlined,
                                  onAction: () =>
                                      context.push('/simulate-investment'),
                                ),
                              ],
                            )
                          : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                12,
                                20,
                                30,
                              ),
                              itemCount: items.length + 1,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                if (index == 0)
                                  return const _InvestmentRequestsHeading();
                                final request = items[index - 1];
                                return _InvestmentRequestCard(
                                  request: request,
                                  onTap: () =>
                                      _showInvestmentDetails(context, request),
                                );
                              },
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: requests.when(
          data: (items) {
            _openInitialCreditDetailsIfRequested(context, ref, items);
            final filteredItems = _filteredRequests(items);
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(requestsProvider),
              child: items.isEmpty
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                          child: _requestTabs(),
                        ),
                        const SizedBox(height: 88),
                        AppEmptyState(
                          title: 'Todavía no tienes solicitudes',
                          message:
                              'Crea tu primera solicitud para ver su seguimiento y ofertas aquí.',
                          actionLabel: 'Solicitar crédito',
                          onAction: () => context.push('/request-credit'),
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                      ],
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                      itemCount: filteredItems.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _requestTabs(),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Mis solicitudes',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    '${filteredItems.length}/${items.length}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Revisa tus avances, respuestas y ofertas.',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _searchController,
                                onChanged: (value) =>
                                    setState(() => _searchQuery = value),
                                decoration: InputDecoration(
                                  hintText: 'Buscar por número o monto',
                                  prefixIcon: const Icon(Icons.search_rounded),
                                  suffixIcon: _searchQuery.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() => _searchQuery = '');
                                          },
                                          icon: const Icon(Icons.close_rounded),
                                        ),
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    FilterChip(
                                      label: const Text('Todos'),
                                      selected:
                                          _statusFilter == null &&
                                          _typeFilter == null,
                                      onSelected: (_) => setState(() {
                                        _statusFilter = null;
                                        _typeFilter = null;
                                      }),
                                    ),
                                    const SizedBox(width: 8),
                                    ...[
                                      (
                                        label: 'Enviadas',
                                        value: CreditRequestStatus.enviada,
                                      ),
                                      (
                                        label: 'Pre aprobadas',
                                        value: CreditRequestStatus.preAprobada,
                                      ),
                                      (
                                        label: 'Rechazadas',
                                        value: CreditRequestStatus.rechazada,
                                      ),
                                    ].map(
                                      (filter) => Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: FilterChip(
                                          label: Text(filter.label),
                                          selected:
                                              _statusFilter == filter.value,
                                          onSelected: (_) => setState(() {
                                            _typeFilter = null;
                                            _statusFilter =
                                                _statusFilter == filter.value
                                                ? null
                                                : filter.value;
                                          }),
                                        ),
                                      ),
                                    ),
                                    FilterChip(
                                      label: const Text('Créditos'),
                                      selected: _typeFilter == 'CREDITO',
                                      onSelected: (_) => setState(() {
                                        _statusFilter = null;
                                        _typeFilter = _typeFilter == 'CREDITO'
                                            ? null
                                            : 'CREDITO';
                                      }),
                                    ),
                                    const SizedBox(width: 8),
                                    FilterChip(
                                      label: const Text('Inversiones'),
                                      selected: _typeFilter == 'INVERSION',
                                      onSelected: (_) => setState(() {
                                        _statusFilter = null;
                                        _typeFilter = _typeFilter == 'INVERSION'
                                            ? null
                                            : 'INVERSION';
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              if (filteredItems.isEmpty) ...[
                                const SizedBox(height: 30),
                                const Center(
                                  child: Text(
                                    'No hay solicitudes con esos filtros.',
                                  ),
                                ),
                              ],
                            ],
                          );
                        }
                        final item = filteredItems[index - 1];
                        return CreditRequestCard(
                          request: item,
                          onTap: () => _showDetails(context, ref, item),
                        );
                      },
                    ),
            );
          },
          loading: () => const AppLoader(label: 'Cargando solicitudes...'),
          error: (error, _) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              DolaritoWidget(
                mood: ref.read(dolaritoServiceProvider).creditLoadError().mood,
                message: ref
                    .read(dolaritoServiceProvider)
                    .creditLoadError()
                    .message,
                compact: true,
                actionLabel: 'Reintentar',
                onAction: () => ref.invalidate(requestsProvider),
              ),
              const SizedBox(height: 14),
              AppErrorView(
                message: error is AppException
                    ? error.message
                    : AppErrorMessages.generic,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestDetailsSheet extends ConsumerWidget {
  const _RequestDetailsSheet({required this.request, required this.offers});
  final ClientCreditRequestSummary request;
  final List<CreditCooperativeStatus> offers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: .9,
      minChildSize: .55,
      maxChildSize: .96,
      expand: false,
      builder: (context, scrollController) => Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ofertas y respuestas de cooperativas',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Solicitud #${request.solicitudId} · ${formatCurrency(request.monto)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Builder(
              builder: (context) {
                final reaction = ref
                    .read(dolaritoServiceProvider)
                    .creditStatus(
                      request.estado,
                      requestId: request.solicitudId,
                    );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DolaritoWidget(
                    mood: reaction.mood,
                    message: reaction.message,
                    compact: true,
                    actionLabel: reaction.actionLabel,
                    onAction: reaction.action == null
                        ? null
                        : () => context.go('/requests'),
                  ),
                );
              },
            ),
            if (offers.isEmpty)
              _NoOffersCard(request: request)
            else ...[
              Center(
                child: Text(
                  '${offers.length} ${offers.length == 1 ? 'respuesta' : 'respuestas'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...offers.map(
                (offer) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _OfferCard(
                    requestId: request.solicitudId,
                    offer: offer,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NoOffersCard extends StatelessWidget {
  const _NoOffersCard({required this.request});
  final ClientCreditRequestSummary request;
  @override
  Widget build(BuildContext context) {
    final message = switch (request.estado) {
      CreditRequestStatus.creada =>
        'Completa tu perfil para que podamos enviar tu solicitud a cooperativas.',
      CreditRequestStatus.enviada =>
        'Tu solicitud está siendo revisada. Te avisaremos cuando una cooperativa responda.',
      CreditRequestStatus.rechazada =>
        'Por ahora no existen ofertas disponibles para esta solicitud.',
      _ => 'Aún no hay ofertas disponibles para esta solicitud.',
    };
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.infoSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.hourglass_top_rounded,
            color: AppColors.info,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            'Sin respuestas aún',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends ConsumerStatefulWidget {
  const _OfferCard({required this.requestId, required this.offer});
  final int requestId;
  final CreditCooperativeStatus offer;
  @override
  ConsumerState<_OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends ConsumerState<_OfferCard> {
  bool _accepting = false;
  bool _showGuarantorHistory = false;
  Future<List<Map<String, dynamic>>>? _guarantorHistory;

  void _toggleGuarantorHistory() {
    setState(() {
      _showGuarantorHistory = !_showGuarantorHistory;
      _guarantorHistory ??= ref
          .read(creditRepositoryProvider)
          .loadGuarantorHistory(
            solicitudId: widget.requestId,
            cooperativaId: widget.offer.cooperativaId,
          );
    });
  }

  Future<void> _accept() async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Aceptar esta oferta?'),
        content: const Text(
          'Al aceptar, no podrás elegir otra cooperativa para esta solicitud.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
    if (accepted != true) return;
    setState(() => _accepting = true);
    try {
      await ref
          .read(creditRepositoryProvider)
          .acceptCooperative(
            solicitudId: widget.requestId,
            cooperativaId: widget.offer.cooperativaId,
          );
      ref.invalidate(requestsProvider);
      ref.invalidate(dashboardCreditRequestsProvider);
      if (mounted) {
        await _showDocumentsAfterAcceptance();
        if (mounted) Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is AppException ? error.message : AppErrorMessages.generic,
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }

  Future<void> _showDocumentsAfterAcceptance() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .72,
        minChildSize: .45,
        maxChildSize: .94,
        builder: (_, controller) => Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Documentos para la cooperativa',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.successSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.celebration_rounded,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '¡Felicidades! ${widget.offer.nombreCooperativa} aceptó tu oferta. Acércate con los requisitos indicados para completar el trámite y retirar tu dinero.',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('Presenta estos documentos en la oficina:'),
                    const SizedBox(height: 12),
                    ...widget.offer.requisitos.map(
                      (item) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: item.mandatory
                              ? AppColors.infoSoft
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              item.mandatory
                                  ? Icons.assignment_turned_in_outlined
                                  : Icons.info_outline,
                              size: 20,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                '${item.title}${item.description == null ? '' : '\n${item.description}'}\n${item.mandatory ? 'Obligatorio' : 'Opcional'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.offer.direccion?.isNotEmpty == true) ...[
                      const Divider(height: 24),
                      Text('Ubicación: ${widget.offer.direccion}'),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    if (widget.offer.mapsUrl?.isNotEmpty == true)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => launchUrl(
                            Uri.parse(widget.offer.mapsUrl!),
                            mode: LaunchMode.externalApplication,
                          ),
                          icon: const Icon(Icons.map_outlined),
                          label: const Text('Cómo llegar'),
                        ),
                      ),
                    if (widget.offer.mapsUrl?.isNotEmpty == true)
                      const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _previewReferralPdf,
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text('Ver PDF'),
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

  Future<void> _previewReferralPdf() async {
    try {
      final bytes = await ref
          .read(creditRepositoryProvider)
          .downloadReferralPdf(
            solicitudId: widget.requestId,
            cooperativaId: widget.offer.cooperativaId,
          );
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => SizedBox(
          height: MediaQuery.sizeOf(context).height * .9,
          child: PdfPreview(
            build: (_) async => bytes,
            canChangePageFormat: false,
            canChangeOrientation: false,
            allowSharing: true,
            allowPrinting: true,
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is AppException ? error.message : AppErrorMessages.generic,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    final cooperativeLogoUrl = ref
        .watch(cooperativesProvider)
        .valueOrNull
        ?.where((cooperative) => cooperative.id == offer.cooperativaId)
        .map((cooperative) => cooperative.logoUrl)
        .firstOrNull;
    final needsGuarantor =
        offer.estado == CreditRequestStatus.solicitandoGarante &&
        !offer.garanteEnRevision;
    final guaranteeInReview =
        offer.estado == CreditRequestStatus.solicitandoGarante &&
        offer.garanteEnRevision;
    final rejected = offer.estado == CreditRequestStatus.rechazada;
    final color = rejected
        ? AppColors.error
        : needsGuarantor
        ? AppColors.warning
        : AppColors.success;
    final soft = rejected
        ? AppColors.errorSoft
        : needsGuarantor
        ? AppColors.warningSoft
        : AppColors.successSoft;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _CooperativeAvatar(
                      logoUrl: cooperativeLogoUrl,
                      size: 46,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.nombreCooperativa,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            'Actualizada ${formatDate(offer.fechaActualizacion)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    _OfferStatus(
                      text: needsGuarantor
                          ? 'Requiere garante'
                          : guaranteeInReview
                          ? 'Garante en revisión'
                          : rejected
                          ? 'Rechazada'
                          : offer.estado == CreditRequestStatus.aceptada
                          ? 'Aceptada'
                          : 'Preaprobada',
                      color: color,
                      soft: soft,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (rejected) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.errorSoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Motivos del rechazo',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...offer.motivosRechazo.map(
                          (reason) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  size: 17,
                                  color: AppColors.error,
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: Text(reason)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (needsGuarantor)
                  _GuarantorNotice(message: offer.mensajeGarante),
                if (guaranteeInReview)
                  _GuaranteeReviewNotice(color: color, soft: soft),
                if (offer.estado != CreditRequestStatus.aceptada)
                  TextButton.icon(
                  onPressed: _toggleGuarantorHistory,
                  icon: Icon(
                    _showGuarantorHistory
                        ? Icons.expand_less_rounded
                        : Icons.history_rounded,
                  ),
                  label: Text(
                    _showGuarantorHistory
                        ? 'Ocultar historial del garante'
                        : 'Ver historial del garante',
                  ),
                ),
                if (_showGuarantorHistory &&
                    offer.estado != CreditRequestStatus.aceptada)
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _guarantorHistory,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (snapshot.hasError) {
                        return const _GuarantorHistoryMessage(
                          message:
                              'No se pudo cargar el historial. Intenta nuevamente más tarde.',
                        );
                      }
                      final history =
                          snapshot.data ?? const <Map<String, dynamic>>[];
                      if (history.isEmpty) {
                        return const _GuarantorHistoryMessage(
                          message:
                              'Todavía no hay envíos vinculados a esta solicitud. Los datos anteriores se conservan como legado y no se asocian automáticamente a este crédito.',
                        );
                      }
                      return _GuarantorHistoryView(items: history);
                    },
                  ),
                if (needsGuarantor) const SizedBox(height: 12),
                if (guaranteeInReview) const SizedBox(height: 12),
                if (offer.requiereComparecenciaGarante)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.infoSoft,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Garante aprobado. Para completar el trámite deben acudir presencialmente el solicitante y el garante con los documentos indicados.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (offer.estado != CreditRequestStatus.aceptada &&
                    !rejected &&
                    !needsGuarantor &&
                    !guaranteeInReview &&
                    offer.requisitos.isNotEmpty)
                  _RequirementsPreview(requirements: offer.requisitos),
                if (offer.estado != CreditRequestStatus.aceptada &&
                    !rejected &&
                    !needsGuarantor &&
                    !guaranteeInReview &&
                    offer.requisitos.isNotEmpty)
                  const SizedBox(height: 12),
                if (offer.estado == CreditRequestStatus.aceptada)
                  _AcceptedOfferNotice(
                    offer: offer,
                    onOpenDocuments: _showDocumentsAfterAcceptance,
                    onPreviewPdf: _previewReferralPdf,
                  )
                else if (!rejected) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4E8FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'CUOTA MENSUAL',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatCurrency(offer.cuotaMensual ?? 0),
                          style: const TextStyle(
                            color: Color(0xFF3730A3),
                            fontWeight: FontWeight.w900,
                            fontSize: 29,
                          ),
                        ),
                        Text(
                          'durante ${offer.plazoMeses ?? '-'} meses',
                          style: const TextStyle(
                            color: Color(0xFF5B5BA8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.8,
                    children: [
                      _Metric(
                        label: 'MONTO',
                        value: formatCurrency(offer.monto),
                      ),
                      _Metric(
                        label: 'TASA ANUAL',
                        value: offer.tasaAnual == null
                            ? '-'
                            : '${offer.tasaAnual!.toStringAsFixed(2)}%',
                      ),
                      _Metric(
                        label: 'TOTAL A PAGAR',
                        value: offer.totalPagar == null
                            ? '-'
                            : formatCurrency(offer.totalPagar!),
                      ),
                      _Metric(
                        label: 'INTERÉS TOTAL',
                        value: offer.interesTotal == null
                            ? '-'
                            : formatCurrency(offer.interesTotal!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: color),
                      onPressed: needsGuarantor
                          ? () async {
                              final completed = await context.push<bool>(
                                '/guarantor-onboarding?solicitudId=${widget.requestId}&cooperativaId=${offer.cooperativaId}',
                              );
                              if (!mounted || completed != true) return;
                              ref.invalidate(requestsProvider);
                              ref.invalidate(dashboardCreditRequestsProvider);
                              Navigator.of(this.context).pop();
                            }
                          : guaranteeInReview
                          ? null
                          : _accepting
                          ? null
                          : _accept,
                      icon: Icon(
                        needsGuarantor
                            ? Icons.group_add_rounded
                            : Icons.verified_user_rounded,
                      ),
                      label: Text(
                        needsGuarantor
                            ? 'Registrar información del garante'
                            : guaranteeInReview
                            ? 'Garante en revisión'
                            : _accepting
                            ? 'Aceptando oferta...'
                            : 'Aceptar esta oferta',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuarantorHistoryMessage extends StatelessWidget {
  const _GuarantorHistoryMessage({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: AppColors.infoSoft,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(message, style: const TextStyle(fontSize: 12, height: 1.45)),
  );
}

class _GuarantorHistoryView extends StatelessWidget {
  const _GuarantorHistoryView({required this.items});
  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) => Column(
    children: items.map((item) {
      final snapshot = Map<String, dynamic>.from(
        item['fotografia'] as Map? ?? const {},
      );
      final evaluations = (item['evaluaciones'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((value) => Map<String, dynamic>.from(value));
      final name = '${snapshot['nombres'] ?? ''} ${snapshot['apellidos'] ?? ''}'
          .trim();
      final sentAt = item['enviadoEn']?.toString();
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 9),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: .55),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Intento ${item['intento'] ?? '—'} · ${name.isEmpty ? 'Garante' : name}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            Text(
              'Enviado: ${sentAt ?? 'Fecha no disponible'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ...evaluations.map((evaluation) {
              final reasons =
                  (evaluation['motivosRechazo'] as List<dynamic>? ?? const [])
                      .join(', ');
              final other = evaluation['motivoRechazoOtro']?.toString();
              final observation = evaluation['observacion']?.toString();
              final explanation = [reasons, other, observation]
                  .where((value) => value != null && value.trim().isNotEmpty)
                  .join(' · ');
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (evaluation['decision'] ?? 'Revisión')
                            .toString()
                            .replaceAll('_', ' '),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Responsable: ${evaluation['actorRole'] ?? '—'} · ID ${evaluation['actorId'] ?? '—'} · ${evaluation['fecha'] ?? ''}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (explanation.isNotEmpty)
                        Text(
                          explanation,
                          style: const TextStyle(fontSize: 12, height: 1.4),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );
    }).toList(),
  );
}

class _OfferStatus extends StatelessWidget {
  const _OfferStatus({
    required this.text,
    required this.color,
    required this.soft,
  });
  final String text;
  final Color color;
  final Color soft;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: soft,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800),
    ),
  );
}

class _GuarantorNotice extends StatelessWidget {
  const _GuarantorNotice({this.message});
  final String? message;
  @override
  Widget build(BuildContext context) {
    final details = message?.trim();
    final reasonsIndex = details?.indexOf('Motivos:') ?? -1;
    final hasReasons = reasonsIndex >= 0;
    final reasonText = hasReasons
        ? details!.substring(reasonsIndex + 'Motivos:'.length).trim()
        : details;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0D18E)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D7A4B00),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8B3),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: Color(0xFF9A5B00),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasReasons
                          ? 'Acción requerida'
                          : 'Se requiere un garante',
                      style: const TextStyle(
                        color: Color(0xFF80500A),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .7,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasReasons
                          ? 'Actualiza la información del garante'
                          : 'Completa la información del garante',
                      style: const TextStyle(
                        color: Color(0xFF392B14),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            hasReasons ? 'Lo que debes corregir' : 'Siguiente paso',
            style: const TextStyle(
              color: Color(0xFF80500A),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              reasonText?.isNotEmpty == true
                  ? reasonText!
                  : 'La cooperativa necesita revisar la información de un garante para continuar con tu solicitud. Puedes volver a registrar los datos desde aquí.',
              style: const TextStyle(
                color: Color(0xFF594A32),
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuaranteeReviewNotice extends StatelessWidget {
  const _GuaranteeReviewNotice({required this.color, required this.soft});

  final Color color;
  final Color soft;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: soft,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.hourglass_top_rounded, color: color),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            'La información del garante fue enviada y está en revisión. '
            'La cooperativa debe aceptarla antes de mostrar los requisitos finales.',
            style: TextStyle(color: color.withValues(alpha: .9), fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class _RequirementsPreview extends StatelessWidget {
  const _RequirementsPreview({required this.requirements});
  final List<CreditRequirement> requirements;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.infoSoft,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Documentos solicitados',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        ...requirements
            .take(4)
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• ${item.title}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        if (requirements.length > 4)
          Text(
            '+ ${requirements.length - 4} documentos más',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
      ],
    ),
  );
}

class _AcceptedOfferNotice extends StatelessWidget {
  const _AcceptedOfferNotice({
    required this.offer,
    required this.onOpenDocuments,
    required this.onPreviewPdf,
  });
  final CreditCooperativeStatus offer;
  final VoidCallback onOpenDocuments;
  final VoidCallback onPreviewPdf;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEAFBF3), Color(0xFFF5FFFA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: const Color(0xFFB9E9D0)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.verified_rounded, color: AppColors.success),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    '¡Tu crédito está listo! Acércate a ${offer.nombreCooperativa} con los requisitos para completar el trámite y retirar tu dinero.',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const DolaritoWidget(
              mood: DolaritoMood.proud,
              message: '¡Lo lograste! Tu crédito ya fue aceptado por ambas partes.',
              compact: true,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFDCF5E8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payments_rounded, color: Color(0xFF16845B)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MONTO SOLICITADO',
                          style: TextStyle(
                            color: Color(0xFF16845B),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          formatCurrency(offer.monto),
                          style: const TextStyle(
                            color: Color(0xFF126B4A),
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${offer.plazoMeses ?? '—'} meses',
                    style: const TextStyle(
                      color: Color(0xFF126B4A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 9),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.05,
              children: [
                _Metric(
                  label: 'INTERÉS ANUAL',
                  value: offer.tasaAnual == null
                      ? '—'
                      : '${offer.tasaAnual!.toStringAsFixed(2)}%',
                ),
                _Metric(
                  label: 'CUOTA MENSUAL',
                  value: offer.cuotaMensual == null
                      ? '—'
                      : formatCurrency(offer.cuotaMensual!),
                ),
                _Metric(
                  label: 'TOTAL A PAGAR',
                  value: offer.totalPagar == null
                      ? '—'
                      : formatCurrency(offer.totalPagar!),
                ),
                _Metric(
                  label: 'INTERÉS TOTAL',
                  value: offer.interesTotal == null
                      ? '—'
                      : formatCurrency(offer.interesTotal!),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpenDocuments,
                icon: const Icon(Icons.list_alt_outlined),
                label: const Text('Ver requisitos'),
              ),
            ),
            const SizedBox(height: 10),
            if (offer.mapsUrl?.isNotEmpty == true) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(offer.mapsUrl!),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Ver ubicación'),
                ),
              ),
              const SizedBox(height: 10),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onPreviewPdf,
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Ver PDF'),
              ),
            ),
          ],
        ),
      ),
      const Positioned.fill(
        child: IgnorePointer(child: _AcceptedCreditConfetti()),
      ),
    ],
  );
}

class _AcceptedCreditConfetti extends StatefulWidget {
  const _AcceptedCreditConfetti();
  @override
  State<_AcceptedCreditConfetti> createState() => _AcceptedCreditConfettiState();
}

class _AcceptedCreditConfettiState extends State<_AcceptedCreditConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) => CustomPaint(
      painter: _AcceptedCreditConfettiPainter(_controller.value),
      child: const SizedBox.expand(),
    ),
  );
}

class _AcceptedCreditConfettiPainter extends CustomPainter {
  const _AcceptedCreditConfettiPainter(this.progress);
  final double progress;
  static const _colors = [
    Color(0xFF16B8A6), Color(0xFF3B82F6), Color(0xFFF4B740),
    Color(0xFFEC6B87), Color(0xFF8B7CF6),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var index = 0; index < 40; index++) {
      final delay = (index % 8) * .045;
      final piece = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);
      final x = ((index * 37) % 101) / 100 * size.width +
          math.sin(piece * math.pi * 2 + index) * 10;
      final y = -7 + piece * (size.height + 14);
      final paint = Paint()
        ..color = _colors[index % _colors.length].withValues(
          alpha: (1 - piece).clamp(0.0, 1.0),
        );
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(piece * 5 + index * .7);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 5, height: 8),
          const Radius.circular(1.5),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _AcceptedCreditConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _CooperativeAvatar extends StatelessWidget {
  const _CooperativeAvatar({required this.logoUrl, this.size = 44});
  final String? logoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(logoUrl ?? '');
    final hasLogo = uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(size * .3),
      ),
      child: hasLogo
          ? Image.network(uri.toString(), fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.account_balance_rounded,
                  color: AppColors.primary))
          : const Icon(Icons.account_balance_rounded, color: AppColors.primary),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: .52),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    ),
  );
}

class _InvestmentRequestsHeading extends StatelessWidget {
  const _InvestmentRequestsHeading();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Mis solicitudes de inversión',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 5),
      const Text(
        'Revisa las condiciones consultadas y las respuestas de cada cooperativa.',
      ),
    ],
  );
}

class _InvestmentRequestCard extends StatelessWidget {
  const _InvestmentRequestCard({required this.request, required this.onTap});
  final InvestmentRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = _investmentStatusLabel(request.status);
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF6FAFC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE3EBF0)),
            boxShadow: const [
              BoxShadow(color: Color(0x10142B4A), blurRadius: 16,
                  offset: Offset(0, 6)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: label.$2,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _CooperativeAvatar(
                          logoUrl: request.cooperativeLogoUrl,
                          size: 46,
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(request.cooperativeName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 3),
                              Text(request.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _OfferStatus(
                          text: label.$1,
                          color: label.$2,
                          soft: label.$2.withValues(alpha: .12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('MONTO INVERTIDO',
                                    style: TextStyle(
                                        color: Color(0xFF087E8B),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 3),
                                Text(formatCurrency(request.amount),
                                    style: const TextStyle(
                                        color: Color(0xFF142B4A),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                          const Icon(Icons.savings_rounded,
                              color: Color(0xFF087E8B), size: 27),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2.05,
                      children: [
                        _Metric(
                          label: 'GANANCIA ESTIMADA',
                          value: request.estimatedInterest == null
                              ? 'Por confirmar'
                              : formatCurrency(request.estimatedInterest!),
                        ),
                        _Metric(
                          label: 'TOTAL ESTIMADO',
                          value: request.estimatedTotal == null
                              ? 'Por confirmar'
                              : formatCurrency(request.estimatedTotal!),
                        ),
                        _Metric(label: 'PLAZO',
                            value: '${request.termMonths} meses'),
                        _Metric(label: 'TASA ANUAL',
                            value: '${request.annualRate.toStringAsFixed(2)}%'),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Solicitada ${_formatInvestmentDate(request.createdAt)} · Actualizada ${_formatInvestmentDate(request.updatedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (request.acceptance != null)
                      const Padding(
                        padding: EdgeInsets.only(top: 9),
                        child: Text(
                          'La cooperativa respondió. Toca para ver agencia y requisitos.',
                          style: TextStyle(color: AppColors.primary,
                              fontSize: 12, fontWeight: FontWeight.w800),
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

class _InvestmentDetailsSheet extends StatelessWidget {
  const _InvestmentDetailsSheet({required this.request});
  final InvestmentRequest request;

  bool _safeMapsUrl(String? value) {
    if (value == null || value.isEmpty) return false;
    final uri = Uri.tryParse(value);
    const hosts = {
      'maps.google.com',
      'www.google.com',
      'google.com',
      'maps.app.goo.gl',
      'goo.gl',
      'www.google.com.ec',
    };
    return uri != null &&
        uri.scheme == 'https' &&
        hosts.contains(uri.host.toLowerCase()) &&
        uri.userInfo.isEmpty;
  }

  Future<void> _openMap(BuildContext context, String? url) async {
    if (!_safeMapsUrl(url)) return;
    final opened = await launchUrl(
      Uri.parse(url!),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo abrir el mapa. Usa la dirección de la agencia mostrada.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final acceptance = request.acceptance;
    return DraggableScrollableSheet(
      initialChildSize: .88,
      minChildSize: .55,
      maxChildSize: .96,
      expand: false,
      builder: (context, controller) => Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              acceptance == null
                  ? 'Detalle de inversión'
                  : '¡Tu solicitud fue aceptada!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            DolaritoWidget(
              mood: acceptance == null
                  ? DolaritoMood.thinking
                  : DolaritoMood.proud,
              message: acceptance == null
                  ? 'Tu solicitud sigue el estado que muestra la cooperativa. Revisa aquí el historial.'
                  : '¡Qué buena noticia! La cooperativa te indicó cómo continuar. La inversión se formaliza directamente con ella.',
              compact: true,
            ),
            const SizedBox(height: 16),
            _InvestmentDetailLine('Cooperativa', request.cooperativeName),
            _InvestmentDetailLine('Producto', request.productName),
            _InvestmentDetailLine(
              'Monto',
              '\$${request.amount.toStringAsFixed(2)}',
            ),
            _InvestmentDetailLine('Plazo', '${request.termMonths} meses'),
            _InvestmentDetailLine(
              'Tasa consultada',
              '${request.annualRate.toStringAsFixed(2)}% anual',
            ),
            if (acceptance?.confirmedAnnualRate != null)
              _InvestmentDetailLine(
                'Tasa confirmada por cooperativa',
                '${acceptance!.confirmedAnnualRate!.toStringAsFixed(2)}% anual',
              ),
            if (request.estimatedInterest != null)
              _InvestmentDetailLine(
                'Interés estimado',
                '\$${request.estimatedInterest!.toStringAsFixed(2)}',
              ),
            _InvestmentDetailLine(
              'Solicitada',
              _formatInvestmentDate(request.createdAt),
            ),
            const SizedBox(height: 16),
            Text(
              'Historial de respuestas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            ...request.events.reversed.map(
              (event) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.circle,
                  size: 12,
                  color: _investmentStatusLabel(event.status).$2,
                ),
                title: Text(_investmentStatusLabel(event.status).$1),
                subtitle: Text(
                  [
                    if (event.note?.isNotEmpty == true) event.note!,
                    _formatInvestmentDate(event.createdAt),
                  ].join('\n'),
                ),
              ),
            ),
            if (acceptance != null) ...[
              const Divider(height: 28),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      acceptance.acceptanceMessage,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      acceptance.agencyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${acceptance.agencyAddress}, ${acceptance.agencyCity}',
                    ),
                    if (acceptance.openingHours?.isNotEmpty == true)
                      _InvestmentDetailLine(
                        'Horario',
                        acceptance.openingHours!,
                      ),
                    if (acceptance.contactDepartment?.isNotEmpty == true)
                      _InvestmentDetailLine(
                        'Contacto',
                        acceptance.contactDepartment!,
                      ),
                    if (acceptance.contactPhone?.isNotEmpty == true)
                      _InvestmentDetailLine(
                        'Teléfono',
                        acceptance.contactPhone!,
                      ),
                    if (acceptance.responseDeadline != null)
                      _InvestmentDetailLine(
                        'Fecha límite',
                        _formatInvestmentDate(acceptance.responseDeadline!),
                      ),
                    if (acceptance.requirements.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      const Text(
                        'Requisitos para presentar',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      ...acceptance.requirements.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                item.mandatory
                                    ? Icons.check_circle
                                    : Icons.info_outline,
                                size: 18,
                                color: item.mandatory
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${item.description} · ${item.mandatory ? 'Obligatorio' : 'Opcional'}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (acceptance.instructions?.isNotEmpty == true) ...[
                      const SizedBox(height: 14),
                      const Text(
                        'Instrucciones',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(acceptance.instructions!),
                    ],
                    if (_safeMapsUrl(acceptance.mapsUrl)) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () =>
                              _openMap(context, acceptance.mapsUrl),
                          icon: const Icon(Icons.directions_rounded),
                          label: const Text('Cómo llegar'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'La aceptación no significa que el depósito esté constituido. Completa la verificación, entrega de documentos y formalización directamente con la cooperativa.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InvestmentDetailLine extends StatelessWidget {
  const _InvestmentDetailLine(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

(String, Color) _investmentStatusLabel(String status) => switch (status) {
  'SUBMITTED' => ('Enviada', const Color(0xFF9B6A14)),
  'IN_REVIEW' => ('En revisión', const Color(0xFF2E6D9D)),
  'INFORMATION_REQUIRED' => ('Requiere información', const Color(0xFF9B6A14)),
  'CONDITIONS_CONFIRMED' => (
    'Aceptada · formalización pendiente',
    AppColors.primary,
  ),
  'DECLINED' => ('Rechazada', const Color(0xFFAA4B4B)),
  _ => ('Estado pendiente', AppColors.textSecondary),
};

String _formatInvestmentDate(DateTime date) =>
    DateFormat('dd/MM/yyyy HH:mm', 'es_EC').format(date.toLocal());
