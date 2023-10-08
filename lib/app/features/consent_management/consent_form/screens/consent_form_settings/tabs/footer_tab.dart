import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class FooterTab extends StatefulWidget {
  const FooterTab({
    super.key,
    required this.consentForm,
  });

  final ConsentFormModel consentForm;

  @override
  State<FooterTab> createState() => _FooterTabState();
}

class _FooterTabState extends State<FooterTab> {
  late TextEditingController footerDescriptionController;
  late TextEditingController acceptConsentTextController;
  late TextEditingController linkToPolicyTextController;
  late TextEditingController linkToPolicyUrlController;
  late TextEditingController acceptTextController;
  late TextEditingController cancelTextController;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    footerDescriptionController = TextEditingController(
      text: widget.consentForm.footerDescription.first.text,
    );
    acceptConsentTextController = TextEditingController(
      text: widget.consentForm.acceptConsentText.first.text,
    );
    linkToPolicyTextController = TextEditingController(
      text: widget.consentForm.linkToPolicyText.first.text,
    );
    linkToPolicyUrlController = TextEditingController(
      text: widget.consentForm.linkToPolicyUrl,
    );
    acceptTextController = TextEditingController(
      text: widget.consentForm.acceptText.first.text,
    );
    cancelTextController = TextEditingController(
      text: widget.consentForm.cancelText.first.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          _buildFooterSection(context),
          const SizedBox(height: UiConfig.lineSpacing),
          _buildAcceptanceSection(context),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  CustomContainer _buildFooterSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Footer',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'Description',
            required: true,
          ),
          CustomTextField(
            controller: footerDescriptionController,
            hintText: 'Enter footer description',
          ),
        ],
      ),
    );
  }

  CustomContainer _buildAcceptanceSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Acceptance',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'Accept Consent Text',
            required: true,
          ),
          CustomTextField(
            controller: acceptConsentTextController,
            hintText: 'Enter accept consent text',
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(text: 'Link To Policy Text'),
          CustomTextField(
            controller: linkToPolicyTextController,
            hintText: 'Enter link to policy text',
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(text: 'Link To Policy URL'),
          CustomTextField(
            controller: linkToPolicyUrlController,
            hintText: 'Enter link to policy URL',
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(text: 'Accept Text'),
          CustomTextField(
            controller: acceptTextController,
            hintText: 'Enter accept text',
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(text: 'Cancel Text'),
          CustomTextField(
            controller: cancelTextController,
            hintText: 'Enter cancel text',
          ),
        ],
      ),
    );
  }
}
