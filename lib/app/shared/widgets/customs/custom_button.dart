import 'package:flutter/material.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

enum CustomButtonType { filled, outlined, text }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    required this.onPressed,
    this.buttonType = CustomButtonType.filled,
    this.buttonColor,
    this.splashColor,
    required this.child,
  });

  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback onPressed;
  final CustomButtonType buttonType;
  final Color? buttonColor;
  final Color? splashColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Builder(builder: (context) {
        if (buttonType == CustomButtonType.outlined) {
          return Container(
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              color: buttonColor ?? Theme.of(context).colorScheme.primary,
            ),
            child: MaterialInkWell(
              onTap: onPressed,
              child: Container(
                width: width,
                height: height,
                padding: padding,
                child: Center(child: child),
              ),
            ),
          );
        }
        if (buttonType == CustomButtonType.text) {
          return MaterialInkWell(
            onTap: onPressed,
            child: Container(
              width: width,
              height: height,
              padding: padding,
              child: Center(child: child),
            ),
          );
        }
        return MaterialInkWell(
          backgroundColor: buttonColor ?? Theme.of(context).colorScheme.primary,
          splashColor: (splashColor ?? Theme.of(context).colorScheme.onPrimary)
              .withOpacity(0.1),
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            padding: padding,
            child: Center(child: child),
          ),
        );
      }),
    );
  }
}
