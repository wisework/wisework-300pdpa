import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_list_tile.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class RequestReasonPage extends StatefulWidget {
  const RequestReasonPage({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.dataSubjectRight,
    required this.requestType,
    required this.reasonType,
  });

  final PageController controller;
  final int currentPage;
  final DataSubjectRightModel dataSubjectRight;
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

  bool isExpanded = false;

  void _setExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    'ต้องการยื่นคำร้องขอเพื่อจุดประสงค์ดังต่อไปนี้',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    'โปรดเลือกจุดประสงค์ที่ท่านต้องการ',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
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
          ),
        ),
        ContentWrapper(
          child: Container(
            padding: const EdgeInsets.all(
              UiConfig.defaultPaddingSpacing,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.outline,
                  blurRadius: 1.0,
                  offset: const Offset(0, -2.0),
                ),
              ],
            ),
            child: _buildPageViewController(
              context,
              widget.controller,
              widget.currentPage,
            ),
          ),
        ),
      ],
    );
  }

  Row _buildPageViewController(
    BuildContext context,
    PageController controller,
    int currentpage,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          onPressed: previousPage,
          child: Text(
            tr("app.previous"),
          ),
        ),
        Text("$currentpage/7"),
        TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            onPressed: nextPage,
            child: currentpage != 7
                ? Text(
                    tr("app.next"),
                  )
                : const Text("ส่งแบบคำร้อง")),
      ],
    );
  }

  void nextPage() {
    widget.controller.animateToPage(widget.currentPage + 1,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    context.read<FormDataSubjectRightCubit>().nextPage(widget.currentPage + 1);
  }

  void previousPage() {
    widget.controller.animateToPage(widget.currentPage - 1,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    context.read<FormDataSubjectRightCubit>().nextPage(widget.currentPage - 1);
  }

  //? Checkbox List
  Widget _buildCheckBoxTile(
      BuildContext context, RequestTypeModel requestType) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCheckBox(
              value: isExpanded,
              onChanged: (bool? value) {
                _setExpand();
              },
            ),
            const SizedBox(width: UiConfig.actionSpacing),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialInkWell(
                    borderRadius: BorderRadius.circular(4.0),
                    onTap: _setExpand,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        requestType.description
                            .firstWhere(
                              (item) => item.language == 'th-TH',
                              orElse: () => const LocalizedModel.empty(),
                            )
                            .text, //!
                        style: isExpanded == false
                            ? Theme.of(context).textTheme.bodyMedium?.copyWith()
                            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: UiConfig.textLineSpacing),
                  _buildExpandedContainer(
                    context,
                    widget.reasonType,
                  ), //? Reasons Id
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  //? Expanded Children
  ExpandedContainer _buildExpandedContainer(
      BuildContext context, List<ReasonTypeModel> reasonType) {
    return ExpandedContainer(
      expand: isExpanded,
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
            controller: identityDataController,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'สถานที่พบเจอ', //!
          ),
          CustomTextField(
            controller: foundedPlaceTextController,
            hintText: 'กรอกสถานที่พบเจอ', //!
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'การดำเนินการ', //!
            required: true,
          ),
          DataSubjectRightListTile(
            title: 'ลบ',
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
            title: 'ไม่ทำลาย',
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
            title: 'ทำให้ไม่สามารถระบุตัวตน',
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
            'เหตุผลประกอบคำร้อง',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          Column(
            children: reasonType
                .map(
                  (reason) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: UiConfig.lineGap,
                      ),
                      child: reason.description
                                  .firstWhere(
                                    (item) => item.language == 'th-TH',
                                    orElse: () => const LocalizedModel.empty(),
                                  )
                                  .text ==
                              'อื่นๆ (โปรดระบุ)'
                          ? Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomCheckBox(
                                      value: isExpanded,
                                      onChanged: (bool? value) {
                                        _setExpand();
                                      },
                                    ),
                                    const SizedBox(
                                        width: UiConfig.actionSpacing),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          MaterialInkWell(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            onTap: _setExpand,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Text(
                                                reason.description
                                                    .firstWhere(
                                                      (item) =>
                                                          item.language ==
                                                          'th-TH',
                                                      orElse: () =>
                                                          const LocalizedModel
                                                              .empty(),
                                                    )
                                                    .text, //!
                                                style: isExpanded == false
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith()
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              width: UiConfig.textLineSpacing),
                                          ExpandedContainer(
                                            expand: isExpanded,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start, // กำหนดให้ชิดซ้าย
                                              children: [
                                                const TitleRequiredText(
                                                  text: 'เหตุผล', //!
                                                  required: true,
                                                ),
                                                CustomTextField(
                                                  hintText: 'กรอกเหตุผล', //!
                                                  controller:
                                                      identityDataController,
                                                  required: true,
                                                ),
                                                const SizedBox(
                                                    height:
                                                        UiConfig.lineSpacing),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : _buildCheckBoxTileString(
                              context,
                              reason.description
                                  .firstWhere(
                                    (item) => item.language == 'th-TH',
                                    orElse: () => const LocalizedModel.empty(),
                                  )
                                  .text)),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  //? Checkbox List
  Widget _buildCheckBoxTileString(BuildContext context, String text) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCheckBox(
              value: isExpanded,
              onChanged: (bool? value) {
                _setExpand();
              },
            ),
            const SizedBox(width: UiConfig.actionSpacing),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialInkWell(
                    borderRadius: BorderRadius.circular(4.0),
                    onTap: _setExpand,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        text, //!
                        style: isExpanded == false
                            ? Theme.of(context).textTheme.bodyMedium?.copyWith()
                            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: UiConfig.textLineSpacing),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
