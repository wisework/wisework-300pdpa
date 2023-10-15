import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.readOnly = false,
    this.required = false,
    this.errorText,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffix;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Function(String value)? onChanged;
  final bool readOnly;
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
        ? _buildTextFormField(context)
        : _buildTextField(context);
  }

  TextFormField _buildTextFormField(BuildContext context) {
    return widget.maxLines != null
        ? TextFormField(
            controller: widget.controller,
            decoration: _buildInputDecoration(context),
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines ?? 1,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            readOnly: widget.readOnly,
            validator: _validateInput,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          )
        : TextFormField(
            controller: widget.controller,
            decoration: _buildInputDecoration(context),
            keyboardType: widget.keyboardType,
            minLines: widget.minLines ?? 1,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            readOnly: widget.readOnly,
            validator: _validateInput,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          );
  }

  TextField _buildTextField(BuildContext context) {
    return widget.maxLines != null
        ? TextField(
            controller: widget.controller,
            decoration: _buildInputDecoration(context),
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines ?? 1,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            readOnly: widget.readOnly,
          )
        : TextField(
            controller: widget.controller,
            decoration: _buildInputDecoration(context),
            keyboardType: widget.keyboardType,
            minLines: widget.minLines ?? 1,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            readOnly: widget.readOnly,
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
      filled: widget.readOnly,
      fillColor:
          widget.readOnly ? Theme.of(context).colorScheme.tertiary : null,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: widget.readOnly
              ? Theme.of(context).colorScheme.outlineVariant
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
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
