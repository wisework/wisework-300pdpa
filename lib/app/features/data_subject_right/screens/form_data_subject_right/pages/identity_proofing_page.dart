import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/power_verification_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class IdentityProofingPage extends StatefulWidget {
  const IdentityProofingPage({
    super.key,
  });

  @override
  State<IdentityProofingPage> createState() => _IdentityProofingPageState();
}

class _IdentityProofingPageState extends State<IdentityProofingPage> {
  bool isExpanded = false;
  List<PowerVerificationModel> selectIdentityProofing = [];
  late DataSubjectRightModel dataSubjectRight;
  @override
  void initState() {
    dataSubjectRight =
        context.read<FormDataSubjectRightCubit>().state.dataSubjectRight;

    super.initState();
  }

  void _setIdentityProofing(PowerVerificationModel identityProofing) {
    final selectIds =
        selectIdentityProofing.map((selected) => selected.id).toList();

    setState(() {
      if (selectIds.contains(identityProofing.id)) {
        selectIdentityProofing = selectIdentityProofing
            .where((selected) => selected.id != identityProofing.id)
            .toList();
      } else {
        selectIdentityProofing = selectIdentityProofing
            .map((selected) => selected)
            .toList()
          ..add(identityProofing);
      }
    });
  }

  List<PowerVerificationModel> identityProofing = [
    PowerVerificationModel(
      id: '1',
      title:
          tr('dataSubjectRight.identityVerification.copyOfHouseRegistration'),
      additionalReq: false,
    ),
    PowerVerificationModel(
      id: '2',
      title:
          tr('dataSubjectRight.identityVerification.copyOfIdentificationCare'),
      additionalReq: false,
    ),
    PowerVerificationModel(
      id: '3',
      title: tr('dataSubjectRight.identityVerification.copyOfPassport'),
      additionalReq: false,
    ),
    PowerVerificationModel(
      id: '4',
      title: tr('dataSubjectRight.identityVerification.other'),
      additionalReq: true,
    ),
  ];
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
                  children: identityProofing
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
    final selectIds =
        selectIdentityProofing.map((category) => category.id).toList();

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
                  _setIdentityProofing(powerVerification);
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
                      SizedBox(height: UiConfig.lineSpacing),
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomTextField(
                        hintText: tr(
                            'dataSubjectRight.identityVerification.fileNotSelected'),
                        readOnly: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: CustomIconButton(
                        onPressed: () {},
                        icon: Ionicons.cloud_upload,
                        iconColor: Theme.of(context).colorScheme.primary,
                        backgroundColor:
                            Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
