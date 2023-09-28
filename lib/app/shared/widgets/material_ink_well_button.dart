import 'package:flutter/material.dart';

class MaterialInkWellButton extends StatelessWidget {
  const MaterialInkWellButton({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.splashColor,
    required this.onPressed,
    required this.child,
  });

  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? splashColor;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Theme.of(context).colorScheme.onPrimary,
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      child: InkWell(
        onTap: onPressed,
        splashColor: splashColor ??
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        child: child,
      ),
    );
  }
}
