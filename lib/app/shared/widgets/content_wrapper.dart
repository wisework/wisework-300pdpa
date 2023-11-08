import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';

class ContentWrapper extends StatelessWidget {
  const ContentWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: UiConfig.maxWidthContent,
          ),
          child: child,
        ),
      ),
    );
  }
}
