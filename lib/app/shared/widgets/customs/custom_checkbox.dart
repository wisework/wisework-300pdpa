import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (_) => onChanged(!value),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      side: MaterialStateBorderSide.resolveWith(
        (states) => BorderSide(
          width: 2.0,
          color: activeColor ?? Theme.of(context).colorScheme.primary,
        ),
      ),
      activeColor: activeColor ?? Theme.of(context).colorScheme.primary,
      checkColor: Theme.of(context).colorScheme.onPrimary,
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
