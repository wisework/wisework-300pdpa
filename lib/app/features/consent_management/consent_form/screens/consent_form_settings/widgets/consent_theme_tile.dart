import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class ConsentThemeTile extends StatelessWidget {
  const ConsentThemeTile({
    super.key,
    required this.consentTheme,
    required this.selectedValue,
  });

  final ConsentThemeModel consentTheme;
  final String selectedValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 3.5),
          child: CustomRadioButton(
            value: consentTheme.id,
            selectedValue: selectedValue,
            onChanged: (value) {},
          ),
        ),
        const SizedBox(width: UiConfig.actionSpacing),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialInkWell(
                      borderRadius: BorderRadius.circular(4.0),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 8.0,
                        ),
                        child: Text(
                          consentTheme.title,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: UiConfig.textSpacing),
                  CustomIconButton(
                    onPressed: () {},
                    icon: Ionicons.pencil_outline,
                    iconColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(width: UiConfig.textSpacing),
                  CustomIconButton(
                    onPressed: () {},
                    icon: Ionicons.copy_outline,
                    iconColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.onBackground,
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.textSpacing),
              Divider(
                height: 0.1,
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
