import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_stepper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';
import 'package:pdpa/app/shared/widgets/upload_file_field.dart';

class ProcessDataSubjectRightScreen extends StatelessWidget {
  const ProcessDataSubjectRightScreen({
    super.key,
    required this.initialDataSubjectRight,
    required this.emails,
    required this.currentUser,
  });

  final DataSubjectRightModel initialDataSubjectRight;
  final List<String> emails;
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProcessDataSubjectRightCubit>(
      create: (context) => ProcessDataSubjectRightCubit(
        generalRepository: serviceLocator(),
      )..initialSettings(
          initialDataSubjectRight,
        ),
      child: ProcessDataSubjectRightView(
        emails: emails,
        currentUser: currentUser,
      ),
    );
  }
}

class ProcessDataSubjectRightView extends StatefulWidget {
  const ProcessDataSubjectRightView({
    super.key,
    required this.emails,
    required this.currentUser,
  });

  final List<String> emails;
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

  bool isInfoExpanded = true;
  List<String> emailSelected = [];

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
            child: BlocBuilder<ProcessDataSubjectRightCubit,
                ProcessDataSubjectRightState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialInkWell(
                      onTap: () {
                        setState(() {
                          isInfoExpanded = !isInfoExpanded;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Data Subject Right (${_getRequesterName()})',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            const SizedBox(width: 2.0),
                            Icon(
                              isInfoExpanded
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up,
                              size: 20.0,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: UiConfig.lineSpacing),
                    ExpandedContainer(
                      expand: isInfoExpanded,
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _buildProcessRequestInfo(
                            context,
                            dataSubjectRight: state.dataSubjectRight,
                          ),
                          const SizedBox(height: UiConfig.lineGap),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: UiConfig.lineSpacing,
                            ),
                            child: Divider(
                              height: 0.1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildCustomStepper(context, state: state),
                    const SizedBox(height: 4.0),
                  ],
                );
              },
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

  ListView _buildProcessRequestInfo(
    BuildContext context, {
    required DataSubjectRightModel dataSubjectRight,
  }) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final processRequest = dataSubjectRight.processRequests[index];

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              processRequest.requestType,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: UiConfig.lineGap),
            const TitleRequiredText(
              text: 'ข้อมูลส่วนบุคคล',
              required: true,
            ),
            CustomTextField(
              controller: TextEditingController(
                text: processRequest.personalData,
              ),
              readOnly: true,
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            const TitleRequiredText(
              text: 'สถานที่พบเจอ',
              required: true,
            ),
            CustomTextField(
              controller: TextEditingController(
                text: processRequest.foundSource,
              ),
              readOnly: true,
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            const TitleRequiredText(
              text: 'การดำเนินการ',
              required: true,
            ),
            CustomTextField(
              controller: TextEditingController(
                text: processRequest.requestAction,
              ),
              readOnly: true,
            ),
          ],
        );
      },
      itemCount: dataSubjectRight.processRequests.length,
    );
  }

  CustomStepper _buildCustomStepper(
    BuildContext context, {
    required ProcessDataSubjectRightState state,
  }) {
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
            passText: 'ผ่าน',
            rejectText: 'ไม่ผ่าน',
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
          content: Column(
            children: <Widget>[
              _buildSelectOption(
                context,
                formKey: _considerFormKey,
                description:
                    'ผลการตรวจสอบแบบฟอร์มคำขอใช้สิทธิ์ตามกฎหมายคุ้มครองข้อมูลส่วนบุคคล',
                passText: 'ดำเนินการ',
                rejectText: 'ปฏิเสธคำขอ',
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
              if (widget.emails.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: UiConfig.lineGap,
                  ),
                  child: _buildEmailNotification(context),
                ),
            ],
          ),
          summaryContent: state.progressedIndex > 1
              ? _buildSummaryOption(
                  context,
                  passText: 'ดำเนินการ',
                  rejectText: 'ปฏิเสธคำขอ',
                  rejectReason: state.dataSubjectRight.rejectConsiderReason,
                  isPassed: state.dataSubjectRight.considerFormStatus ==
                      RequestResultStatus.pass,
                  content: emailSelected.isNotEmpty
                      ? _buildEmailNotification(
                          context,
                          readOnly: true,
                        )
                      : null,
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
          content: _buildProcessRequest(
            context,
            dataSubjectRight: state.dataSubjectRight,
          ),
          summaryContent: state.progressedIndex > 2
              ? _buildSummaryProcess(
                  context,
                  dataSubjectRight: state.dataSubjectRight,
                )
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
  }

  Column _buildSelectOption(
    BuildContext context, {
    required GlobalKey<FormState> formKey,
    required String description,
    required String passText,
    required String rejectText,
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
                  passText,
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
                      rejectText,
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

  Column _buildEmailNotification(
    BuildContext context, {
    bool readOnly = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'แจ้งเตือนอีเมล',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(
          height: readOnly ? UiConfig.lineGap : UiConfig.lineSpacing,
        ),
        readOnly
            ? ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          emailSelected[index],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: emailSelected.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: UiConfig.lineGap,
                ),
              )
            : ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4.0,
                          right: UiConfig.actionSpacing,
                        ),
                        child: CustomCheckBox(
                          value: emailSelected.contains(widget.emails[index]),
                          onChanged: (_) {
                            setState(() {
                              if (!emailSelected
                                  .contains(widget.emails[index])) {
                                emailSelected.add(widget.emails[index]);
                              } else {
                                emailSelected.remove(widget.emails[index]);
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.emails[index],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  );
                },
                itemCount: widget.emails.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: UiConfig.lineGap,
                ),
              ),
      ],
    );
  }

  ListView _buildProcessRequest(
    BuildContext context, {
    required DataSubjectRightModel dataSubjectRight,
  }) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final processRequest = dataSubjectRight.processRequests[index];

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "หากดำเนินการเสร็จสิ้นแล้ว ให้กดปุ่ม 'อัพโหลดไฟล์' หรือ กรอกรายละเอียดผลการดำเนินการ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            UploadFileField(
              fileUrl: processRequest.proofOfActionFile,
              onUploaded: (file, data, path) {
                final cubit = context.read<ProcessDataSubjectRightCubit>();
                cubit.uploadProofFile(
                  file,
                  data,
                  kIsWeb && data != null
                      ? UtilFunctions.getUniqueFileNameByUint8List(data)
                      : UtilFunctions.getUniqueFileName(path),
                  UtilFunctions.getProcessDsrProofPath(
                    widget.currentUser.currentCompany,
                    dataSubjectRight.id,
                  ),
                  processRequest.id,
                );
              },
              onRemoved: () {},
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            const TitleRequiredText(
              text: 'รายละเอียดผลการดำเนินการ',
            ),
            CustomTextField(
              initialValue: processRequest.proofOfActionText,
              maxLines: 3,
              minLines: 1,
              onChanged: (value) {
                final cubit = context.read<ProcessDataSubjectRightCubit>();
                cubit.setProofText(value, processRequest.id);
              },
            ),
          ],
        );
      },
      itemCount: dataSubjectRight.processRequests.length,
    );
  }

  Container _buildSummaryOption(
    BuildContext context, {
    required String passText,
    required String rejectText,
    required String rejectReason,
    required bool isPassed,
    Widget? content,
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
          if (content != null)
            Padding(
              padding: const EdgeInsets.only(top: UiConfig.lineSpacing),
              child: content,
            ),
        ],
      ),
    );
  }

  ListView _buildSummaryProcess(
    BuildContext context, {
    required DataSubjectRightModel dataSubjectRight,
  }) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final processRequest = dataSubjectRight.processRequests[index];

        return Container(
          color: Theme.of(context).colorScheme.onBackground,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (processRequest.proofOfActionFile.isNotEmpty)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 100.0,
                      child: Image.network(
                        processRequest.proofOfActionFile,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: UiConfig.lineGap),
                    // CustomIconButton(
                    //   padding: const EdgeInsets.only(
                    //     left: 8.0,
                    //     top: 6.0,
                    //     right: 8.0,
                    //     bottom: 10.0,
                    //   ),
                    //   onPressed: () {
                    //     final cubit =
                    //         context.read<ProcessDataSubjectRightCubit>();
                    //     cubit.downloadProofFile(
                    //       UtilFunctions.getFileNameFromUrl(
                    //         processRequest.proofOfActionFile,
                    //       ),
                    //     );
                    //   },
                    //   icon: Ionicons.download_outline,
                    //   iconColor: Theme.of(context).colorScheme.primary,
                    //   backgroundColor:
                    //       Theme.of(context).colorScheme.onBackground,
                    // ),
                  ],
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(UiConfig.actionSpacing),
                  child: Text(
                    processRequest.proofOfActionText,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: dataSubjectRight.processRequests.length,
    );
  }
}
