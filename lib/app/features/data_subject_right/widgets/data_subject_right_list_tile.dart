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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onTap: onTap,
          leading: leading,
          title: Padding(
            padding: const EdgeInsets.all(UiConfig.lineGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        // Divider(
        //   color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        // ),
      ],
    );
  }
}
