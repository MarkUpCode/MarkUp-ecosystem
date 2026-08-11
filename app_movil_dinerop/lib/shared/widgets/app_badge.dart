import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.label, this.color, this.textColor});

  final String label;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final upper = label.toUpperCase();

    Color bg;
    Color fg;

    if (color != null) {
      bg = color!;
      fg = textColor ?? (isDark ? Colors.white : AppColors.primary);
    } else if (upper.contains('APROBAD') ||
        upper.contains('ACTIVO') ||
        upper.contains('COMPLETO') ||
        upper.contains('EXITO')) {
      bg = isDark ? AppColors.darkAccentSoft : AppColors.successSoft;
      fg = isDark ? AppColors.darkAccent : AppColors.success;
    } else if (upper.contains('PENDIENTE') ||
        upper.contains('REVISION') ||
        upper.contains('EN_PROCESO')) {
      bg = isDark ? const Color(0xFF332005) : AppColors.warningSoft;
      fg = isDark ? const Color(0xFFFBBF24) : AppColors.warning;
    } else if (upper.contains('RECHAZAD') ||
        upper.contains('CANCELAD') ||
        upper.contains('INACTIVO')) {
      bg = isDark ? const Color(0xFF3B1212) : AppColors.errorSoft;
      fg = isDark ? const Color(0xFFF87171) : AppColors.error;
    } else {
      bg = Theme.of(context).colorScheme.primaryContainer;
      fg = Theme.of(context).colorScheme.primary;
    }

    if (textColor != null) fg = textColor!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.2), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}