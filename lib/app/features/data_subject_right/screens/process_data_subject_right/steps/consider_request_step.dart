import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/presets/request_actions_preset.dart';
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
  const ConsiderRequestStep({
    super.key,
    required this.requestTypes,
    required this.reasonTypes,
    required this.currentUser,
  });

  final List<RequestTypeModel> requestTypes;
  final List<ReasonTypeModel> reasonTypes;
  final UserModel currentUser;

  @override
  State<ConsiderRequestStep> createState() => _ConsiderRequestStepState();
}

class _ConsiderRequestStepState extends State<ConsiderRequestStep> {
  final requestSelectedKey = GlobalKey();

  String processRequestSelected = '';

  @override
  void initState() {
    super.initState();

    _autoScrollToRequest();
  }

  Future<void> _autoScrollToRequest() async {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    processRequestSelected = cubit.state.processRequestSelected;

    await Future.delayed(const Duration(milliseconds: 400)).then((_) async {
      await Scrollable.ensureVisible(
        requestSelectedKey.currentContext!,
        duration: const Duration(milliseconds: 400),
      );
    });
  }

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
                    tr('dataSubjectRight.processDsr.considerTakingAction'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    tr('dataSubjectRight.StepProcessDsr.considering.resultOfInspection'),
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
                  key: processRequest.id == processRequestSelected
                      ? requestSelectedKey
                      : null,
                  index: index + 1,
                  dataSubjectRight: state.dataSubjectRight,
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
    Key? key,
    required int index,
    required DataSubjectRightModel dataSubjectRight,
    required ProcessRequestModel processRequest,
    required ProcessRequestModel initialProcessRequest,
    bool expanded = false,
  }) {
    final requestType = UtilFunctions.getRequestTypeById(
      widget.requestTypes,
      processRequest.requestType,
    );
    final description = requestType.description.firstWhere(
      (item) => item.language == widget.currentUser.defaultLanguage,
      orElse: () => const LocalizedModel.empty(),
    );

    return CustomContainer(
      key: key,
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
                      '$index. ${description.text}',
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
          _buildProcessRequestStatus(
            context,
            dataSubjectRight: dataSubjectRight,
            processRequest: processRequest,
          ),
          ExpandedContainer(
            expand: expanded,
            duration: const Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                    requestTypes: widget.requestTypes,
                    currentUser: widget.currentUser,
                  ),
                  ExpandedContainer(
                    expand: initialProcessRequest.considerRequestStatus ==
                        RequestResultStatus.pass,
                    duration: const Duration(milliseconds: 400),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: UiConfig.lineSpacing,
                      ),
                      child: ProcessProofOfAction(
                        dataSubjectRightId: dataSubjectRight.id,
                        processRequest: processRequest,
                        initialProcessRequest: initialProcessRequest,
                        requestTypes: widget.requestTypes,
                        language: widget.currentUser.defaultLanguage,
                      ),
                    ),
                  ),
                  const SizedBox(height: UiConfig.lineGap),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildProcessRequestStatus(
    BuildContext context, {
    required DataSubjectRightModel dataSubjectRight,
    required ProcessRequestModel processRequest,
  }) {
    final status = UtilFunctions.getProcessRequestStatus(
      dataSubjectRight,
      processRequest,
    );
    final Map<ProcessRequestStatus, String> statusTexts = {
      ProcessRequestStatus.notProcessed:
          tr('dataSubjectRight.StepProcessDsr.considering.notYetProcessed'),
      ProcessRequestStatus.inProgress:
          tr('dataSubjectRight.StepProcessDsr.considering.inProgress'),
      ProcessRequestStatus.refused:
          tr('dataSubjectRight.StepProcessDsr.considering.refuseProcessing'),
      ProcessRequestStatus.completed:
          tr('dataSubjectRight.StepProcessDsr.considering.completed'),
    };
    final Map<ProcessRequestStatus, Color> statusColors = {
      ProcessRequestStatus.notProcessed: const Color(0xFF878787),
      ProcessRequestStatus.inProgress: const Color(0xFF0172E6),
      ProcessRequestStatus.refused: const Color(0xFFDF2200),
      ProcessRequestStatus.completed: const Color(0xFF4FC1B1),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      decoration: BoxDecoration(
        color: statusColors[status]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      margin: const EdgeInsets.only(
        left: 18.0,
        top: UiConfig.lineGap,
        right: 18.0,
      ),
      child: Text(
        '${tr('dataSubjectRight.StepProcessDsr.considering.status')}: ${statusTexts[status]}',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: statusColors[status]),
      ),
    );
  }

  Column _buildRequestActionInfo(
    BuildContext context, {
    required ProcessRequestModel processRequest,
  }) {
    final requestAction = UtilFunctions.getRequestActionById(
      requestActionsPreset,
      processRequest.requestAction,
    );
    final title = requestAction.title.firstWhere(
      (item) => item.language == widget.currentUser.defaultLanguage,
      orElse: () => const LocalizedModel.empty(),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleRequiredText(
          text: tr(
              'dataSubjectRight.StepProcessDsr.considering.personalInformation'),
        ),
        CustomTextField(
          controller: TextEditingController(
            text: processRequest.personalData,
          ),
          readOnly: true,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('dataSubjectRight.StepProcessDsr.considering.place'),
        ),
        CustomTextField(
          controller: TextEditingController(
            text: processRequest.foundSource,
          ),
          readOnly: true,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('dataSubjectRight.StepProcessDsr.considering.operation'),
        ),
        CustomTextField(
          controller: TextEditingController(
            text: title.text,
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
          tr('dataSubjectRight.StepProcessDsr.considering.reason'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: UiConfig.lineGap),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final reasonType = UtilFunctions.getReasonTypeById(
              widget.reasonTypes,
              processRequest.reasonTypes[index].id,
            );
            final description = reasonType.description.firstWhere(
              (item) => item.language == widget.currentUser.defaultLanguage,
              orElse: () => const LocalizedModel.empty(),
            );

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomCheckBox(
                  value: true,
                  activeColor: Theme.of(context).colorScheme.outlineVariant,
                ),
                const SizedBox(width: UiConfig.actionSpacing),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      processRequest.reasonTypes[index].text.isNotEmpty
                          ? processRequest.reasonTypes[index].text
                          : description.text,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
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
