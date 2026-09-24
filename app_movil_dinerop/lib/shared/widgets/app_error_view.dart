import 'package:flutter/material.dart';

import 'app_button.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: colors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revisa la información',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colors.onErrorContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onErrorContainer,
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Reintentar',
                    onPressed: onRetry,
                    icon: Icons.refresh_rounded,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
