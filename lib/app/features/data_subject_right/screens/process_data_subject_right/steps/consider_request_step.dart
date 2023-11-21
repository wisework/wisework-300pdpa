import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/widgets/process_consider_request.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/widgets/process_proof_of_action.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
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
                final initialProcessRequest =
                    state.initialDataSubjectRight.processRequests.firstWhere(
                  (request) => request.id == processRequest.id,
                  orElse: () => ProcessRequestModel.empty(),
                );

                return _buildProcessRequestCard(
                  context,
                  index: index + 1,
                  dataSubjectRightId: state.dataSubjectRight.id,
                  processRequest: processRequest,
                  initialProcessRequest: initialProcessRequest,
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
    required String dataSubjectRightId,
    required ProcessRequestModel processRequest,
    required ProcessRequestModel initialProcessRequest,
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
                  initialProcessRequest: initialProcessRequest,
                ),
                ExpandedContainer(
                  expand: initialProcessRequest.considerRequestStatus !=
                      RequestResultStatus.none,
                  duration: const Duration(milliseconds: 400),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: UiConfig.lineSpacing,
                    ),
                    child: ProcessProofOfAction(
                      dataSubjectRightId: dataSubjectRightId,
                      processRequest: processRequest,
                      initialProcessRequest: initialProcessRequest,
                    ),
                  ),
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
    final status = UtilFunctions.getProcessRequestStatus(processRequest);
    final Map<ProcessRequestStatus, String> processRequestStatuses = {
      ProcessRequestStatus.notProcessed: 'ยังไม่ดำเนินการ',
      ProcessRequestStatus.inProgress: 'อยู่ระหว่างการดำเนินการ',
      ProcessRequestStatus.refused: 'ปฏิเสธการดำเนินการ',
      ProcessRequestStatus.completed: 'ดำเนินการเสร็จสิ้น',
    };

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
        'สถานะ: ${processRequestStatuses[status]}',
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
        const TitleRequiredText(text: 'ข้อมูลส่วนบุคคล'),
        CustomTextField(
          controller: TextEditingController(
            text: processRequest.personalData,
          ),
          readOnly: true,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(text: 'สถานที่พบเจอ'),
        CustomTextField(
          controller: TextEditingController(
            text: processRequest.foundSource,
          ),
          readOnly: true,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(text: 'การดำเนินการ'),
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
