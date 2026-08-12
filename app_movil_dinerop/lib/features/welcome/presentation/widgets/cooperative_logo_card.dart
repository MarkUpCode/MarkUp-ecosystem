import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/cooperative_partner.dart';

class CooperativeLogoCard extends StatelessWidget {
  const CooperativeLogoCard({
    super.key,
    required this.partner,
    this.height = 76,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  });

  final CooperativePartner partner;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget logoImage;

    if (partner.assetPath != null) {
      if (partner.assetPath!.endsWith('.svg')) {
        logoImage = SvgPicture.asset(
          partner.assetPath!,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        );
      } else {
        logoImage = Image.asset(
          partner.assetPath!,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        );
      }
    } else if (partner.logoUrl != null && partner.logoUrl!.isNotEmpty) {
      if (partner.logoUrl!.endsWith('.svg')) {
        logoImage = SvgPicture.network(
          partner.logoUrl!,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        );
      } else {
        logoImage = Image.network(
          partner.logoUrl!,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        );
      }
    } else {
      logoImage = Text(
        partner.nombre,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Center(
        child: logoImage,
      ),
    );
  }
}
