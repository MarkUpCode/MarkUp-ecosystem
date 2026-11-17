import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/dolarito_mood.dart';
import '../models/dolarito_reaction.dart';
import '../providers/dolarito_provider.dart';
import 'dolarito_message.dart';

class DolaritoWidget extends StatelessWidget {
  const DolaritoWidget({
    super.key,
    required this.mood,
    this.message,
    this.showMessage = true,
    this.compact = false,
    this.imageSize,
    this.actionLabel,
    this.onAction,
    this.dismissible = false,
    this.onDismiss,
    this.onTap,
  });

  final DolaritoMood mood;
  final String? message;
  final bool showMessage;
  final bool compact;
  final double? imageSize;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = imageSize ?? (compact ? 50.0 : 76.0);
    final image = AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: animation, child: child),
      ),
      child: Image.asset(
        'assets/images/dolarito/${mood.assetName}',
        key: ValueKey(mood),
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => SizedBox.square(
          dimension: size,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFF087E5B),
          ),
        ),
      ),
    );

    return AnimatedSize(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      child: Container(
        padding: EdgeInsets.all(compact ? 7 : 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF9F4),
          borderRadius: BorderRadius.circular(compact ? 18 : 22),
          border: Border.all(color: const Color(0xFFD6EEE2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Semantics(
                image: true,
                label: 'Dolarito ${mood.name}',
                child: image,
              ),
            ),
            if (showMessage && message?.isNotEmpty == true) ...[
              SizedBox(width: compact ? 6 : 10),
              Expanded(
                child: DolaritoMessage(
                  message: message!,
                  compact: compact,
                  actionLabel: actionLabel,
                  onAction: onAction,
                  dismissible: dismissible,
                  onDismiss: onDismiss,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DolaritoStateWidget extends ConsumerWidget {
  const DolaritoStateWidget({super.key, this.compact = true, this.onRetry});

  final bool compact;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dolaritoProvider);
    if (!state.visible) return const SizedBox.shrink();
    return DolaritoWidget(
      mood: state.mood,
      message: state.message,
      compact: compact,
      actionLabel: state.actionLabel,
      onAction: _actionCallback(context, state.action, onRetry),
      dismissible: state.dismissible,
      onDismiss: () => ref.read(dolaritoProvider.notifier).dismiss(),
    );
  }
}

VoidCallback? _actionCallback(
  BuildContext context,
  DolaritoAction? action,
  VoidCallback? onRetry,
) {
  return switch (action) {
    DolaritoAction.completeProfile => () => context.go('/onboarding'),
    DolaritoAction.viewRequests => () => context.go('/requests'),
    DolaritoAction.retry => onRetry,
    null => null,
  };
}
