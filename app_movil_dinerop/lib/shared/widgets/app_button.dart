import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outlined }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOutlined = variant == AppButtonVariant.outlined || variant == AppButtonVariant.secondary;

    final loadingWidget = SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.2,
        color: isOutlined ? theme.colorScheme.primary : Colors.white,
      ),
    );

    final iconWidget = isLoading
        ? loadingWidget
        : (icon != null ? Icon(icon, size: 20) : null);

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null) ...[
              iconWidget,
              const SizedBox(width: 10),
            ],
            Text(label),
          ],
        ),
      );
    }

    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconWidget != null) ...[
            iconWidget,
            const SizedBox(width: 10),
          ],
          Text(label),
        ],
      ),
    );
  }
}