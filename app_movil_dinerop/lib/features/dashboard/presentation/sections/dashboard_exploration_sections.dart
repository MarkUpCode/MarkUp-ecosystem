import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/formatters.dart';
import '../../../credit/data/models/client_credit_request.dart';
import '../../../credit/data/models/credit_enums.dart';
import '../../../dolarito/models/dolarito_reaction.dart';
import '../../../dolarito/services/dolarito_service.dart';
import '../../../investment/data/models/investment_models.dart';

const _navy = Color(0xFF142B4A);
const _teal = Color(0xFF16B8A6);
const _muted = Color(0xFF718096);
const _line = Color(0xFFE8EDF3);

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
  double _cardHeight = 340;
  final Map<int, double> _measuredCardHeights = {};

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

  void _recordCardHeight(int requestId, Size size) {
    if (!mounted || size.height <= 0) return;
    _measuredCardHeights[requestId] = size.height;
    final active = _activeRequests;
    if (active.isEmpty) return;
    final current = active[_page.clamp(0, active.length - 1)];
    if (current.solicitudId == requestId &&
        (_cardHeight - size.height).abs() > .5) {
      setState(() => _cardHeight = size.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _activeRequests;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (active.isEmpty)
          _CreditEmptyState(onRequestCredit: widget.onRequestCredit)
        else ...[
          SizedBox(
            height: _cardHeight,
            child: PageView.builder(
              controller: _controller,
              itemCount: active.length,
              onPageChanged: (page) {
                setState(() {
                  _page = page;
                  final height = _measuredCardHeights[active[page].solicitudId];
                  if (height != null) _cardHeight = height;
                });
              },
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 9),
                child: LayoutBuilder(
                  builder: (context, constraints) => OverflowBox(
                    alignment: Alignment.topCenter,
                    minWidth: constraints.maxWidth,
                    maxWidth: constraints.maxWidth,
                    minHeight: 0,
                    maxHeight: double.infinity,
                    child: _MeasuredSize(
                      onChange: (size) =>
                          _recordCardHeight(active[index].solicitudId, size),
                      child: _CreditSummaryCard(
                        request: active[index],
                        profileComplete: widget.profileComplete,
                        onViewDetails: () =>
                            widget.onViewDetails(active[index]),
                      ),
                    ),
                  ),
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

class DashboardApplicationsSection extends StatefulWidget {
  const DashboardApplicationsSection({
    super.key,
    required this.creditRequests,
    required this.investmentRequests,
    required this.profileComplete,
    required this.onRequestCredit,
    required this.onRequestInvestment,
    required this.onCreditDetails,
    required this.onInvestmentDetails,
    required this.onRetryCredits,
    required this.onRetryInvestments,
  });

  final AsyncValue<List<ClientCreditRequestSummary>> creditRequests;
  final AsyncValue<List<InvestmentRequest>> investmentRequests;
  final bool profileComplete;
  final VoidCallback onRequestCredit;
  final VoidCallback onRequestInvestment;
  final ValueChanged<ClientCreditRequestSummary> onCreditDetails;
  final ValueChanged<InvestmentRequest> onInvestmentDetails;
  final VoidCallback onRetryCredits;
  final VoidCallback onRetryInvestments;

  @override
  State<DashboardApplicationsSection> createState() =>
      _DashboardApplicationsSectionState();
}

class _DashboardApplicationsSectionState
    extends State<DashboardApplicationsSection> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final investmentsSelected = _selected == 1;
    final title = investmentsSelected ? 'Mis inversiones' : 'Mis créditos';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: _DashboardApplicationSelector(
            selected: _selected,
            onSelected: (value) => setState(() => _selected = value),
          ),
        ),
        const SizedBox(height: 13),
        _SectionHeading(
          title: title,
          subtitle: investmentsSelected
              ? 'Sigue el estado de tus inversiones'
              : 'Conoce cómo avanzan tus solicitudes',
        ),
        const SizedBox(height: 11),
        if (investmentsSelected)
          widget.investmentRequests.when(
            data: (items) => items.isEmpty
                ? _ApplicationEmptyState(
                    message: 'Todavía no tienes inversiones solicitadas.',
                    actionLabel: 'Explorar inversiones',
                    onAction: widget.onRequestInvestment,
                  )
                : _InvestmentRequestCarousel(
                    requests: items,
                    onViewDetails: widget.onInvestmentDetails,
                  ),
            loading: () => const _ApplicationLoadingState(),
            error: (_, _) =>
                _ApplicationErrorState(onRetry: widget.onRetryInvestments),
          )
        else
          widget.creditRequests.when(
            data: (items) => items.isEmpty
                ? _CreditEmptyState(onRequestCredit: widget.onRequestCredit)
                : ActiveCreditCarousel(
                    requests: items,
                    profileComplete: widget.profileComplete,
                    onRequestCredit: widget.onRequestCredit,
                    onViewDetails: widget.onCreditDetails,
                  ),
            loading: () => const _ApplicationLoadingState(),
            error: (_, _) =>
                _ApplicationErrorState(onRetry: widget.onRetryCredits),
          ),
      ],
    );
  }
}

class _DashboardApplicationSelector extends StatelessWidget {
  const _DashboardApplicationSelector({
    required this.selected,
    required this.onSelected,
  });

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 340),
    child: Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF3F4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EBEC)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedAlign(
            alignment: selected == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            child: FractionallySizedBox(
              widthFactor: .5,
              heightFactor: 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14142B4A),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ApplicationSelectorOption(
                label: 'Mis créditos',
                icon: Icons.credit_score_outlined,
                selected: selected == 0,
                onTap: () => onSelected(0),
              ),
              _ApplicationSelectorOption(
                label: 'Mis inversiones',
                icon: Icons.savings_outlined,
                selected: selected == 1,
                onTap: () => onSelected(1),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ApplicationSelectorOption extends StatelessWidget {
  const _ApplicationSelectorOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey('application-selector-$label'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            style: TextStyle(
              color: selected ? _navy : _muted,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
            child: IconTheme(
              data: IconThemeData(
                color: selected ? const Color(0xFF128E80) : _muted,
                size: 17,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  const SizedBox(width: 6),
                  Flexible(child: Text(label, maxLines: 1)),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _ApplicationLoadingState extends StatelessWidget {
  const _ApplicationLoadingState();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 150,
    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
  );
}

class _ApplicationErrorState extends StatelessWidget {
  const _ApplicationErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
    height: 110,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            'No pudimos cargar estas solicitudes.',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    ),
  );
}

class _ApplicationEmptyState extends StatelessWidget {
  const _ApplicationEmptyState({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message, style: const TextStyle(color: _muted, fontSize: 12)),
        const SizedBox(height: 7),
        TextButton.icon(
          onPressed: onAction,
          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
          label: Text(actionLabel),
        ),
      ],
    ),
  );
}

class _InvestmentRequestCarousel extends StatefulWidget {
  const _InvestmentRequestCarousel({
    required this.requests,
    required this.onViewDetails,
  });

  final List<InvestmentRequest> requests;
  final ValueChanged<InvestmentRequest> onViewDetails;

  @override
  State<_InvestmentRequestCarousel> createState() =>
      _InvestmentRequestCarouselState();
}

class _InvestmentRequestCarouselState
    extends State<_InvestmentRequestCarousel> {
  late final PageController _controller = PageController(viewportFraction: .94);
  int _page = 0;
  double _cardHeight = 220;
  final Map<int, double> _measuredCardHeights = {};

  void _recordCardHeight(int requestId, Size size) {
    if (!mounted || size.height <= 0) return;
    _measuredCardHeights[requestId] = size.height;
    final items = widget.requests;
    if (items.isEmpty) return;
    final current = [...items]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (current[_page.clamp(0, current.length - 1)].id == requestId &&
        (_cardHeight - size.height).abs() > .5) {
      setState(() => _cardHeight = size.height);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [...widget.requests]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            height: _cardHeight,
            child: PageView.builder(
              controller: _controller,
              itemCount: items.length,
              onPageChanged: (page) => setState(() {
                _page = page;
                final height = _measuredCardHeights[items[page].id];
                if (height != null) _cardHeight = height;
              }),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 9),
                child: LayoutBuilder(
                  builder: (context, constraints) => OverflowBox(
                    alignment: Alignment.topCenter,
                    minWidth: constraints.maxWidth,
                    maxWidth: constraints.maxWidth,
                    minHeight: 0,
                    maxHeight: double.infinity,
                    child: _MeasuredSize(
                      onChange: (size) =>
                          _recordCardHeight(items[index].id, size),
                      child: _InvestmentSummaryCard(
                        request: items[index],
                        onViewDetails: () => widget.onViewDetails(items[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (items.length > 1) ...[
          const SizedBox(height: 8),
          _CarouselPageIndicator(page: _page, count: items.length),
        ],
      ],
    );
  }
}

class _CarouselPageIndicator extends StatelessWidget {
  const _CarouselPageIndicator({required this.page, required this.count});
  final int page;
  final int count;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var index = 0; index < count; index++)
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: index == page ? 17 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: index == page ? _teal : const Color(0xFFC8D2DE),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      const SizedBox(width: 7),
      Text(
        '${page + 1} de $count',
        style: const TextStyle(
          color: _muted,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _InvestmentSummaryCard extends StatelessWidget {
  const _InvestmentSummaryCard({
    required this.request,
    required this.onViewDetails,
  });

  final InvestmentRequest request;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final reaction = const DolaritoService().investmentRequestStatus(
      request.status,
    );
    final status = _investmentStatus(request.status);
    return _ApplicationCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CooperativeLogo(logoUrl: request.cooperativeLogoUrl),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.cooperativeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _navy, fontSize: 13,
                            fontWeight: FontWeight.w800)),
                    Text('${request.productName} · #${request.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 10)),
                  ],
                ),
              ),
              _StatusPill(label: status.$1, color: status.$2),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFFEAF7F5),
                borderRadius: BorderRadius.circular(15)),
            child: Row(children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MONTO INVERTIDO', style: TextStyle(
                      color: Color(0xFF087E8B), fontSize: 9,
                      fontWeight: FontWeight.w900)),
                  Text(formatCurrency(request.amount), style: const TextStyle(
                      color: _navy, fontSize: 19, fontWeight: FontWeight.w900)),
                ],
              )),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text('GANANCIA ESTIMADA', style: TextStyle(
                    color: _muted, fontSize: 8, fontWeight: FontWeight.w900)),
                Text(request.estimatedInterest == null ? 'Por confirmar' :
                    formatCurrency(request.estimatedInterest!),
                    style: const TextStyle(color: Color(0xFF16845B),
                        fontSize: 12, fontWeight: FontWeight.w900)),
              ]),
            ]),
          ),
          const SizedBox(height: 6),
          Text('${request.termMonths} meses · ${request.annualRate.toStringAsFixed(2)}% anual · ${request.interestPaymentOption ?? 'Intereses según oferta'}',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _muted, fontSize: 9)),
          const SizedBox(height: 7),
          _InvestmentProgress(request: request),
          const SizedBox(height: 7),
          _DolaritoRequestNote(reaction: reaction),
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
              child: const Text('Ver detalles  →'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CooperativeLogo extends StatelessWidget {
  const _CooperativeLogo({required this.logoUrl, this.size = 42});
  final String? logoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(logoUrl ?? '');
    final valid = uri != null && (uri.scheme == 'https' || uri.scheme == 'http') && uri.host.isNotEmpty;
    return Container(
      width: size, height: size, clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: const Color(0xFFEAF0F5),
          borderRadius: BorderRadius.circular(size * .3)),
      child: valid
          ? Image.network(uri.toString(), fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.account_balance_rounded, color: _navy))
          : const Icon(Icons.account_balance_rounded, color: _navy),
    );
  }
}

