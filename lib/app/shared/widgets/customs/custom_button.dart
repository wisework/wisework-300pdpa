import 'package:flutter/material.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well_button.dart';

enum CustomButtonType { filled, outlined, text }

class CustomButton extends StatelessWidget {
  const CustomButton({
    this.width,
    this.height,
    this.padding,
    this.margin,
    required this.onPressed,
    this.buttonType = CustomButtonType.filled,
    required this.child,
    super.key,
  });

  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback onPressed;
  final CustomButtonType buttonType;
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
              color: Theme.of(context).colorScheme.primary,
            ),
            child: MaterialInkWellButton(
              onPressed: onPressed,
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
          return MaterialInkWellButton(
            onPressed: onPressed,
            child: Container(
              width: width,
              height: height,
              padding: padding,
              child: Center(child: child),
            ),
          );
        }
        return MaterialInkWellButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          splashColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
          onPressed: onPressed,
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
