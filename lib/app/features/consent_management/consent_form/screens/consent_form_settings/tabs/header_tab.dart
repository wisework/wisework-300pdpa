import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class HeaderTab extends StatefulWidget {
  const HeaderTab({
    super.key,
    required this.consentForm,
  });

  final ConsentFormModel consentForm;

  @override
  State<HeaderTab> createState() => _HeaderTabState();
}

class _HeaderTabState extends State<HeaderTab> {
  late TextEditingController headerTextController;
  late TextEditingController headerDescriptionController;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  void dispose() {
    headerTextController.dispose();
    headerDescriptionController.dispose();

    super.dispose();
  }

  void _initialData() {
    if (widget.consentForm.headerText.isNotEmpty) {
      headerTextController = TextEditingController(
        text: widget.consentForm.headerText.first.text,
      );
    } else {
      headerTextController = TextEditingController();
    }

    if (widget.consentForm.headerDescription.isNotEmpty) {
      headerDescriptionController = TextEditingController(
        text: widget.consentForm.headerDescription.first.text,
      );
    } else {
      headerDescriptionController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          _buildLogoSection(context),
          const SizedBox(height: UiConfig.lineSpacing),
          _buildHeaderSection(context),
          const SizedBox(height: UiConfig.lineSpacing),
          _buildBackgroundSection(context),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  CustomContainer _buildLogoSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Logo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomTextField(
                  controller: TextEditingController(
                    text: widget.consentForm.logoImage,
                  ),
                  hintText: 'No image file selected',
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomIconButton(
                  onPressed: () {},
                  icon: Icons.file_upload_outlined,
                  iconColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  CustomContainer _buildHeaderSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Header',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'Header Text',
            required: true,
          ),
          CustomTextField(
            controller: headerTextController,
            hintText: 'Enter header text',
            onChanged: (value) {
              final updated = widget.consentForm.copyWith(
                headerText: [
                  LocalizedModel(language: 'en-US', text: value),
                ],
              );

              context
                  .read<CurrentConsentFormSettingsCubit>()
                  .setConsentForm(updated);
            },
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(text: 'Description'),
          CustomTextField(
            controller: headerDescriptionController,
            hintText: 'Enter description',
            onChanged: (value) {
              final updated = widget.consentForm.copyWith(
                headerDescription: [
                  LocalizedModel(language: 'en-US', text: value),
                ],
              );

              context
                  .read<CurrentConsentFormSettingsCubit>()
                  .setConsentForm(updated);
            },
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  CustomContainer _buildBackgroundSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Background',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomTextField(
                  controller: TextEditingController(
                    text: widget.consentForm.headerBackgroundImage,
                  ),
                  hintText: 'No image file selected',
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomIconButton(
                  onPressed: () {},
                  icon: Icons.file_upload_outlined,
                  iconColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
