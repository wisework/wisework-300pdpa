import 'package:flutter/material.dart';

class ErrorMessageScreen extends StatelessWidget {
  const ErrorMessageScreen({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
