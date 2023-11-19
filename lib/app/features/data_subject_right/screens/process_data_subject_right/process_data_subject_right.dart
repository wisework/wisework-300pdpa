import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/steps/processing_step.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_stepper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class ProcessDataSubjectRightScreen extends StatelessWidget {
  const ProcessDataSubjectRightScreen({
    super.key,
    required this.initialDataSubjectRight,
    required this.currentUser,
  });

  final DataSubjectRightModel initialDataSubjectRight;
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProcessDataSubjectRightCubit>(
      create: (context) => ProcessDataSubjectRightCubit()
        ..initialSettings(
          initialDataSubjectRight,
        ),
      child: ProcessDataSubjectRightView(
        currentUser: currentUser,
      ),
    );
  }
}

class ProcessDataSubjectRightView extends StatefulWidget {
  const ProcessDataSubjectRightView({
    super.key,
    required this.currentUser,
  });

  final UserModel currentUser;

  @override
  State<ProcessDataSubjectRightView> createState() =>
      _ProcessDataSubjectRightViewState();
}

class _ProcessDataSubjectRightViewState
    extends State<ProcessDataSubjectRightView> {
  final GlobalKey<FormState> _verifyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _considerFormKey = GlobalKey<FormState>();
  final int stepLength = 3;

  void _goBackAndUpdate() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    if (cubit.state.dataSubjectRight != cubit.state.initialDataSubjectRight) {
      Navigator.pop(context, cubit.state.dataSubjectRight);
    } else {
      Navigator.pop(context);
    }
  }

  String _getRequesterName() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();

    final requester = cubit.state.dataSubjectRight.dataRequester.firstWhere(
      (requester) => requester.priority == 1,
      orElse: () => RequesterInputModel.empty(),
    );
    return requester.text;
  }

  void _onNextStepPressed() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();

    if (cubit.state.verifySelected == 2) {
      if (_verifyFormKey.currentState!.validate()) {
        cubit.onNextStepPressed(stepLength);
        return;
      }
    }

    if (cubit.state.considerSelected == 2) {
      if (_considerFormKey.currentState!.validate()) {
        cubit.onNextStepPressed(stepLength);
        return;
      }
    }

    cubit.onNextStepPressed(stepLength);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: Text(
          'Process Data Subject Right', //!
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: ContentWrapper(
          child: CustomContainer(
            margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Data Subject Right (${_getRequesterName()})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                _buildCustomStepper(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  BlocBuilder _buildCustomStepper(BuildContext context) {
    return BlocBuilder<ProcessDataSubjectRightCubit,
        ProcessDataSubjectRightState>(
      builder: (context, state) {
        return CustomStepper(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          steps: <CustomStep>[
            CustomStep(
              title: Text(
                'ตรวจสอบคำขอ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: state.stepIndex >= 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              content: _buildSelectOption(
                context,
                formKey: _verifyFormKey,
                description:
                    'ผลการตรวจสอบแบบฟอร์มคำขอใช้สิทธิ์ตามกฎหมายคุ้มครองข้อมูลส่วนบุคคล',
                valueSelected: state.verifySelected,
                onSelected: (value) {
                  final cubit = context.read<ProcessDataSubjectRightCubit>();
                  cubit.setVerifyOption(value);
                },
                onRejectChanged: (value) {
                  final cubit = context.read<ProcessDataSubjectRightCubit>();
                  cubit.setRejectVerifyReason(value);
                },
                isWarning: state.verifyError,
              ),
              summaryContent: state.progressedIndex > 0
                  ? _buildSummaryOption(
                      context,
                      passText: 'ผ่าน',
                      rejectText: 'ไม่ผ่าน',
                      rejectReason: state.dataSubjectRight.rejectVerifyReason,
                      isPassed: state.dataSubjectRight.verifyFormStatus ==
                          RequestResultStatus.pass,
                    )
                  : null,
              isActive: state.stepIndex >= 0,
              endStep: state.endProcess && state.stepIndex == 0,
            ),
            CustomStep(
              title: Text(
                'พิจารณาดำเนินการ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: state.stepIndex >= 1
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              content: _buildSelectOption(
                context,
                formKey: _considerFormKey,
                description:
                    'ผลการตรวจสอบแบบฟอร์มคำขอใช้สิทธิ์ตามกฎหมายคุ้มครองข้อมูลส่วนบุคคล',
                valueSelected: state.considerSelected,
                onSelected: (value) {
                  final cubit = context.read<ProcessDataSubjectRightCubit>();
                  cubit.setConsiderOption(value);
                },
                onRejectChanged: (value) {
                  final cubit = context.read<ProcessDataSubjectRightCubit>();
                  cubit.setRejectConsiderReason(value);
                },
                isWarning: state.considerError,
              ),
              summaryContent: state.progressedIndex > 1
                  ? _buildSummaryOption(
                      context,
                      passText: 'ดำเนินการ',
                      rejectText: 'ปฏิเสธคำขอ',
                      rejectReason: state.dataSubjectRight.rejectConsiderReason,
                      isPassed: state.dataSubjectRight.considerFormStatus ==
                          RequestResultStatus.pass,
                    )
                  : null,
              isActive: state.stepIndex >= 1,
              endStep: state.endProcess && state.stepIndex == 1,
            ),
            CustomStep(
              title: Text(
                'ดำเนินการ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: state.stepIndex >= 2
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              content: const ProcessingStep(),
              summaryContent: state.progressedIndex > 2
                  ? _buildSummaryProcess(context)
                  : null,
              isActive: state.stepIndex >= 2,
              endStep: state.endProcess && state.stepIndex == 2,
            ),
          ],
          currentStep: state.stepIndex,
          progressStep: state.progressedIndex,
          nextButtonText: 'ส่งผลการตรวจสอบ',
          onNextStep: state.stepIndex != 3 ? _onNextStepPressed : null,
        );
      },
    );
  }

  Column _buildSelectOption(
    BuildContext context, {
    required GlobalKey<FormState> formKey,
    required String description,
    required int valueSelected,
    required Function(int value) onSelected,
    required Function(String value) onRejectChanged,
    required bool isWarning,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomRadioButton<int>(
              value: 1,
              selected: valueSelected,
              onChanged: (value) {
                if (value != null) {
                  onSelected(value);
                }
              },
              margin: const EdgeInsets.only(right: UiConfig.actionSpacing),
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
            CustomRadioButton<int>(
              value: 2,
              selected: valueSelected,
              onChanged: (value) {
                if (value != null) {
                  onSelected(value);
                }
              },
              margin: const EdgeInsets.only(right: UiConfig.actionSpacing),
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
                      expand: valueSelected == 2,
                      duration: const Duration(milliseconds: 400),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: UiConfig.lineGap),
                            const TitleRequiredText(
                              text: 'เหตุผลประกอบ',
                              required: true,
                            ),
                            CustomTextField(
                              hintText: 'เนื่องด้วย...',
                              maxLines: 5,
                              onChanged: (value) {
                                onRejectChanged(value);
                              },
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
              isWarning: isWarning,
            )
          ],
        ),
      ],
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

  Container _buildSummaryOption(
    BuildContext context, {
    required String passText,
    required String rejectText,
    required String rejectReason,
    required bool isPassed,
  }) {
    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.circle,
                size: 8.0,
                color: isPassed ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  isPassed ? passText : rejectText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          if (rejectReason.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                rejectReason,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }

  Container _buildSummaryProcess(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 100.0,
            height: 100.0,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(UiConfig.actionSpacing),
              child: Text(
                'แก้ไขแล้ว',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.75,
            child: CustomIconButton(
              onPressed: () {},
              icon: Ionicons.eye_outline,
              iconColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
