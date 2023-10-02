import 'package:flutter/material.dart';

class TitleRequiredText extends StatelessWidget {
  const TitleRequiredText({
    super.key,
    required this.text,
    this.textStyle,
    this.required = false,
    this.titleSpacing = 5.0,
  });

  final String text;
  final TextStyle? textStyle;
  final bool required;
  final double titleSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
            ),
            Visibility(
              visible: required,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  '*',
                  style: (textStyle ?? Theme.of(context).textTheme.bodyMedium)
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: titleSpacing),
      ],
    );
  }
}
