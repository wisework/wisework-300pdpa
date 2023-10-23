import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class MasterDataItemCard extends StatelessWidget {
  const MasterDataItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final ActiveStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        onTap != null
            ? MaterialInkWell(
                onTap: onTap!,
                child: _buildCardContent(context),
              )
            : _buildCardContent(context),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing,
          ),
          child: Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Padding _buildCardContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Visibility(
                  visible: subtitle.isNotEmpty,
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          _buildCardStatus(context),
        ],
      ),
    );
  }

  Container _buildCardStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 10.0,
      ),
      decoration: BoxDecoration(
        color: status == ActiveStatus.active
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Theme.of(context).colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.circle,
            size: 10.0,
            color: status == ActiveStatus.active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 5.0),
          Text(
            status == ActiveStatus.active
                ? tr('masterData.etc.active')
                : tr('masterData.etc.inactive'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: status == ActiveStatus.active
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );
  }
}
