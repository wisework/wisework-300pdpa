import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({
    super.key,
    required this.headderText,
    required this.buttonText,
    required this.descriptionText,
    this.image,
    required this.onPress,
  });

  final String headderText;
  final String buttonText;
  final String descriptionText;
  final Image? image;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: UiConfig.defaultPaddingSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              headderText,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.defaultPaddingSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                descriptionText,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: UiConfig.defaultPaddingSpacing),
        
        Visibility(
          visible: image != null,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(width: double.infinity, child: image),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260.0),
          child: CustomButton(
            height: 40,
            onPressed: onPress,
            child: Text(
              buttonText,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
