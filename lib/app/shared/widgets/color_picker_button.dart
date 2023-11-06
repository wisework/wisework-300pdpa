import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';

class ColorPickerButton extends StatefulWidget {
  const ColorPickerButton({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  final Color initialColor;
  final Function(Color? color) onColorChanged;

  @override
  State<ColorPickerButton> createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select Color',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Theme(
            data: ThemeData(),
            child: ColorPicker(
              pickerColor: widget.initialColor,
              onColorChanged: widget.onColorChanged,
              portraitOnly: true,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          surfaceTintColor: Theme.of(context).colorScheme.onBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          scrollable: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onBackground,
      borderRadius: BorderRadius.circular(6.0),
      child: InkWell(
        onTap: _showColorPicker,
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 8.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  color: widget.initialColor,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: UiConfig.actionSpacing),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Icon(
                  Ionicons.caret_down_outline,
                  size: 14.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
