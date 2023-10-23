import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptConsentCheckbox extends StatefulWidget {
  const AcceptConsentCheckbox({
    super.key,
    required this.consentForm,
    required this.consentTheme,
    this.initialValue,
    this.onChanged,
    this.isReadOnly = false,
  });

  final ConsentFormModel consentForm;
  final ConsentThemeModel consentTheme;
  final bool? initialValue;
  final Function(bool value)? onChanged;
  final bool isReadOnly;

  @override
  State<AcceptConsentCheckbox> createState() => _AcceptConsentCheckboxState();
}

class _AcceptConsentCheckboxState extends State<AcceptConsentCheckbox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      isChecked = widget.initialValue!;
    }
  }

  void _onChanged(bool value) {
    if (widget.isReadOnly) return;

    setState(() {
      isChecked = value;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(isChecked);
    }
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    await canLaunchUrl(uri).then((result) async {
      if (result) {
        await launchUrl(uri);
      } else {
        BotToast.showText(
          text: 'Could not launch $url', //!
          contentColor:
              Theme.of(context).colorScheme.secondary.withOpacity(0.75),
          borderRadius: BorderRadius.circular(8.0),
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          duration: UiConfig.toastDuration,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CustomCheckBox(
          value: isChecked,
          onChanged: _onChanged,
          activeColor: widget.consentTheme.actionButtonColor,
        ),
        const SizedBox(width: UiConfig.actionSpacing),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.consentForm.acceptConsentText.first.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: widget.consentTheme.formTextColor),
                ),
                const WidgetSpan(
                  child: SizedBox(width: UiConfig.textSpacing),
                ),
                TextSpan(
                  text: widget.consentForm.linkToPolicyText.first.text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: widget.consentTheme.linkToPolicyTextColor,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchUrl(context, widget.consentForm.linkToPolicyUrl);
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
