import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/formatters.dart';
import '../../../credit/data/models/client_credit_request.dart';
import '../../../credit/data/models/credit_enums.dart';

const _navy = Color(0xFF142B4A);
const _teal = Color(0xFF16B8A6);
const _muted = Color(0xFF718096);
const _line = Color(0xFFE8EDF3);

class ProfileStatusRow extends StatelessWidget {
  const ProfileStatusRow({super.key, required this.complete, this.onComplete});

  final bool complete;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    if (complete) {
      return Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: _teal, size: 17),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Perfil completo',
              style: TextStyle(
                color: _navy,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F8F5),
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              '100%',
              style: TextStyle(
                color: _teal,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        const Icon(Icons.pending_outlined, color: Color(0xFFD68B28), size: 17),
        const SizedBox(width: 6),
        const Expanded(
          child: Text(
            'Completa tu información de perfil',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
        ),
        TextButton(
          onPressed: onComplete,
          style: TextButton.styleFrom(
            foregroundColor: _navy,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 32),
          ),
          child: const Text(
            'Completar',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class ActiveCreditCarousel extends StatefulWidget {
  const ActiveCreditCarousel({
    super.key,
    required this.requests,
    required this.profileComplete,
    required this.onRequestCredit,
    required this.onViewDetails,
  });

  final List<ClientCreditRequestSummary> requests;
  final bool profileComplete;
  final VoidCallback onRequestCredit;
  final ValueChanged<ClientCreditRequestSummary> onViewDetails;

  @override
  State<ActiveCreditCarousel> createState() => _ActiveCreditCarouselState();
}

class _ActiveCreditCarouselState extends State<ActiveCreditCarousel> {
  late final PageController _controller;
  int _page = 0;

  List<ClientCreditRequestSummary> get _activeRequests {
    final active = widget.requests.toList()
      ..sort(
        (a, b) => (b.fechaSolicitud ?? DateTime(0)).compareTo(
          a.fechaSolicitud ?? DateTime(0),
        ),
      );
    return active;
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: .94);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _activeRequests;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Mi último crédito',
          subtitle: 'Conoce cómo avanza tu solicitud',
        ),
        const SizedBox(height: 12),
        if (active.isEmpty)
          _CreditEmptyState(onRequestCredit: widget.onRequestCredit)
        else ...[
          SizedBox(
            height: 252,
            child: PageView.builder(
              controller: _controller,
              itemCount: active.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 9),
                child: _CreditSummaryCard(
                  request: active[index],
                  profileComplete: widget.profileComplete,
                  onViewDetails: () => widget.onViewDetails(active[index]),
                ),
              ),
            ),
          ),
          if (active.length > 1) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 0; index < active.length; index++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: index == _page ? 17 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == _page ? _teal : const Color(0xFFC8D2DE),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                const SizedBox(width: 7),
                Text(
                  '${_page + 1} de ${active.length}',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }
}

class _CreditSummaryCard extends StatelessWidget {
  const _CreditSummaryCard({
    required this.request,
    required this.profileComplete,
    required this.onViewDetails,
  });

  final ClientCreditRequestSummary request;
  final bool profileComplete;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final status = _CreditStatus.from(request.estado);
    final step = _progressStep(request.estado, profileComplete);
    final rejected = request.estado == CreditRequestStatus.rechazada;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF5FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFE4EBF1)),
        borderRadius: BorderRadius.circular(21),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D142B4A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Solicitud #${request.solicitudId}',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: status.color.withValues(alpha: .17),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  status.shortTitle,
                  style: TextStyle(
                    color: status.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            formatCurrency(request.monto),
            style: const TextStyle(
              color: _navy,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -.4,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            'Solicitado el ${formatDate(request.fechaSolicitud)}',
            style: const TextStyle(color: _muted, fontSize: 10),
          ),
          const SizedBox(height: 4),
          _CreditStepper(step: step, rejected: rejected),
          const SizedBox(height: 3),
          Text(
            status.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _navy, fontSize: 11, height: 1.35),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onViewDetails,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF087E8B),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: const Size(0, 28),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              child: const Text(
                'Ver detalles  →',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditStepper extends StatelessWidget {
  const _CreditStepper({required this.step, required this.rejected});

  final int step;
  final bool rejected;

  static const _labels = ['Perfil', 'Solicitud', 'Evaluación', 'Resultado'];

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 28,
        child: Row(
          children: [
            for (var index = 1; index <= _labels.length; index++) ...[
              _StepDot(index: index, step: step, rejected: rejected),
              if (index < _labels.length)
                Expanded(
                  child: Container(
                    height: 2,
                    color: index < step ? _teal : const Color(0xFFD9E2EA),
                  ),
                ),
            ],
          ],
        ),
      ),
      const SizedBox(height: 4),
      Row(
        children: [
          for (var index = 0; index < _labels.length; index++)
            Expanded(
              child: Text(
                _labels[index],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: index + 1 == step && rejected
                      ? const Color(0xFFB42318)
                      : index + 1 <= step
                      ? _navy
                      : const Color(0xFF98A2B3),
                  fontSize: 8,
                  fontWeight: index + 1 == step
                      ? FontWeight.w900
                      : FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    ],
  );
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.index,
    required this.step,
    required this.rejected,
  });

  final int index;
  final int step;
  final bool rejected;

  @override
  Widget build(BuildContext context) {
    final complete = index < step;
    final current = index == step;
    final color = rejected && current
        ? const Color(0xFFFF8888)
        : (complete || current)
        ? _teal
        : const Color(0xFFD9E2EA);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: current ? Colors.white : color,
          width: current ? 2 : 1,
        ),
      ),
      child: Icon(
        complete
            ? Icons.check_rounded
            : rejected && current
            ? Icons.close_rounded
            : Icons.circle,
        color: Colors.white,
        size: complete || rejected && current ? 14 : 8,
      ),
    );
  }
}

