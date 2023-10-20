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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: UiConfig.defaultPaddingSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              headderText,
              style: Theme.of(context).textTheme.titleMedium,
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
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: UiConfig.defaultPaddingSpacing),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SizedBox(width: double.infinity, child: image),
          ),
        ),
        const SizedBox(height: UiConfig.defaultPaddingSpacing),
        CustomButton(
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
      ],
    );
  }
}
