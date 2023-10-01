import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

class ConfigurationInfo extends StatelessWidget {
  const ConfigurationInfo({
    super.key,
    required this.configBody,
    this.updatedBy,
    required this.updatedDate,
  });

  final Widget configBody;
  final String? updatedBy;
  final DateTime updatedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              tr('masterData.etc.configuration'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        configBody,
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
        _buildUserInfo(context),
      ],
    );
  }

  Column _buildUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          children: <Widget>[
            Text(
              tr('masterData.etc.updateInfo'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Visibility(
          visible: updatedBy != null && updatedBy!.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(bottom: UiConfig.textSpacing),
            child: Text(
              updatedBy!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        Text(
          datetimeFormatter.format(updatedDate),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: UiConfig.lineGap),
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ],
    );
  }
}
