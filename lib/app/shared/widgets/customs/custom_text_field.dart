import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.required = false,
    this.errorText,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffix;
  final TextInputType keyboardType;
  final bool required;
  final String? errorText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return widget.errorText ?? tr('masterData.etc.fieldCannotEmpty');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.required
        ? TextFormField(
            controller: widget.controller,
            decoration: _buildInputDecoration(context),
            keyboardType: widget.keyboardType,
            validator: _validateInput,
          )
        : TextField(
            controller: widget.controller,
            decoration: _buildInputDecoration(context),
            keyboardType: widget.keyboardType,
          );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
      errorStyle: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: Theme.of(context).colorScheme.error),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      suffix: widget.suffix != null
          ? Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: widget.suffix,
            )
          : null,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
