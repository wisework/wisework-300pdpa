import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/recently_image_selector.dart';
import 'package:pdpa/app/shared/widgets/upload_image_field.dart';

class BodyTab extends StatefulWidget {
  const BodyTab({
    super.key,
    required this.consentForm,
    required this.companyId,
  });

  final ConsentFormModel consentForm;
  final String companyId;

  @override
  State<BodyTab> createState() => _BodyTabState();
}

class _BodyTabState extends State<BodyTab> {
  void _uploadBodyImage(File file) {
    final cubit = context.read<CurrentConsentFormSettingsCubit>();
    cubit.uploadConsentImage(
      file,
      UtilFunctions.getUniqueFileName(file),
      UtilFunctions.getConsentImagePath(
        widget.companyId,
        widget.consentForm.id,
        ConsentFormImageType.body,
      ),
      ConsentFormImageType.body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          _buildBackgroundSection(context),
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
            imageUrl: widget.consentForm.bodyBackgroundImage,
            onUploaded: _uploadBodyImage,
            onRemoved: () {
              final cubit = context.read<CurrentConsentFormSettingsCubit>();
              cubit.removeConsentImage(
                ConsentFormImageType.body,
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
          visible: state.bodyImages.isNotEmpty,
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
                  imageUrls: state.bodyImages,
                  currentImageUrl: widget.consentForm.bodyBackgroundImage,
                  onSelected: (value) {
                    final cubit =
                        context.read<CurrentConsentFormSettingsCubit>();
                    cubit.setConsentImage(
                      value,
                      ConsentFormImageType.body,
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
