import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';

class PurposeRadioOption extends StatefulWidget {
  const PurposeRadioOption({
    super.key,
    required this.purpose,
    required this.consentTheme,
    this.onChanged,
  });

  final PurposeModel purpose;
  final ConsentThemeModel consentTheme;
  final Function(bool value)? onChanged;

  @override
  State<PurposeRadioOption> createState() => _PurposeRadioOptionState();
}

class _PurposeRadioOptionState extends State<PurposeRadioOption> {
  bool isAgree = true;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.onBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.purpose.description.first.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: UiConfig.lineSpacing),
          Wrap(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomRadioButton(
                    value: true,
                    selected: isAgree,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          isAgree = value;
                        });

                        if (widget.onChanged != null) {
                          widget.onChanged!(value);
                        }
                      }
                    },
                    activeColor: widget.consentTheme.actionButtonColor,
                  ),
                  const SizedBox(width: UiConfig.actionSpacing),
                  Text(
                    'Agree',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(width: UiConfig.actionSpacing * 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomRadioButton(
                    value: false,
                    selected: isAgree,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          isAgree = value;
                        });

                        if (widget.onChanged != null) {
                          widget.onChanged!(value);
                        }
                      }
                    },
                    activeColor: widget.consentTheme.actionButtonColor,
                  ),
                  const SizedBox(width: UiConfig.actionSpacing),
                  Text(
                    'Decline',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          ExpandedContainer(
            expand: !isAgree,
            duration: const Duration(milliseconds: 400),
            child: Column(
              children: <Widget>[
                const SizedBox(width: UiConfig.lineGap),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onError,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Icon(
                          Ionicons.warning_outline,
                          size: 18.0,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                      const SizedBox(width: UiConfig.textSpacing),
                      Expanded(
                        child: Text(
                          widget.purpose.warningDescription.first.text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
