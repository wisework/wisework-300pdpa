import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pdpa/app/config/config.dart';

import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';

import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/presets/request_actions_preset.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';

import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_list_tile.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class RequestReasonPage extends StatefulWidget {
  const RequestReasonPage({
    super.key,
    required this.requestType,
    required this.reasonType,
  });

  final List<RequestTypeModel> requestType;
  final List<ReasonTypeModel> reasonType;

  @override
  State<RequestReasonPage> createState() => _RequestReasonPageState();
}

class _RequestReasonPageState extends State<RequestReasonPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final processRequests = context.select(
      (FormDataSubjectRightCubit cubit) => cubit.state.processRequests,
    );
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
                Text(
                  tr('dataSubjectRight.requestReason.title'),
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Text(
                  tr('dataSubjectRight.requestReason.pleaseSelect'),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.requestType.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: UiConfig.lineGap),
                  itemBuilder: (_, index) {
                    return _buildCheckBoxTile(
                        context, widget.requestType[index], processRequests);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //? Checkbox List
  Widget _buildCheckBoxTile(BuildContext context, RequestTypeModel requestType,
      List<ProcessRequestModel> processRequests) {
    final selectRequestTypeIds =
        processRequests.map((category) => category.id).toList();
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: UiConfig.actionSpacing,
              ),
              child: CustomCheckBox(
                value: selectRequestTypeIds.contains(requestType.id),
                onChanged: (_) {
                  context
                      .read<FormDataSubjectRightCubit>()
                      .formDataSubjectRightProcessRequestChecked(
                          requestType.id);
                },
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    requestType.description
                        .firstWhere(
                          (item) => item.language == 'th-TH',
                          orElse: () => const LocalizedModel.empty(),
                        )
                        .text,
                    style: !selectRequestTypeIds.contains(requestType.id)
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: UiConfig.textLineSpacing),
        Padding(
          padding: const EdgeInsets.only(
            left: UiConfig.defaultPaddingSpacing * 3,
            top: UiConfig.lineGap,
          ),
          child: _buildExpandedContainer(context, requestType, processRequests),
        ),
      ],
    );
  }

  //? Expanded Children
  ExpandedContainer _buildExpandedContainer(BuildContext context,
      RequestTypeModel requestType, List<ProcessRequestModel> processRequests) {
    final selectRequestTypeIds =
        Set.from(processRequests.map((category) => category.id));

    return ExpandedContainer(
      expand: selectRequestTypeIds.contains(requestType.id),
      duration: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('dataSubjectRight.requestReason.iadoperations'),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('dataSubjectRight.requestReason.personalInformation'),
            required: true,
          ),
          CustomTextField(
            hintText:
                tr('dataSubjectRight.requestReason.hintpersonalInformation'),
            required: true,
            onChanged: (value) {
              context
                  .read<FormDataSubjectRightCubit>()
                  .personalDataChanged(value, requestType.id);
            },
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('dataSubjectRight.requestReason.place'),
          ),
          CustomTextField(
            hintText: tr('dataSubjectRight.requestReason.hintPlace'),
            onChanged: (value) {
              context
                  .read<FormDataSubjectRightCubit>()
                  .foundSourceChanged(value, requestType.id);
            },
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('dataSubjectRight.requestReason.operation'),
            required: true,
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: requestActionsPreset.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: UiConfig.lineGap), // ตัวคั่นระหว่าง Item
            itemBuilder: (_, index) {
              return DataSubjectRightListTile(
                title: requestActionsPreset[index]
                    .title
                    .firstWhere(
                      (item) => item.language == 'th-TH',
                      orElse: () => const LocalizedModel.empty(),
                    )
                    .text,
                onTap: () {
                  if (selectRequestTypeIds.contains(requestType.id)) {
                    final updatedData = processRequests.map((item) {
                      return (item.id == requestType.id)
                          ? item.copyWith(
                              requestAction: requestActionsPreset[index].id)
                          : item;
                    }).toList();

                    context
                        .read<FormDataSubjectRightCubit>()
                        .setProcessRequests(updatedData);
                  }
                },
                leading: CustomRadioButton(
                  value: requestActionsPreset[index].id,
                  selected: processRequests
                      .firstWhere((request) => request.id == requestType.id,
                          orElse: () => ProcessRequestModel.empty())
                      .requestAction,
                  onChanged: (val) {
                    if (selectRequestTypeIds.contains(requestType.id)) {
                      final updatedData = processRequests.map((item) {
                        return (item.id == requestType.id)
                            ? item.copyWith(
                                requestAction: requestActionsPreset[index].id)
                            : item;
                      }).toList();

                      context
                          .read<FormDataSubjectRightCubit>()
                          .setProcessRequests(updatedData);
                    }
                  },
                ),
              );
            },
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Text(
            tr('dataSubjectRight.requestReason.reasonsRequest'),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.reasonType.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: UiConfig.lineGap),
            itemBuilder: (_, index) {
              final processRequest = processRequests.firstWhere(
                (request) => request.id == requestType.id,
                orElse: () => ProcessRequestModel.empty(),
              );
              final reason = widget.reasonType[index];
              final reasonId = reason.id;
              final isReasonSelected = processRequest.reasonTypes
                  .map((reason) => reason.id)
                  .contains(reasonId);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4.0,
                          right: UiConfig.actionSpacing,
                        ),
                        child: CustomCheckBox(
                          value: isReasonSelected,
                          onChanged: (_) {
                            context
                                .read<FormDataSubjectRightCubit>()
                                .formDataSubjectRightReasonChecked(
                                  requestType.id,
                                  reasonId,
                                );
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            reason.description
                                .firstWhere(
                                  (item) => item.language == 'th-TH',
                                  orElse: () => const LocalizedModel.empty(),
                                )
                                .text,
                            style: isReasonSelected
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (reason.requiredInputReasonText == true)
                    ExpandedContainer(
                      expand: isReasonSelected,
                      duration: const Duration(milliseconds: 400),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: UiConfig.defaultPaddingSpacing * 3,
                          bottom: UiConfig.lineGap,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleRequiredText(
                              text: tr('dataSubjectRight.requestReason.reason'),
                              required: true,
                            ),
                            CustomTextField(
                              hintText: tr(
                                  'dataSubjectRight.requestReason.hintReason'),
                              required: true,
                              onChanged: (text) {
                                context
                                    .read<FormDataSubjectRightCubit>()
                                    .formDataSubjectRightReasonInput(
                                      text,
                                      requestType.id,
                                      reasonId,
                                    );
                              },
                            ),
                            const SizedBox(height: UiConfig.lineSpacing),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