class _InvestmentProgress extends StatelessWidget {
  const _InvestmentProgress({required this.request});
  final InvestmentRequest request;

  @override
  Widget build(BuildContext context) {
    final status = request.status.toUpperCase();
    final declined = status == 'DECLINED';
    final step = switch (status) {
      'CONDITIONS_CONFIRMED' => 3,
      'INFORMATION_REQUIRED' => 2,
      'SUBMITTED' || 'IN_REVIEW' => 1,
      _ => 1,
    };
    final message = switch (status) {
      'CONDITIONS_CONFIRMED' => 'Acércate a la cooperativa para continuar.',
      'INFORMATION_REQUIRED' => 'Revisa los requisitos solicitados por la cooperativa.',
      'DECLINED' => 'La cooperativa no aceptó esta solicitud.',
      _ => 'La cooperativa está revisando y preparando los requisitos.',
    };
    final color = declined ? const Color(0xFFB42318) : _teal;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        for (var index = 1; index <= 3; index++) ...[
          Container(width: 20, height: 20, alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle,
                color: declined && index == step ? color : index <= step ? color : const Color(0xFFD9E2EA)),
            child: Icon(declined && index == step ? Icons.close_rounded :
                index == 3 && status == 'CONDITIONS_CONFIRMED' ? Icons.account_balance_rounded :
                index < step ? Icons.check_rounded : Icons.circle,
                color: Colors.white, size: index < step || declined && index == step ? 13 : 8)),
          if (index < 3) Expanded(child: Container(height: 2,
              color: index < step ? color : const Color(0xFFD9E2EA))),
        ],
      ]),
      const SizedBox(height: 3),
      const Row(children: [
        Expanded(child: Text('Solicitud', style: TextStyle(color: _muted, fontSize: 8))),
        Expanded(child: Text('Requisitos', textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 8))),
        Expanded(child: Text('Cooperativa', textAlign: TextAlign.right,
            style: TextStyle(color: _muted, fontSize: 8))),
      ]),
      const SizedBox(height: 4),
      Row(children: [
        Icon(status == 'CONDITIONS_CONFIRMED' ? Icons.place_rounded : Icons.info_outline_rounded,
            size: 13, color: color),
        const SizedBox(width: 4),
        Expanded(child: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: declined ? color : _navy, fontSize: 9,
                fontWeight: FontWeight.w700))),
      ]),
    ]);
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(13, 12, 13, 5),
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
    child: child,
  );
}

