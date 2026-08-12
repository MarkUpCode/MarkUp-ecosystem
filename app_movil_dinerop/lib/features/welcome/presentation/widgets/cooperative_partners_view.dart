import 'package:flutter/material.dart';

import '../../data/models/cooperative_partner.dart';
import 'cooperative_logo_card.dart';

class CooperativePartnersView extends StatefulWidget {
  const CooperativePartnersView({
    super.key,
    this.partners = CooperativePartner.initialPartners,
  });

  final List<CooperativePartner> partners;

  @override
  State<CooperativePartnersView> createState() =>
      _CooperativePartnersViewState();
}

class _CooperativePartnersViewState extends State<CooperativePartnersView>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _titleFade;
  late Animation<double> _subtitleFade;

  late AnimationController _itemsController;
  final List<Animation<double>> _itemFades = [];
  final List<Animation<Offset>> _itemSlides = [];

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _titleFade = CurvedAnimation(
      parent: _headerController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _subtitleFade = CurvedAnimation(
      parent: _headerController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    final itemCount = widget.partners.length;
    _itemsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + (itemCount * 220)),
    );

    for (int i = 0; i < itemCount; i++) {
      final double start = (i * 0.2).clamp(0.0, 0.8);
      final double end = (start + 0.4).clamp(0.0, 1.0);

      _itemFades.add(CurvedAnimation(
        parent: _itemsController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ));

      _itemSlides.add(Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _itemsController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      )));
    }

    _headerController.forward().then((_) {
      if (mounted) {
        _itemsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _itemsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 2),

          // Header Icon Badge
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.apartment_rounded,
                color: theme.colorScheme.primary,
                size: 36,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          FadeTransition(
            opacity: _titleFade,
            child: Text(
              'Cooperativas participantes',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          FadeTransition(
            opacity: _subtitleFade,
            child: Text(
              'Encuentra opciones de crédito en un solo lugar.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Staggered list of logos
          Expanded(
            flex: 6,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.partners.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final partner = widget.partners[index];
                final fade = index < _itemFades.length
                    ? _itemFades[index]
                    : const AlwaysStoppedAnimation(1.0);
                final slide = index < _itemSlides.length
                    ? _itemSlides[index]
                    : const AlwaysStoppedAnimation(Offset.zero);

                return FadeTransition(
                  opacity: fade,
                  child: SlideTransition(
                    position: slide,
                    child: CooperativeLogoCard(
                      partner: partner,
                      height: 84,
                    ),
                  ),
                );
              },
            ),
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
