import 'package:flutter/material.dart';

class DolaritoMessage extends StatelessWidget {
  const DolaritoMessage({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.dismissible = false,
    this.onDismiss,
    this.compact = false,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: compact ? 11 : 14,
      vertical: compact ? 9 : 12,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: const Color(0xFFD9EFE8)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A14543E),
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                message,
                maxLines: compact ? 4 : 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF234B3C),
                  fontSize: compact ? 12 : 13,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (dismissible && onDismiss != null) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: onDismiss,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.close_rounded,
                    size: 17,
                    color: Color(0xFF698377),
                  ),
                ),
              ),
            ],
          ],
        ),
        if (actionLabel != null && onAction != null) ...[
          SizedBox(height: compact ? 4 : 7),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF087E5B),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                minimumSize: const Size(0, 30),
              ),
              child: Text(
                actionLabel!,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