class _DolaritoRequestNote extends StatelessWidget {
  const _DolaritoRequestNote({required this.reaction});
  final DolaritoReaction reaction;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFEFF9F4),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      children: [
        Image.asset(
          'assets/images/dolarito/${reaction.mood.assetName}',
          width: 38,
          height: 38,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            reaction.message,
            style: const TextStyle(
              color: _navy,
              fontSize: 12,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class _MeasuredSize extends SingleChildRenderObjectWidget {
  const _MeasuredSize({required this.onChange, required super.child});

  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasuredSize(onChange);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMeasuredSize renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class _RenderMeasuredSize extends RenderProxyBox {
  _RenderMeasuredSize(this.onChange);

  ValueChanged<Size> onChange;
  Size? _reportedSize;

  @override
  void performLayout() {
    super.performLayout();
    if (_reportedSize == size) return;
    _reportedSize = size;
    final measured = size;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (attached) onChange(measured);
    });
  }
}

(String, Color) _investmentStatus(String status) => switch (status
    .toUpperCase()) {
  'SUBMITTED' => ('Enviada', const Color(0xFF9A5B00)),
  'IN_REVIEW' => ('En revisión', const Color(0xFF087E8B)),
  'INFORMATION_REQUIRED' => ('Requiere información', const Color(0xFF9A5B00)),
  'CONDITIONS_CONFIRMED' => (
    'Condiciones confirmadas',
    const Color(0xFF16845B),
  ),
  'DECLINED' => ('No aceptada', const Color(0xFFB42318)),
  _ => ('Pendiente', const Color(0xFF667085)),
};

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      maxLines: 1,
      style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900),
    ),
  );
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
    final reaction = const DolaritoService().creditStatus(
      request.estado,
      requestId: request.solicitudId,
    );
    final status = _CreditStatus.from(request.estado);
    final step = _progressStep(request.estado, profileComplete);
    final rejected = request.estado == CreditRequestStatus.rechazada;

    return _ApplicationCard(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 2),
              Text(
                formatCurrency(request.monto),
                style: const TextStyle(
                  color: _navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.4,
                ),
              ),
              const SizedBox(height: 0),
              Text(
                '${request.tipo.toLowerCase() == 'microcredito' ? 'Microcrédito' : 'Crédito'} · ${request.cantidadSolicitudesEnviadas} cooperativas notificadas',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _muted, fontSize: 10),
              ),
              const SizedBox(height: 2),
              Text(
                'Solicitado el ${formatDate(request.fechaSolicitud)}',
                style: const TextStyle(color: _muted, fontSize: 9),
              ),
              const SizedBox(height: 3),
              _CreditStepper(
                step: step,
                rejected: rejected,
                accepted: request.estado == CreditRequestStatus.aceptada,
              ),
              if (request.estado == CreditRequestStatus.aceptada) ...[
                const SizedBox(height: 4),
                const Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.account_balance_rounded, size: 13,
                      color: Color(0xFF16845B)),
                  SizedBox(width: 4),
                  Text('Acércate a la cooperativa para retirar tu crédito',
                      style: TextStyle(color: Color(0xFF16845B), fontSize: 9,
                          fontWeight: FontWeight.w800)),
                ]),
              ],
              const SizedBox(height: 2),
              const SizedBox(height: 5),
              _DolaritoRequestNote(reaction: reaction),
              const SizedBox(height: 3),
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
          if (request.estado == CreditRequestStatus.aceptada)
            Positioned.fill(
              child: IgnorePointer(
                child: _CelebrationConfetti(key: ValueKey(request.solicitudId)),
              ),
            ),
        ],
      ),
    );
  }
}

