import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.readOnly = false,
    this.required = false,
    this.errorText,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.obscureText = false,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Function(String value)? onChanged;
  final bool readOnly;
  final bool required;
  final String? errorText;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final bool obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();

    isObscured = widget.obscureText;
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return widget.errorText ?? tr('masterData.etc.fieldCannotEmpty'); //!
    } else if (widget.keyboardType == TextInputType.emailAddress &&
        !emailRegex.hasMatch(value)) {
      return widget.errorText ?? tr('masterData.etc.pleaseEnterValidEmail'); //!
    }
    return null;
  }

  void _setObscure() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.required || widget.initialValue != null
        ? _buildTextFormField(context)
        : _buildTextField(context);
  }

  TextFormField _buildTextFormField(BuildContext context) {
    return widget.maxLines != null
        ? TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            decoration: _buildInputDecoration(context),
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            obscureText: isObscured,
            maxLines: widget.maxLines,
            minLines: widget.minLines ?? 1,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            validator: _validateInput,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          )
        : TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            decoration: _buildInputDecoration(context),
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            obscureText: isObscured,
            minLines: widget.minLines ?? 1,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
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
            readOnly: widget.readOnly,
            obscureText: isObscured,
            maxLines: widget.maxLines,
            minLines: widget.minLines ?? 1,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
          )
        : TextField(
            controller: widget.controller,
            decoration: _buildInputDecoration(context),
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            obscureText: isObscured,
            minLines: widget.minLines ?? 1,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
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
      contentPadding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 12.0,
      ),
      suffixIcon: widget.obscureText
          ? Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: IconButton(
                onPressed: _setObscure,
                icon: Icon(
                  isObscured ? Ionicons.eye_off_outline : Ionicons.eye_outline,
                  size: 18.0,
                  color: isObscured
                      ? Theme.of(context).colorScheme.onTertiary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : null,
      filled: true,
      fillColor: widget.readOnly
          ? Theme.of(context).colorScheme.tertiary
          : widget.fillColor ?? Theme.of(context).colorScheme.onBackground,
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
              : widget.focusedBorderColor ??
                  Theme.of(context).colorScheme.primary,
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
          color: widget.borderColor ??
              Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: widget.borderColor ??
              Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
