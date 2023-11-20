import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class ConsiderRequestStep extends StatefulWidget {
  const ConsiderRequestStep({super.key});

  @override
  State<ConsiderRequestStep> createState() => _ConsiderRequestStepState();
}

class _ConsiderRequestStepState extends State<ConsiderRequestStep> {
  void _setRequestExpand(String id) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setRequestExpand(id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProcessDataSubjectRightCubit,
        ProcessDataSubjectRightState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'พิจารณาดำเนินการ',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    'ผลการตรวจสอบแบบฟอร์มคำขอใช้สิทธิ์ตามกฎหมายคุ้มครองข้อมูลส่วนบุคคล',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final processRequest =
                    state.dataSubjectRight.processRequests[index];

                return _buildProcessRequestCard(
                  context,
                  index: index + 1,
                  processRequest: processRequest,
                  expanded: state.requestExpanded.contains(processRequest.id),
                );
              },
              itemCount: state.dataSubjectRight.processRequests.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: UiConfig.lineSpacing,
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        );
      },
    );
  }

  CustomContainer _buildProcessRequestCard(
    BuildContext context, {
    required int index,
    required ProcessRequestModel processRequest,
    bool expanded = false,
  }) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MaterialInkWell(
            onTap: () {
              _setRequestExpand(processRequest.id);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '$index. ${processRequest.requestType}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 2.0),
                  Icon(
                    expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: 20.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
          ExpandedContainer(
            expand: expanded,
            duration: const Duration(milliseconds: 400),
            child: Column(
              children: <Widget>[
                const SizedBox(height: UiConfig.lineSpacing),
                _buildRequestActionInfo(
                  context,
                  processRequest: processRequest,
                ),
                const SizedBox(height: UiConfig.lineGap * 2),
                _buildRequestReasonInfo(
                  context,
                  processRequest: processRequest,
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                ProcessConsiderRequest(
                  processRequest: processRequest,
                ),
              ],
            ),
          ),
          ExpandedContainer(
            expand: !expanded,
            duration: const Duration(milliseconds: 400),
            child: _buildProcessRequestStatus(
              context,
              processRequest: processRequest,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildProcessRequestStatus(
    BuildContext context, {
    required ProcessRequestModel processRequest,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      margin: const EdgeInsets.only(
        left: 18.0,
        top: UiConfig.lineGap,
      ),
      child: Text(
        'สถานะ: พิจารณาการดำเนินการ',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Column _buildRequestActionInfo(
    BuildContext context, {
    required ProcessRequestModel processRequest,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
  }

  Column _buildRequestReasonInfo(
    BuildContext context, {
    required ProcessRequestModel processRequest,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'เหตุผลประกอบคำร้อง',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: UiConfig.lineGap),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final reasonType = processRequest.reasonTypes[index];

            return Row(
              children: <Widget>[
                CustomCheckBox(
                  value: true,
                  onChanged: (_) {},
                  activeColor: Theme.of(context).colorScheme.outlineVariant,
                ),
                const SizedBox(width: UiConfig.actionSpacing),
                Expanded(
                  child: Text(
                    reasonType.text.isNotEmpty
                        ? reasonType.text
                        : reasonType.id,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            );
          },
          itemCount: processRequest.reasonTypes.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: UiConfig.lineSpacing,
          ),
        ),
      ],
    );
  }
}

class ProcessConsiderRequest extends StatefulWidget {
  const ProcessConsiderRequest({
    super.key,
    required this.processRequest,
  });

  final ProcessRequestModel processRequest;

  @override
  State<ProcessConsiderRequest> createState() => _ProcessConsiderRequestState();
}

class _ProcessConsiderRequestState extends State<ProcessConsiderRequest> {
  final GlobalKey<FormState> _considerFormKey = GlobalKey<FormState>();

  void _onOptionChanged(RequestResultStatus value, String id) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setConsiderOption(value, id);
  }

  void _onRejectReasonChanged(String value, String id) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setRejectConsiderReason(value, id);
  }

  void _onSubmitPressed() {
    if (_considerFormKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'พิจารณาดำเนินการ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: UiConfig.lineGap),
          _buildRadioOption(
            context,
            processRequest: widget.processRequest,
            onChanged: (value) {
              if (value != null) {
                _onOptionChanged(value, widget.processRequest.id);
              }
            },
            formKey: _considerFormKey,
          ),
          const SizedBox(height: UiConfig.lineGap),
          CustomButton(
            height: 45.0,
            onPressed: _onSubmitPressed,
            child: Text(
              'ส่งผลการตรวจสอบ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildRadioOption(
    BuildContext context, {
    required ProcessRequestModel processRequest,
    Function(RequestResultStatus? value)? onChanged,
    required GlobalKey<FormState> formKey,
  }) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomRadioButton<RequestResultStatus>(
              value: RequestResultStatus.pass,
              selected: processRequest.considerRequestStatus,
              onChanged: onChanged,
              margin: const EdgeInsets.only(right: UiConfig.actionSpacing),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'ดำเนินการ',
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
              selected: processRequest.considerRequestStatus,
              onChanged: onChanged,
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
                      'ปฏิเสธคำขอ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    ExpandedContainer(
                      expand: processRequest.considerRequestStatus ==
                          RequestResultStatus.fail,
                      duration: const Duration(milliseconds: 400),
                      child: Form(
                        key: _considerFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: UiConfig.lineGap),
                            const TitleRequiredText(
                              text: 'เหตุผลประกอบ',
                              required: true,
                            ),
                            CustomTextField(
                              initialValue: processRequest.rejectConsiderReason,
                              hintText: 'เนื่องด้วย...',
                              maxLines: 5,
                              onChanged: (value) {
                                _onRejectReasonChanged(
                                  value,
                                  processRequest.id,
                                );
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
            BlocBuilder<ProcessDataSubjectRightCubit,
                ProcessDataSubjectRightState>(
              builder: (context, state) {
                return _buildWarningContainer(
                  context,
                  isWarning: state.considerError.contains(processRequest.id),
                );
              },
            ),
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
}