class _CreditStepper extends StatelessWidget {
  const _CreditStepper({required this.step, required this.rejected, required this.accepted});

  final int step;
  final bool rejected;
  final bool accepted;

  static const _labels = ['Perfil', 'Solicitud', 'Evaluación', 'Resultado'];

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 24,
        child: Row(
          children: [
            for (var index = 1; index <= _labels.length; index++) ...[
              _StepDot(index: index, step: step, rejected: rejected, accepted: accepted),
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
      const SizedBox(height: 2),
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
    required this.accepted,
  });

  final int index;
  final int step;
  final bool rejected;
  final bool accepted;

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
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: current ? Colors.white : color,
          width: current ? 2 : 1,
        ),
      ),
      child: Icon(
        accepted && index == 4
            ? Icons.account_balance_rounded
            : complete
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
              onTap: () => context.push('/simulate-investment'),
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
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color tint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    key: ValueKey('quick-action-$label'),
    color: tint,
    borderRadius: BorderRadius.circular(17),
    child: InkWell(
      onTap: onTap,
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

class _CelebrationConfetti extends StatefulWidget {
  const _CelebrationConfetti({super.key});

  @override
  State<_CelebrationConfetti> createState() => _CelebrationConfettiState();
}

class _CelebrationConfettiState extends State<_CelebrationConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
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
      key: const ValueKey('accepted-credit-confetti'),
      painter: _ConfettiPainter(_controller.value),
      child: const SizedBox.expand(),
    ),
  );
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter(this.progress);

  final double progress;
  static const _colors = [
    Color(0xFF16B8A6),
    Color(0xFF3B82F6),
    Color(0xFFF4B740),
    Color(0xFFEC6B87),
    Color(0xFF8B7CF6),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var index = 0; index < 32; index++) {
      final delay = (index % 8) * .055;
      final pieceProgress = ((progress - delay) / (1 - delay)).clamp(0.0, 1.0);
      final direction = index.isEven ? 1.0 : -1.0;
      final startX = ((index * 37) % 101) / 100 * size.width;
      final x =
          startX +
          math.sin(pieceProgress * math.pi * 2 + index) * 12 +
          direction * pieceProgress * 18;
      final y = -8 + pieceProgress * (size.height + 18);
      final fade = (1 - pieceProgress).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = _colors[index % _colors.length].withValues(alpha: fade);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(pieceProgress * 5 + index * .7);
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
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
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
          '¡Felicidades! Tu crédito fue aceptado. Revisa los requisitos para retirarlo.',
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
