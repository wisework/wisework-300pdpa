import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.padding,
    this.borderRadius = 8.0,
    this.onPressed,
    required this.icon,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.splashColor,
  });

  final EdgeInsets? padding;
  final double borderRadius;
  final VoidCallback? onPressed;
  final IconData icon;
  final double? iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? splashColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onPressed,
        splashColor: splashColor ??
            Theme.of(context).colorScheme.surfaceTint.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
