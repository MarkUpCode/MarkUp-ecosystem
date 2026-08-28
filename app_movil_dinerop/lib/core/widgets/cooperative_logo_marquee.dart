import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../features/welcome/data/models/cooperative_partner.dart';
import '../../features/welcome/presentation/widgets/cooperative_logo_card.dart';

class CooperativeLogoMarquee extends StatefulWidget {
  const CooperativeLogoMarquee({
    super.key,
    this.partners = CooperativePartner.initialPartners,
    this.height = 76,
    this.speed = 110,
    this.logoSize = 132,
    this.gap = 12,
  });

  final List<CooperativePartner> partners;
  final double height;
  final double speed;
  final double logoSize;
  final double gap;

  @override
  State<CooperativeLogoMarquee> createState() => _CooperativeLogoMarqueeState();
}

class _CooperativeLogoMarqueeState extends State<CooperativeLogoMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  double get _sequenceWidth =>
      widget.partners.length * (widget.logoSize + widget.gap);

  Duration get _duration {
    if (widget.speed <= 0 || _sequenceWidth <= 0) {
      return const Duration(seconds: 1);
    }

    return Duration(
      milliseconds: math.max(1, (_sequenceWidth / widget.speed * 1000).round()),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant CooperativeLogoMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.partners != widget.partners ||
        oldWidget.height != widget.height ||
        oldWidget.speed != widget.speed ||
        oldWidget.logoSize != widget.logoSize ||
        oldWidget.gap != widget.gap) {
      _controller
        ..duration = _duration
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.partners.isEmpty) {
      return SizedBox(height: widget.height);
    }

    final sequenceWidth = _sequenceWidth;

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final copies = math.max(
            2,
            (constraints.maxWidth / sequenceWidth).ceil() + 1,
          );

          return ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              child: _buildContent(copies),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(-sequenceWidth * _controller.value, 0),
                  child: child,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(int copies) {
    return OverflowBox(
      alignment: Alignment.centerLeft,
      minWidth: 0,
      maxWidth: double.infinity,
      child: SizedBox(
        width: _sequenceWidth * copies,
        height: widget.height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var copy = 0; copy < copies; copy++) ..._buildLogoSet(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLogoSet() {
    return [
      for (final partner in widget.partners)
        Padding(
          padding: EdgeInsets.only(right: widget.gap),
          child: SizedBox(
            width: widget.logoSize,
            child: CooperativeLogoCard(
              partner: partner,
              height: widget.height - 12,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ),
    ];
  }
}
