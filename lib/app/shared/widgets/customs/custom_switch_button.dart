import 'package:flutter/material.dart';

class CustomSwitchButton extends StatelessWidget {
  const CustomSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.scale = 0.85,
  });

  final bool value;
  final Function(bool value) onChanged;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
        activeTrackColor:
            Theme.of(context).colorScheme.surfaceTint.withOpacity(0.3),
        inactiveThumbColor: Theme.of(context).colorScheme.outlineVariant,
      ),
    );
  }
}
