import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/power_verification_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_verification_model.dart';
import 'package:pdpa/app/data/presets/identity_proofing_preset.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';
import 'package:pdpa/app/shared/widgets/upload_file_field.dart';

class IdentityVerificationPage extends StatefulWidget {
  const IdentityVerificationPage({super.key, required this.companyId});

  final String companyId;

  @override
  State<IdentityVerificationPage> createState() =>
      _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
  List<RequesterVerificationModel> identityVerifications = [];
  late DataSubjectRightModel dataSubjectRight;
  @override
  void initState() {
    dataSubjectRight =
        context.read<FormDataSubjectRightCubit>().state.dataSubjectRight;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: UiConfig.lineSpacing),
          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: UiConfig.lineSpacing),
                Text(
                  'เอกสารพิสูจน์ตัวตนและพิสูจน์ถิ่นที่อยู่เจ้าของข้อมูล', //!
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Text(
                  'ข้าพเจ้าได้แนบเอกสารดังต่อไปนี้เพื่อการตรวจสอบตัวตน', //!
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Column(
                  children: identityProofingPreset
                      .map((identityProofing) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: UiConfig.lineGap,
                            ),
                            child:
                                _buildCheckBoxTile(context, identityProofing),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //? Checkbox List
  Widget _buildCheckBoxTile(
      BuildContext context, PowerVerificationModel powerVerification) {
    final data = context
        .read<FormDataSubjectRightCubit>()
        .state
        .dataSubjectRight
        .identityVerifications;
    final selectIds = data.map((category) => category.id).toList();

    final String? url = data
        .where((item) => item.id == powerVerification.id)
        .firstOrNull
        ?.imageUrl;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: UiConfig.actionSpacing,
              ),
              child: CustomCheckBox(
                value: selectIds.contains(powerVerification.id),
                onChanged: (_) {
                  context
                      .read<FormDataSubjectRightCubit>()
                      .formDataSubjectRightIdentityChecked(
                          powerVerification.id);
                },
              ),
            ),
            Expanded(
              child: Text(
                powerVerification.title,
                style: !selectIds.contains(powerVerification.id)
                    ? Theme.of(context).textTheme.bodyMedium?.copyWith()
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
        ExpandedContainer(
          expand: selectIds.contains(powerVerification.id),
          duration: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.only(
              left: UiConfig.defaultPaddingSpacing * 3,
              top: UiConfig.lineGap,
              bottom: UiConfig.lineGap,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: powerVerification.additionalReq,
                  child: Column(
                    children: [
                      const SizedBox(height: UiConfig.lineSpacing),
                      Row(
                        children: <Widget>[
                          TitleRequiredText(
                            text: tr(
                                'dataSubjectRight.identityVerification.documentType'),
                            required: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: tr(
                                  'dataSubjectRight.identityVerification.hintdocumentType'),
                              onChanged: (value) {
                                final selectIds = data
                                    .map((selected) => selected.id)
                                    .toList();

                                if (selectIds.contains(powerVerification.id)) {
                                  final updatedData = data.map((item) {
                                    if (item.id == powerVerification.id) {
                                      return item.copyWith(text: value);
                                    } else {
                                      return item;
                                    }
                                  }).toList();

                                  setState(() {
                                    identityVerifications = updatedData;
                                  });

                                  context
                                      .read<FormDataSubjectRightCubit>()
                                      .setDataSubjectRight(
                                          dataSubjectRight.copyWith(
                                              identityVerifications:
                                                  identityVerifications));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Row(
                  children: <Widget>[
                    TitleRequiredText(
                      text:
                          tr('dataSubjectRight.identityVerification.copyFile'),
                      required: true,
                    ),
                  ],
                ),
                UploadFileField(
                  fileUrl: url ?? '',
                  onUploaded: (Uint8List data, String fileName) {
                    final cubit = context.read<FormDataSubjectRightCubit>();

                    cubit.uploadIdentityProofingFile(
                      data,
                      fileName,
                      UtilFunctions.getPowverVacationDsrPath(widget.companyId,
                          DataSubjectRightImageType.identityVerifications),
                      powerVerification.id,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
