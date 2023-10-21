import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
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

  @override
  void dispose() {
    footerDescriptionController.dispose();
    acceptConsentTextController.dispose();
    linkToPolicyTextController.dispose();
    linkToPolicyUrlController.dispose();
    acceptTextController.dispose();
    cancelTextController.dispose();

    super.dispose();
  }

  void _initialData() {
    if (widget.consentForm.footerDescription.isNotEmpty) {
      footerDescriptionController = TextEditingController(
        text: widget.consentForm.footerDescription.first.text,
      );
    } else {
      footerDescriptionController = TextEditingController();
    }

    if (widget.consentForm.acceptConsentText.isNotEmpty) {
      acceptConsentTextController = TextEditingController(
        text: widget.consentForm.acceptConsentText.first.text,
      );
    } else {
      acceptConsentTextController = TextEditingController();
    }

    if (widget.consentForm.linkToPolicyText.isNotEmpty) {
      linkToPolicyTextController = TextEditingController(
        text: widget.consentForm.linkToPolicyText.first.text,
      );
    } else {
      linkToPolicyTextController = TextEditingController();
    }

    linkToPolicyUrlController = TextEditingController(
      text: widget.consentForm.linkToPolicyUrl,
    );

    if (widget.consentForm.submitText.isNotEmpty) {
      acceptTextController = TextEditingController(
        text: widget.consentForm.submitText.first.text,
      );
    } else {
      acceptTextController = TextEditingController();
    }

    if (widget.consentForm.cancelText.isNotEmpty) {
      cancelTextController = TextEditingController(
        text: widget.consentForm.cancelText.first.text,
      );
    } else {
      cancelTextController = TextEditingController();
    }
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
                tr('consentManagement.consentForm.consentFormsetting.footer'), //!
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text:
                tr('consentManagement.consentForm.createForm.description'), //!
            required: true,
          ),
          CustomTextField(
            controller: footerDescriptionController,
            hintText: tr(
                'consentManagement.consentForm.footertab.enterFooterDescription'), //!
            onChanged: (value) {
              final updated = widget.consentForm.copyWith(
                footerDescription: [
                  LocalizedModel(language: 'en-US', text: value),
                ],
              );

              context
                  .read<CurrentConsentFormSettingsCubit>()
                  .setConsentForm(updated);
            },
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
                tr('consentManagement.consentForm.footertab.acceptance'), //!
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr(
                'consentManagement.consentForm.footertab.acceptConsentText'), //!
            required: true,
          ),
          CustomTextField(
            controller: acceptConsentTextController,
            hintText: tr(
                'consentManagement.consentForm.footertab.enterAcceptConsentText'), //!
            onChanged: (value) {
              final updated = widget.consentForm.copyWith(
                acceptConsentText: [
                  LocalizedModel(language: 'en-US', text: value),
                ],
              );

              context
                  .read<CurrentConsentFormSettingsCubit>()
                  .setConsentForm(updated);
            },
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
              text: tr(
                  'consentManagement.consentForm.footertab.linkToPolicyText')), //!
          CustomTextField(
            controller: linkToPolicyTextController,
            hintText: tr(
                'consentManagement.consentForm.footertab.enterLinkToPolicyText'), //!
            onChanged: (value) {
              final updated = widget.consentForm.copyWith(
                linkToPolicyText: [
                  LocalizedModel(language: 'en-US', text: value),
                ],
              );

              context
                  .read<CurrentConsentFormSettingsCubit>()
                  .setConsentForm(updated);
            },
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
              text: tr(
                  'consentManagement.consentForm.footertab.linkToPolicyURL')), //!
          CustomTextField(
            controller: linkToPolicyUrlController,
            hintText: tr(
                'consentManagement.consentForm.footertab.enterLinkToPolicyURL'), //!
            onChanged: (value) {
              final updated = widget.consentForm.copyWith(
                linkToPolicyUrl: value,
              );

              context
                  .read<CurrentConsentFormSettingsCubit>()
                  .setConsentForm(updated);
            },
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
              text:
                  tr('consentManagement.consentForm.footertab.acceptText')), //!
          CustomTextField(
            controller: acceptTextController,
            hintText: tr(
                'consentManagement.consentForm.footertab.enterAcceptText'), //!
            onChanged: (value) {
              final updated = widget.consentForm.copyWith(
                submitText: [
                  LocalizedModel(language: 'en-US', text: value),
                ],
              );

              context
                  .read<CurrentConsentFormSettingsCubit>()
                  .setConsentForm(updated);
            },
          ),
          // const SizedBox(height: UiConfig.lineSpacing),
          // TitleRequiredText(
          //     text:
          //         tr('consentManagement.consentForm.footertab.cancelText')), //!
          // CustomTextField(
          //   controller: cancelTextController,
          //   hintText: tr(
          //       'consentManagement.consentForm.footertab.enterCancelText'), //!
          //   onChanged: (value) {
          //     final updated = widget.consentForm.copyWith(
          //       cancelText: [
          //         LocalizedModel(language: 'en-US', text: value),
          //       ],
          //     );

          //     context
          //         .read<CurrentConsentFormSettingsCubit>()
          //         .setConsentForm(updated);
          //   },
          // ),
        ],
      ),
    );
  }
}
