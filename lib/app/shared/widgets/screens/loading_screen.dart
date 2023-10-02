import 'package:flutter/material.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: LoadingIndicator(),
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
