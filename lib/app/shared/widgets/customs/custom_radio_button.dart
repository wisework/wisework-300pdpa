import 'package:flutter/material.dart';

class CustomRadioButton<T> extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.value,
    required this.selectedValue,
    this.onChanged,
    this.activeColor,
  });

  final T value;
  final T selectedValue;
  final Function(T?)? onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Radio(
      value: value,
      groupValue: selectedValue,
      onChanged: onChanged,
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (value == selectedValue) {
            return activeColor ?? Theme.of(context).colorScheme.primary;
          }
          return Theme.of(context).colorScheme.outlineVariant;
        },
      ),
      hoverColor: (activeColor ?? Theme.of(context).colorScheme.primary)
          .withOpacity(0.1),
    );
  }
}