class _CreditEmptyState extends StatelessWidget {
  const _CreditEmptyState({required this.onRequestCredit});

  final VoidCallback onRequestCredit;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
      border: Border.all(color: _line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE7F8F5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.account_balance_wallet_outlined,
            color: _teal,
          ),
        ),
        const SizedBox(height: 11),
        const Text(
          '¡Comienza tu camino financiero!',
          style: TextStyle(
            color: _navy,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Solicita tu primer crédito y descubre nuevas oportunidades.',
          style: TextStyle(color: _muted, fontSize: 11, height: 1.4),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: onRequestCredit,
          style: FilledButton.styleFrom(
            backgroundColor: _navy,
            minimumSize: const Size(0, 40),
          ),
          child: const Text('Solicitar crédito'),
        ),
      ],
    ),
  );
}

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _SectionHeading(title: '¿Qué quieres hacer?'),
      const SizedBox(height: 11),
      LayoutBuilder(
        builder: (context, constraints) => GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 9,
          mainAxisSpacing: 9,
          childAspectRatio: constraints.maxWidth < 300 ? .82 : 1.03,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _ActionTile(
              icon: Icons.add_card_rounded,
              label: 'Solicitar crédito',
              color: const Color(0xFF16B8A6),
              tint: const Color(0xFFE5F8F5),
              onTap: () => context.push('/request-credit'),
            ),
            _ActionTile(
              icon: Icons.savings_outlined,
              label: 'Realizar inversión',
              color: const Color(0xFF7656C8),
              tint: const Color(0xFFF0ECFA),
              comingSoon: true,
            ),
            _ActionTile(
              icon: Icons.fact_check_outlined,
              label: 'Revisar buró',
              color: const Color(0xFF3979CC),
              tint: const Color(0xFFEAF2FD),
              onTap: () => context.push('/credit-bureau'),
            ),
            _ActionTile(
              icon: Icons.receipt_long_rounded,
              label: 'Mis solicitudes',
              color: const Color(0xFFE58C39),
              tint: const Color(0xFFFFF2E5),
              onTap: () => context.go('/requests'),
            ),
            _ActionTile(
              icon: Icons.calculate_outlined,
              label: 'Simulador',
              color: const Color(0xFF3A9B68),
              tint: const Color(0xFFE8F6EE),
              onTap: () => context.push('/simulate-credit'),
            ),
            _ActionTile(
              icon: Icons.person_outline_rounded,
              label: 'Mi perfil',
              color: const Color(0xFF5B7792),
              tint: const Color(0xFFEDF2F6),
              onTap: () => context.go('/profile'),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.tint,
    this.onTap,
    this.comingSoon = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color tint;
  final VoidCallback? onTap;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) => Material(
    key: ValueKey('quick-action-$label'),
    color: tint,
    borderRadius: BorderRadius.circular(17),
    child: InkWell(
      onTap:
          onTap ??
          (comingSoon
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Las inversiones estarán disponibles próximamente.',
                    ),
                  ),
                )
              : null),
      borderRadius: BorderRadius.circular(17),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: color.withValues(alpha: .10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 7),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _navy,
                fontSize: 10,
                height: 1.15,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (comingSoon) ...[
              const SizedBox(height: 3),
              Text(
                'PRÓXIMAMENTE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 7,
                  letterSpacing: .35,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class RecentCreditActivity extends StatelessWidget {
  const RecentCreditActivity({
    super.key,
    required this.requests,
    required this.onViewAll,
    required this.onOpenRequest,
  });

  final List<ClientCreditRequestSummary> requests;
  final VoidCallback onViewAll;
  final ValueChanged<ClientCreditRequestSummary> onOpenRequest;

  @override
  Widget build(BuildContext context) {
    final recent = [...requests]
      ..sort(
        (a, b) => (b.fechaSolicitud ?? DateTime(0)).compareTo(
          a.fechaSolicitud ?? DateTime(0),
        ),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: _SectionHeading(title: 'Tu actividad reciente'),
            ),
            if (recent.isNotEmpty)
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(foregroundColor: _teal),
                child: const Text(
                  'Ver todo  →',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
          ],
        ),
        const SizedBox(height: 9),
        if (recent.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: _line),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Text(
              'Tus solicitudes aparecerán aquí.',
              style: TextStyle(color: _muted, fontSize: 12),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _line),
            ),
            child: Column(
              children: [
                for (var index = 0; index < recent.take(5).length; index++) ...[
                  _ActivityTile(
                    request: recent[index],
                    onTap: () => onOpenRequest(recent[index]),
                  ),
                  if (index < recent.take(5).length - 1)
                    const Divider(
                      height: 1,
                      indent: 58,
                      endIndent: 14,
                      color: _line,
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.request, required this.onTap});

  final ClientCreditRequestSummary request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = _CreditStatus.from(request.estado);
    final label = request.tipo.trim().isEmpty
        ? 'Crédito'
        : request.tipo.toLowerCase() == 'credito'
        ? 'Crédito'
        : request.tipo;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.account_balance_outlined,
                color: Color(0xFF3979CC),
                size: 19,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$label · #${request.solicitudId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${formatDate(request.fechaSolicitud)}  ·  ${formatCurrency(request.monto)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _muted, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                color: status.color.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                status.shortTitle,
                maxLines: 1,
                style: TextStyle(
                  color: status.color,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int _progressStep(CreditRequestStatus status, bool profileComplete) {
  if (status == CreditRequestStatus.aceptada ||
      status == CreditRequestStatus.rechazada) {
    return 4;
  }
  if (!profileComplete) return 0;
  switch (status) {
    case CreditRequestStatus.creada:
      return 2;
    case CreditRequestStatus.enviada:
    case CreditRequestStatus.solicitandoGarante:
      return 3;
    case CreditRequestStatus.preAprobada:
    case CreditRequestStatus.aceptada:
    case CreditRequestStatus.rechazada:
      return 4;
    case CreditRequestStatus.unknown:
      return 2;
  }
}

class _CreditStatus {
  const _CreditStatus(this.shortTitle, this.message, this.color);

  final String shortTitle;
  final String message;
  final Color color;

  factory _CreditStatus.from(CreditRequestStatus status) {
    switch (status) {
      case CreditRequestStatus.creada:
        return const _CreditStatus(
          'Creada',
          'Tu solicitud está creada. Revisa los detalles para ver si falta completar algún paso.',
          Color(0xFF9A5B00),
        );
      case CreditRequestStatus.enviada:
        return const _CreditStatus(
          'En evaluación',
          'La cooperativa está revisando tu solicitud. Te avisaremos cuando haya novedades.',
          Color(0xFF087E8B),
        );
      case CreditRequestStatus.solicitandoGarante:
        return const _CreditStatus(
          'Garante requerido',
          'Se requiere un garante. Abre los detalles para conocer cómo continuar.',
          Color(0xFF9A5B00),
        );
      case CreditRequestStatus.preAprobada:
        return const _CreditStatus(
          'Preaprobada',
          'Tienes una propuesta disponible. Revisa sus condiciones y los pasos para aceptarla.',
          Color(0xFF16845B),
        );
      case CreditRequestStatus.aceptada:
        return const _CreditStatus(
          'Aceptada',
          'Tu crédito fue aceptado. Consulta los detalles para conocer los siguientes pasos.',
          Color(0xFF16845B),
        );
      case CreditRequestStatus.rechazada:
        return const _CreditStatus(
          'Rechazada',
          'Esta solicitud fue rechazada. Consulta los motivos y el detalle de esta decisión.',
          Color(0xFFB42318),
        );
      case CreditRequestStatus.unknown:
        return const _CreditStatus(
          'En proceso',
          'Consulta los detalles para ver el estado y la información más reciente.',
          Color(0xFF667085),
        );
    }
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: _navy,
          fontSize: 17,
          fontWeight: FontWeight.w900,
          letterSpacing: -.2,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 3),
        Text(
          subtitle!,
          style: const TextStyle(color: _muted, fontSize: 11, height: 1.3),
        ),
      ],
    ],
  );
}
