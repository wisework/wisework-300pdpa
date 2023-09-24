import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    this.controller,
    this.hintText,
    this.obscureText = false,
    super.key,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = true;

  void setObscureText() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText ? isObscured : false,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        suffixIcon: widget.obscureText
            ? Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: InkWell(
                  splashColor: Theme.of(context)
                      .colorScheme
                      .surfaceTint
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: setObscureText,
                  child: Icon(
                    isObscured
                        ? Ionicons.eye_off_outline
                        : Ionicons.eye_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      ),
    );
  }
}
