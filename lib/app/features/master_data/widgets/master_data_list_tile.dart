import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class MasterDataListTile extends StatelessWidget {
  const MasterDataListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MaterialInkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(UiConfig.lineGap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Icon(
                      Ionicons.chevron_forward_outline,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ],
    );
  }
}
