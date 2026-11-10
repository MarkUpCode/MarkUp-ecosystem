import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.scrollPadding = const EdgeInsets.only(bottom: 180),
    this.hasError = false,
    this.errorAnimationKey = 0,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final EdgeInsets scrollPadding;
  final bool hasError;
  final int errorAnimationKey;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError &&
        (!oldWidget.hasError ||
            widget.errorAnimationKey != oldWidget.errorAnimationKey)) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final progress = _shakeController.value;
        final offset = math.sin(progress * math.pi * 6) * 5 * (1 - progress);
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        scrollPadding: widget.scrollPadding,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon == null
              ? null
              : Icon(widget.prefixIcon),
          suffixIcon: widget.suffixIcon == null
              ? null
              : IconButton(
                  onPressed: widget.onSuffixTap,
                  icon: Icon(widget.suffixIcon),
                ),
          errorText: widget.hasError ? 'Completa este campo' : null,
          errorStyle: const TextStyle(fontSize: 11, height: 1.1),
          enabledBorder: widget.hasError
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          focusedBorder: widget.hasError
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
        ),
      ),
    );
  }
}
