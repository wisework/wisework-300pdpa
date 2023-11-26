import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onSelected,
    this.height = 48.0,
    this.colorBorder,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final Function(T? value) onSelected;
  final double? height;
  final Color? colorBorder;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        items: items,
        value: value,
        onChanged: onSelected,
        buttonStyleData: ButtonStyleData(
          height: height,
          padding: const EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color:
                  colorBorder ?? Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(8.0),
          ),
          offset: const Offset(0, -5.0),
        ),
      ),
    );
  }
}
