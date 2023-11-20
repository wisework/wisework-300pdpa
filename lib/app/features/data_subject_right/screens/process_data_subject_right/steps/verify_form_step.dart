import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class VerifyFormStep extends StatefulWidget {
  const VerifyFormStep({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  State<VerifyFormStep> createState() => _VerifyFormStepState();
}

class _VerifyFormStepState extends State<VerifyFormStep> {
  void _onOptionChanged(RequestResultStatus? value) {
    if (value != null) {
      final cubit = context.read<ProcessDataSubjectRightCubit>();
      cubit.setVerifyOption(value);
    }
  }

  void _onRejectReasonChanged(String value) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setRejectVerifyReason(value);
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
      child: BlocBuilder<ProcessDataSubjectRightCubit,
          ProcessDataSubjectRightState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ตรวจสอบแบบฟอร์ม',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Text(
                'ผลการตรวจสอบแบบฟอร์มคำขอใช้สิทธิ์ตามกฎหมายคุ้มครองข้อมูลส่วนบุคคล',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomRadioButton<RequestResultStatus>(
                    value: RequestResultStatus.pass,
                    selected: state.dataSubjectRight.verifyFormStatus,
                    onChanged: _onOptionChanged,
                    margin:
                        const EdgeInsets.only(right: UiConfig.actionSpacing),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'ผ่าน',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.lineGap),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomRadioButton<RequestResultStatus>(
                    value: RequestResultStatus.fail,
                    selected: state.dataSubjectRight.verifyFormStatus,
                    onChanged: _onOptionChanged,
                    margin:
                        const EdgeInsets.only(right: UiConfig.actionSpacing),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'ไม่ผ่าน',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          ExpandedContainer(
                            expand: state.dataSubjectRight.verifyFormStatus ==
                                RequestResultStatus.fail,
                            duration: const Duration(milliseconds: 400),
                            child: Form(
                              key: widget.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(height: UiConfig.lineGap),
                                  const TitleRequiredText(
                                    text: 'เหตุผลประกอบ',
                                    required: true,
                                  ),
                                  CustomTextField(
                                    initialValue: state
                                        .dataSubjectRight.rejectVerifyReason,
                                    hintText: 'เนื่องด้วย...',
                                    maxLines: 5,
                                    onChanged: _onRejectReasonChanged,
                                    required: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  const SizedBox(height: UiConfig.lineGap),
                  _buildWarningContainer(
                    context,
                    isWarning: state.verifyError,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  ExpandedContainer _buildWarningContainer(
    BuildContext context, {
    required bool isWarning,
  }) {
    return ExpandedContainer(
      expand: isWarning,
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          border: Border.all(
            color: Theme.of(context).colorScheme.onError,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: UiConfig.textSpacing),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Icon(
                Icons.warning_outlined,
                size: 18.0,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            const SizedBox(width: UiConfig.textSpacing),
            Expanded(
              child: Text(
                'โปรดเลือกตัวเลือกเพื่อดำเนินการต่อ',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
