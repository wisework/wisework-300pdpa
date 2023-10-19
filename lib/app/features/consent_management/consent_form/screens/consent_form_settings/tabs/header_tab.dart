import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/recently_image_selector.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';
import 'package:pdpa/app/shared/widgets/upload_image_field.dart';

class HeaderTab extends StatefulWidget {
  const HeaderTab({
    super.key,
    required this.consentForm,
    required this.companyId,
  });

  final ConsentFormModel consentForm;
  final String companyId;

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

  void _uploadLogoImage(File file) {
    final cubit = context.read<CurrentConsentFormSettingsCubit>();
    cubit.uploadConsentImage(
      file,
      UtilFunctions.getUniqueFileName(file),
      UtilFunctions.getConsentImagePath(
        widget.companyId,
        widget.consentForm.id,
        ConsentFormImageType.logo,
      ),
      ConsentFormImageType.logo,
    );
  }

  void _uploadHeaderImage(File file) {
    final cubit = context.read<CurrentConsentFormSettingsCubit>();
    cubit.uploadConsentImage(
      file,
      UtilFunctions.getUniqueFileName(file),
      UtilFunctions.getConsentImagePath(
        widget.companyId,
        widget.consentForm.id,
        ConsentFormImageType.header,
      ),
      ConsentFormImageType.header,
    );
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
                'Logo', //!
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          UploadImageField(
            imageUrl: widget.consentForm.logoImage,
            onUploaded: _uploadLogoImage,
            onRemoved: () {
              final cubit = context.read<CurrentConsentFormSettingsCubit>();
              cubit.removeConsentImage(
                ConsentFormImageType.logo,
              );
            },
          ),
          _buildRecentlyLogoImages(),
        ],
      ),
    );
  }

  BlocBuilder _buildRecentlyLogoImages() {
    return BlocBuilder<CurrentConsentFormSettingsCubit,
        CurrentConsentFormSettingsState>(
      builder: (context, state) {
        return Visibility(
          visible: state.logoImages.isNotEmpty,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: UiConfig.lineSpacing),
              Divider(
                height: 0.1,
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.6),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Row(
                children: <Widget>[
                  Text(
                    'Recently used', //!
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              SizedBox(
                height: 80.0,
                child: RecentlyImageSelector(
                  imageUrls: state.logoImages,
                  currentImageUrl: widget.consentForm.logoImage,
                  onSelected: (value) {
                    final cubit =
                        context.read<CurrentConsentFormSettingsCubit>();
                    cubit.setConsentImage(
                      value,
                      ConsentFormImageType.logo,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
                'Header', //!
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText( 
            text: 'Header Text', //!
          ),
          CustomTextField(
            controller: headerTextController,
            hintText: 'Enter header text', //!
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
          const TitleRequiredText(text: 'Description'), //!
          CustomTextField(
            controller: headerDescriptionController,
            hintText: 'Enter description', //!
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
                'Background', //!
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          UploadImageField(
            imageUrl: widget.consentForm.headerBackgroundImage,
            onUploaded: _uploadHeaderImage,
            onRemoved: () {
              final cubit = context.read<CurrentConsentFormSettingsCubit>();
              cubit.removeConsentImage(
                ConsentFormImageType.header,
              );
            },
          ),
          _buildRecentlyHeaderImages(),
        ],
      ),
    );
  }

  BlocBuilder _buildRecentlyHeaderImages() {
    return BlocBuilder<CurrentConsentFormSettingsCubit,
        CurrentConsentFormSettingsState>(
      builder: (context, state) {
        return Visibility(
          visible: state.headerImages.isNotEmpty,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: UiConfig.lineSpacing),
              Divider(
                height: 0.1,
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.6),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Row(
                children: <Widget>[
                  Text(
                    'Recently used', //!
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              SizedBox(
                height: 80.0,
                child: RecentlyImageSelector(
                  imageUrls: state.headerImages,
                  currentImageUrl: widget.consentForm.headerBackgroundImage,
                  onSelected: (value) {
                    final cubit =
                        context.read<CurrentConsentFormSettingsCubit>();
                    cubit.setConsentImage(
                      value,
                      ConsentFormImageType.header,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
