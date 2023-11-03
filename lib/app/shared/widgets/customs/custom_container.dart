import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.constraints,
    this.color,
    this.borderRadius,
    required this.child,
  });

  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.onBackground,
        borderRadius: borderRadius ?? BorderRadius.circular(10.0),
      ),
      width: width,
      height: height,
      constraints: constraints,
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing,
          ),
      child: child,
    );
  }
}
