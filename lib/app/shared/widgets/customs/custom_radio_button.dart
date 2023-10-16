import 'package:flutter/material.dart';

class CustomRadioButton<T> extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.value,
    required this.selected,
    this.onChanged,
    this.activeColor,
  });

  final T value;
  final T selected;
  final Function(T? value)? onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Radio(
      value: value,
      groupValue: selected,
      onChanged: onChanged,
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          final color = value == selected
              ? activeColor ?? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outlineVariant;

          return color;
        },
      ),
      overlayColor: MaterialStateColor.resolveWith(
        (states) {
          final color = activeColor ?? Theme.of(context).colorScheme.primary;
          if (states.contains(MaterialState.pressed)) {
            return color.withOpacity(0.2);
          }
          return color.withOpacity(0.1);
        },
      ),
    );
  }
}
