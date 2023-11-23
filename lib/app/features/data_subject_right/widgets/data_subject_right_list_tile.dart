import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';

class DataSubjectRightListTile extends StatelessWidget {
  const DataSubjectRightListTile({
    super.key,
    required this.title,
    required this.onTap,
    this.leading,
  });

  final String title;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (leading != null) leading!,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: UiConfig.actionSpacing,
              top: 5.0,
              bottom: 5.0,
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
