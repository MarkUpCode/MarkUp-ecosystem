import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../credit/data/models/client_credit_request.dart';
import '../../credit/data/models/credit_cooperative_status.dart';
import '../../credit/data/models/credit_enums.dart';

class RequestsPage extends ConsumerWidget {
  const RequestsPage({super.key});

  Future<void> _showDetails(BuildContext context, WidgetRef ref, ClientCreditRequestSummary request) async {
    final repo = ref.read(creditRepositoryProvider);
    final cooperatives = await repo.loadPreApprovedCooperatives(request.solicitudId);

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.82,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  Text('Solicitud #${request.solicitudId}', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(formatCurrency(request.monto), style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  AppBadge(label: request.estado.name.toUpperCase()),
                  const SizedBox(height: 20),
                  Text('Cooperativas notificadas', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  if (cooperatives.isEmpty)
                    const AppEmptyState(
                      title: 'Sin cooperativas aún',
                      message: 'El backend todavía no devolvió cooperativas para esta solicitud.',
                      icon: Icons.apartment_outlined,
                    )
                  else
                    ...cooperatives.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CooperativeStatusCard(
                          item: item,
                          onAccept: item.estado == CreditRequestStatus.preAprobada
                              ? () async {
                                  await repo.acceptCooperative(solicitudId: request.solicitudId, cooperativaId: item.cooperativaId);
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                  ref.invalidate(requestsProvider);
                                }
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis solicitudes')),
      body: SafeArea(
        child: requestsAsync.when(
          data: (requests) {
            if (requests.isEmpty) {
              return AppEmptyState(
                title: 'Todavía no tienes solicitudes',
                message: 'Crea tu primera solicitud para ver el seguimiento aquí.',
                actionLabel: 'Solicitar crédito',
                onAction: () => context.push('/request-credit'),
                icon: Icons.receipt_long_outlined,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final request = requests[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => _showDetails(context, ref, request),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatCurrency(request.monto), style: Theme.of(context).textTheme.headlineSmall),
                            AppBadge(label: request.estado.name.toUpperCase()),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(request.tipo, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text(formatDate(request.fechaSolicitud), style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const AppLoader(label: 'Cargando solicitudes...'),
          error: (error, stackTrace) => AppErrorView(message: error is AppException ? error.message : AppErrorMessages.generic),
        ),
      ),
    );
  }
}

class _CooperativeStatusCard extends StatelessWidget {
  const _CooperativeStatusCard({required this.item, this.onAccept});

  final CreditCooperativeStatus item;
  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.nombreCooperativa, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          AppBadge(label: item.estado.name.toUpperCase()),
          const SizedBox(height: 10),
          Text('Monto: ${formatCurrency(item.monto)}', style: Theme.of(context).textTheme.bodySmall),
          Text('Plazo: ${item.plazoMeses ?? '-'} meses', style: Theme.of(context).textTheme.bodySmall),
          if (item.tasaAnual != null) Text('Tasa: ${item.tasaAnual!.toStringAsFixed(2)}%', style: Theme.of(context).textTheme.bodySmall),
          if (item.cuotaMensual != null) Text('Cuota: ${formatCurrency(item.cuotaMensual!)}', style: Theme.of(context).textTheme.bodySmall),
          if (item.totalPagar != null) Text('Total: ${formatCurrency(item.totalPagar!)}', style: Theme.of(context).textTheme.bodySmall),
          if (item.interesTotal != null) Text('Interés: ${formatCurrency(item.interesTotal!)}', style: Theme.of(context).textTheme.bodySmall),
          if (onAccept != null) ...[
            const SizedBox(height: 12),
            AppButton(label: 'Aceptar cooperativa', icon: Icons.check_circle_rounded, onPressed: onAccept),
          ],
        ],
      ),
    );
  }
}