import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/client_credit_request.dart';
import '../../data/models/credit_enums.dart';

class CreditRequestCard extends StatelessWidget {
  const CreditRequestCard({
    super.key,
    required this.request,
    this.onTap,
    this.compact = false,
  });

  final ClientCreditRequestSummary request;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style = _RequestStyle.from(request.estado);
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: theme.brightness == Brightness.light
                ? const [
                    BoxShadow(
                      color: Color(0x120F172A),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 5, color: style.color),
              Padding(
                padding: EdgeInsets.all(compact ? 18 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: style.softColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            request.tipo.toUpperCase() == 'INVERSION'
                                ? Icons.trending_up_rounded
                                : Icons.account_balance_wallet_rounded,
                            color: style.color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                request.tipo.toUpperCase() == 'INVERSION'
                                    ? 'Inversión'
                                    : 'Solicitud de crédito',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Solicitud #${request.solicitudId} · ${formatDate(request.fechaSolicitud)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        _StatusPill(style: style),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: style.softColor.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MONTO SOLICITADO',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: style.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatCurrency(request.monto),
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: style.color,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.payments_outlined, color: style.color),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _DetailChip(
                            icon: Icons.apartment_rounded,
                            label: request.cantidadSolicitudesEnviadas == 1
                                ? '1 cooperativa'
                                : '${request.cantidadSolicitudesEnviadas} cooperativas',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _DetailChip(
                            icon: style.icon,
                            label: style.description,
                          ),
                        ),
                      ],
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              style.helperText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, color: style.color),
                        ],
                      ),
                    ],
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.style});
  final _RequestStyle style;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: style.softColor,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(style.icon, size: 13, color: style.color),
        const SizedBox(width: 4),
        Text(
          style.label,
          style: TextStyle(
            color: style.color,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .48),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestStyle {
  const _RequestStyle(
    this.label,
    this.description,
    this.helperText,
    this.color,
    this.softColor,
    this.icon,
  );
  final String label;
  final String description;
  final String helperText;
  final Color color;
  final Color softColor;
  final IconData icon;

  factory _RequestStyle.from(CreditRequestStatus status) {
    switch (status) {
      case CreditRequestStatus.preAprobada:
        return const _RequestStyle(
          'Preaprobada',
          'Ofertas disponibles',
          'Tienes una oferta lista para revisar.',
          AppColors.success,
          AppColors.successSoft,
          Icons.verified_rounded,
        );
      case CreditRequestStatus.solicitandoGarante:
        return const _RequestStyle(
          'Requiere garante',
          'Acción requerida',
          'Una cooperativa necesita datos de un garante.',
          AppColors.warning,
          AppColors.warningSoft,
          Icons.group_add_rounded,
        );
      case CreditRequestStatus.rechazada:
        return const _RequestStyle(
          'No aprobada',
          'Sin ofertas',
          'Por ahora no hay una oferta disponible.',
          AppColors.error,
          AppColors.errorSoft,
          Icons.cancel_outlined,
        );
      case CreditRequestStatus.aceptada:
        return const _RequestStyle(
          'Aceptada',
          'Cooperativa elegida',
          'Ya seleccionaste una cooperativa.',
          AppColors.success,
          AppColors.successSoft,
          Icons.handshake_rounded,
        );
      case CreditRequestStatus.enviada:
        return const _RequestStyle(
          'En evaluación',
          'Enviada',
          'Las cooperativas están revisando tu solicitud.',
          AppColors.info,
          AppColors.infoSoft,
          Icons.hourglass_top_rounded,
        );
      case CreditRequestStatus.creada:
        return const _RequestStyle(
          'Perfil pendiente',
          'Sin enviar',
          'Completa tu perfil para enviarla a cooperativas.',
          AppColors.primary,
          AppColors.primaryContainer,
          Icons.person_outline_rounded,
        );
      case CreditRequestStatus.unknown:
        return const _RequestStyle(
          'En proceso',
          'Actualizando',
          'Estamos actualizando el estado de tu solicitud.',
          AppColors.textSecondary,
          AppColors.surfaceVariant,
          Icons.schedule_rounded,
        );
    }
  }
}
