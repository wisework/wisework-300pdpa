import 'package:flutter/material.dart';

class MaterialInkWell extends StatelessWidget {
  const MaterialInkWell({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.hoverColor,
    this.splashColor,
    required this.onTap,
    required this.child,
  });

  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? splashColor;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      child: InkWell(
        onTap: onTap,
        hoverColor: hoverColor,
        splashColor: splashColor ??
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        child: child,
      ),
    );
  }
}
