import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

class RequestsPage extends ConsumerStatefulWidget {
  const RequestsPage({super.key});

  @override
  ConsumerState<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends ConsumerState<RequestsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  CreditRequestStatus? _statusFilter;
  String? _typeFilter;

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
      final matchesSearch = query.isEmpty ||
          request.solicitudId.toString().contains(query) ||
          request.monto.toString().contains(query);
      final matchesStatus =
          _statusFilter == null || request.estado == _statusFilter;
      final matchesType = _typeFilter == null ||
          request.tipo.toUpperCase() == _typeFilter;
      return matchesSearch && matchesStatus && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final requests = ref.watch(requestsProvider);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: requests.when(
          data: (items) {
            final filteredItems = _filteredRequests(items);
            return RefreshIndicator(
            onRefresh: () async => ref.invalidate(requestsProvider),
            child: items.isEmpty
                ? ListView(
                    children: [
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
                                    selected: _statusFilter == null &&
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
                                      padding: const EdgeInsets.only(right: 8),
                                      child: FilterChip(
                                        label: Text(filter.label),
                                        selected: _statusFilter == filter.value,
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
                                child: Text('No hay solicitudes con esos filtros.'),
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
          error: (error, _) => AppErrorView(
            message: error is AppException
                ? error.message
                : AppErrorMessages.generic,
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
                        'Ofertas de cooperativas',
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
            if (offers.isEmpty)
              _NoOffersCard(request: request)
            else ...[
              Center(
                child: Text(
                  '${offers.length} ${offers.length == 1 ? 'respuesta disponible' : 'respuestas disponibles'}',
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
      if (mounted) Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    final needsGuarantor =
        offer.estado == CreditRequestStatus.solicitandoGarante;
    final color = needsGuarantor ? AppColors.warning : AppColors.success;
    final soft = needsGuarantor ? AppColors.warningSoft : AppColors.successSoft;
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
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.account_balance_rounded,
                        color: AppColors.primary,
                      ),
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
                          : offer.estado == CreditRequestStatus.aceptada
                          ? 'Aceptada'
                          : 'Preaprobada',
                      color: color,
                      soft: soft,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (needsGuarantor)
                  _GuarantorNotice(color: color, soft: soft),
                if (needsGuarantor) const SizedBox(height: 12),
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
                              '/guarantor-onboarding',
                            );
                            if (!mounted || completed != true) return;
                            ref.invalidate(requestsProvider);
                            ref.invalidate(dashboardCreditRequestsProvider);
                            Navigator.of(this.context).pop();
                          }
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
                          ? 'Completar información del garante'
                          : _accepting
                          ? 'Aceptando oferta...'
                          : 'Aceptar esta oferta',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
  const _GuarantorNotice({required this.color, required this.soft});
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
        Icon(Icons.group_add_rounded, color: color),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Requiere garante',
                style: TextStyle(color: color, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 3),
              Text(
                'La cooperativa necesita un garante para avanzar con tu solicitud.',
                style: TextStyle(
                  color: color.withValues(alpha: .9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
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
