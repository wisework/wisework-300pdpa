import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class ConsentThemeTile extends StatefulWidget {
  const ConsentThemeTile({
    super.key,
    required this.consentTheme,
    required this.selectedValue,
  });

  final ConsentThemeModel consentTheme;
  final String selectedValue;

  @override
  State<ConsentThemeTile> createState() => _ConsentThemeTileState();
}

class _ConsentThemeTileState extends State<ConsentThemeTile> {
  bool isExpanded = false;

  void _setExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 3.5),
          child: CustomRadioButton(
            value: widget.consentTheme.id,
            selected: widget.selectedValue,
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
                      onTap: _setExpand,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 8.0,
                        ),
                        child: Text(
                          widget.consentTheme.title,
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
              _buildConsentThemeExample(context),
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

  ExpandedContainer _buildConsentThemeExample(BuildContext context) {
    return ExpandedContainer(
      expand: isExpanded,
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
        color: Theme.of(context).colorScheme.background,
        margin: const EdgeInsets.symmetric(vertical: UiConfig.textSpacing),
        child: CustomContainer(
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Data Collection',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: widget.consentTheme.headerTextColor),
                ),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Text(
                'This consent form outlines the terms and conditions for the collection.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: widget.consentTheme.formTextColor),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(11.0),
                    decoration: BoxDecoration(
                      color: widget.consentTheme.categoryIconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '1',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  const SizedBox(width: UiConfig.actionSpacing),
                  Expanded(
                    child: Text(
                      'The primary purpose of collecting your personal data',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: widget.consentTheme.categoryTitleTextColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Row(
                children: <Widget>[
                  CustomCheckBox(
                    value: false,
                    onChanged: (value) {},
                    activeColor: widget.consentTheme.actionButtonColor,
                  ),
                  const SizedBox(width: UiConfig.actionSpacing),
                  Expanded(
                    child: Text(
                      'I accept: Consent to Personal Data Use for Property Insights and Analysis Purposes.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: widget.consentTheme.formTextColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              CustomButton(
                height: 40.0,
                onPressed: () {},
                buttonColor: widget.consentTheme.submitButtonColor,
                splashColor: widget.consentTheme.submitTextColor,
                child: Text(
                  'Submit',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: widget.consentTheme.submitTextColor),
                ),
              ),
              const SizedBox(height: UiConfig.lineGap),
              CustomButton(
                height: 40.0,
                onPressed: () {},
                buttonColor: widget.consentTheme.cancelButtonColor,
                splashColor: widget.consentTheme.cancelTextColor,
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: widget.consentTheme.cancelTextColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
