import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:pdpa/app/config/config.dart';

import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';

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
  bool? checkboxValue1 = false;
  bool? checkboxValue2 = false;

  late TextEditingController identityDataController;
  late TextEditingController foundedPlaceTextController;
  late int selectedRadioTile;

  List<RequestTypeModel> selectRequestType = [];
  List<ReasonTypeModel> selectReasonType = [];

  void _setRequestType(RequestTypeModel requestType) {
    final selectIds = selectRequestType.map((selected) => selected.id).toList();

    setState(() {
      if (selectIds.contains(requestType.id)) {
        selectRequestType = selectRequestType
            .where((selected) => selected.id != requestType.id)
            .toList();
      } else {
        selectRequestType = selectRequestType
            .map((selected) => selected)
            .toList()
          ..add(requestType);
      }
    });
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

  @override
  void initState() {
    identityDataController = TextEditingController();
    foundedPlaceTextController = TextEditingController();

    selectedRadioTile = 1;

    super.initState();
  }

  @override
  void dispose() {
    identityDataController.dispose();
    foundedPlaceTextController.dispose();

    super.dispose();
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
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
    final selectRequestTypeIds =
        selectRequestType.map((category) => category.id).toList();
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
                onChanged: (bool? value) {
                  _setRequestType(requestType);
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
            context,
            widget.reasonType,
            selectRequestTypeIds.contains(requestType.id),
          ),
        ), //? Reasons Id
      ],
    );
  }

  //? Expanded Children
  ExpandedContainer _buildExpandedContainer(
      BuildContext context, List<ReasonTypeModel> reasonType, bool isExpanded) {
    final selectReasonTypeIds =
        selectReasonType.map((category) => category.id).toList();
    return ExpandedContainer(
      expand: isExpanded,
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
            hintText: tr('dataSubjectRight.requestReason.hintpersonalInformation'), 
            controller: identityDataController,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.requestReason.place'), 
          ),
          CustomTextField(
            controller: foundedPlaceTextController,
            hintText: tr('dataSubjectRight.requestReason.hintPlace'), 
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.requestReason.operation'), 
            required: true,
          ),
          DataSubjectRightListTile(
            title: tr('dataSubjectRight.requestReason.delete'),
            onTap: () {
              setSelectedRadioTile(1);
            },
            leading: CustomRadioButton(
              value: 1,
              selected: selectedRadioTile,
              onChanged: (val) {
                setSelectedRadioTile(val!);
              },
            ),
          ),
          Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
          DataSubjectRightListTile(
            title: tr('dataSubjectRight.requestReason.nonDestructive'),
            onTap: () {
              setSelectedRadioTile(2);
            },
            leading: CustomRadioButton(
              value: 2,
              selected: selectedRadioTile,
              onChanged: (val) {
                setSelectedRadioTile(val!);
              },
            ),
          ),
          Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
          DataSubjectRightListTile(
            title: tr('dataSubjectRight.requestReason.impossibleToIdentifyYourself'),
            onTap: () {
              setSelectedRadioTile(3);
            },
            leading: CustomRadioButton(
              value: 3,
              selected: selectedRadioTile,
              onChanged: (val) {
                setSelectedRadioTile(val!);
              },
            ),
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
                                  value:
                                      selectReasonTypeIds.contains(reason.id),
                                  onChanged: (_) {
                                    _setReasonType(reason);
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
                                        .text, 
                                    style:
                                        !selectReasonTypeIds.contains(reason.id)
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
                              expand: selectReasonTypeIds.contains(reason.id),
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
                                      hintText: tr('dataSubjectRight.requestReason.hintReason'), 
                                      controller: identityDataController,
                                      required: true,
                                    ),
                                    const SizedBox(
                                        height: UiConfig.lineSpacing),
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
