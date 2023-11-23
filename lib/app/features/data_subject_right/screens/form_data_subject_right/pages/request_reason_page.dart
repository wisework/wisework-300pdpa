import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
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
  late int selectedRadioTile;

  List<ProcessRequestModel> precessRequests = [];

  List<RequestTypeModel> selectRequestType = [];
  List<ReasonTypeModel> selectReasonType = [];

  late DataSubjectRightModel dataSubjectRight;
  @override
  void initState() {
    dataSubjectRight =
        context.read<FormDataSubjectRightCubit>().state.dataSubjectRight;
    selectedRadioTile = 1;
    super.initState();
  }

  void _setReasonType(ReasonTypeModel reasonType) {
    final selectIds = selectReasonType.map((selected) => selected.id).toList();

    setState(() {
      if (selectIds.contains(reasonType.id)) {
        selectReasonType = selectReasonType
            .where((selected) => selected.id != reasonType.id)
            .toList();
      } else {
        selectReasonType = selectReasonType.map((selected) => selected).toList()
          ..add(reasonType);
      }
    });
  }

  // setSelectedRadioTile(int val, String requestAction) {
  //   setState(() {
  //     selectedRadioTile = val;
  //   });
  // }

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
                Text(
                  'ต้องการยื่นคำร้องขอเพื่อจุดประสงค์ดังต่อไปนี้',
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Text(
                  'โปรดเลือกจุดประสงค์ที่ท่านต้องการ',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                // _checkOtherFile(),
                Column(
                  children: widget.requestType
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: UiConfig.lineGap,
                            ),
                            child: _buildCheckBoxTile(context, item),
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
      BuildContext context, RequestTypeModel requestType) {
    final data = context
        .read<FormDataSubjectRightCubit>()
        .state
        .dataSubjectRight
        .processRequests;
    final selectRequestTypeIds = data.map((category) => category.id).toList();

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
                        .text, //!
                    style: !selectRequestTypeIds.contains(requestType.id)
                        ? Theme.of(context).textTheme.bodyMedium?.copyWith()
                        : Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary),
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
          child: _buildExpandedContainer(
              context, widget.reasonType, requestType, data),
        ), //? Reasons Id
      ],
    );
  }

  //? Expanded Children
  ExpandedContainer _buildExpandedContainer(
      BuildContext context,
      List<ReasonTypeModel> reasonType,
      RequestTypeModel requestType,
      List<ProcessRequestModel> data) {
    final selectRequestTypeIds = data.map((category) => category.id).toList();
    final reasonTypes = data
        .expand((processRequest) =>
            processRequest.reasonTypes.map((userInputText) => userInputText.id))
        .toList();
    return ExpandedContainer(
      expand: selectRequestTypeIds.contains(requestType.id),
      duration: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // กำหนดให้ชิดซ้าย
        children: [
          Text(
            'ข้อมูลและรายละเอียดการดำเนินการ', //!
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'ข้อมูลส่วนบุคคล', //!
            required: true,
          ),
          CustomTextField(
            hintText: 'กรอกข้อมูลส่วนบุคคล', //!
            required: true,
            onChanged: (value) {
              if (selectRequestTypeIds.contains(requestType.id)) {
                final updatedData = data.map((item) {
                  if (item.id == requestType.id) {
                    return item.copyWith(personalData: value);
                  } else {
                    return item;
                  }
                }).toList();

                setState(() {
                  precessRequests = updatedData;
                });

                context.read<FormDataSubjectRightCubit>().setDataSubjectRight(
                    dataSubjectRight.copyWith(processRequests: updatedData));
              }
            },
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'สถานที่พบเจอ', //!
          ),
          CustomTextField(
            hintText: 'กรอกสถานที่พบเจอ',
            onChanged: (value) {
              if (selectRequestTypeIds.contains(requestType.id)) {
                final updatedData = data.map((item) {
                  if (item.id == requestType.id) {
                    return item.copyWith(foundSource: value);
                  } else {
                    return item;
                  }
                }).toList();

                setState(() {
                  precessRequests = updatedData;
                });

                context.read<FormDataSubjectRightCubit>().setDataSubjectRight(
                    dataSubjectRight.copyWith(processRequests: updatedData));
              }
            },
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'การดำเนินการ', //!
            required: true,
          ),
          Column(
            children: requestActionsPreset
                .map((requestActions) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: UiConfig.lineGap,
                      ),
                      child: DataSubjectRightListTile(
                        title: requestActions.title
                            .firstWhere(
                              (item) => item.language == 'th-TH',
                              orElse: () => const LocalizedModel.empty(),
                            )
                            .text,
                        onTap: () {
                          setState(() {
                            selectedRadioTile = requestActions.priority;
                          });
                          if (selectRequestTypeIds.contains(requestType.id)) {
                            final updatedData = data.map((item) {
                              if (item.id == requestType.id) {
                                return item.copyWith(
                                    requestAction: requestActions.id);
                              } else {
                                return item;
                              }
                            }).toList();

                            setState(() {
                              precessRequests = updatedData;
                            });

                            context
                                .read<FormDataSubjectRightCubit>()
                                .setDataSubjectRight(dataSubjectRight.copyWith(
                                    processRequests: updatedData));

                            print(context
                                .read<FormDataSubjectRightCubit>()
                                .state
                                .dataSubjectRight
                                .processRequests);
                          }
                          // setSelectedRadioTile(
                          //     requestActions.priority, requestActions.id);
                        },
                        leading: CustomRadioButton(
                          value: requestActions.priority,
                          selected: selectedRadioTile,
                          onChanged: (val) {
                            setState(() {
                              selectedRadioTile = requestActions.priority;
                            });
                            if (selectRequestTypeIds.contains(requestType.id)) {
                              final updatedData = data.map((item) {
                                if (item.id == requestType.id) {
                                  return item.copyWith(
                                      requestAction: requestActions.id);
                                } else {
                                  return item;
                                }
                              }).toList();

                              setState(() {
                                precessRequests = updatedData;
                              });

                              context
                                  .read<FormDataSubjectRightCubit>()
                                  .setDataSubjectRight(dataSubjectRight
                                      .copyWith(processRequests: updatedData));
                            }
                            print(context
                                .read<FormDataSubjectRightCubit>()
                                .state
                                .dataSubjectRight
                                .processRequests);
                          },
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Text(
            'เหตุผลประกอบคำร้อง',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Column(
            children: reasonType
                .map(
                  (reason) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: UiConfig.lineGap,
                      ),
                      child: Column(
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
                                  value: reasonTypes.contains(reason.id),
                                  onChanged: (_) {
                                    context
                                        .read<FormDataSubjectRightCubit>()
                                        .formDataSubjectRightReasonChecked(
                                            requestType.id, reason.id);
                                    // print(context
                                    //     .read<FormDataSubjectRightCubit>()
                                    //     .state
                                    //     .dataSubjectRight
                                    //     .processRequests);
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
                                          orElse: () =>
                                              const LocalizedModel.empty(),
                                        )
                                        .text, //!
                                    style: !selectRequestTypeIds
                                            .contains(reason.id)
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith()
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (reason.requiredInputReasonText == true)
                            ExpandedContainer(
                              expand: reasonTypes.contains(reason.id),
                              duration: const Duration(milliseconds: 400),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: UiConfig.defaultPaddingSpacing * 3,
                                  bottom: UiConfig.lineGap,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitleRequiredText(
                                      text: 'เหตุผล', //!
                                      required: true,
                                    ),
                                    CustomTextField(
                                      hintText: 'กรอกเหตุผล', //!

                                      required: true,
                                      onChanged: (text) {
                                        context
                                            .read<FormDataSubjectRightCubit>()
                                            .formDataSubjectRightReasonInput(
                                                text,
                                                requestType.id,
                                                reason.id);
                                      },
                                    ),
                                    SizedBox(height: UiConfig.lineSpacing),
                                  ],
                                ),
                              ),
                            )
                        ],
                      )),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
