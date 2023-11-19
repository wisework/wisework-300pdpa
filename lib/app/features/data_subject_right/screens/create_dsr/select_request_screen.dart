import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_list_tile.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class RequestSelectRequestScreen extends StatefulWidget {
  const RequestSelectRequestScreen({super.key});

  @override
  State<RequestSelectRequestScreen> createState() =>
      _RequestSelectRequestScreenState();
}

class _RequestSelectRequestScreenState
    extends State<RequestSelectRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return const SelectRequestView();
  }

  // _checkOtherFile() {
  //   return Column(
  //     children: [
  //       CheckboxListTile(
  //         side: const BorderSide(color: Color(0xff2684FF)),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         value: checkboxValue1,
  //         onChanged: (bool? value) {
  //           if (value != checkboxValue1) {
  //             setState(() {
  //               checkboxValue1 = value;
  //             });
  //           }
  //         },
  //         title: Transform.translate(
  //           offset: const Offset(-16, 0),
  //           child: Text("ระงับการประมวลผลข้อมูล",
  //               style: checkboxValue1 == false
  //                   ? Theme.of(context).textTheme.bodySmall?.copyWith()
  //                   : Theme.of(context).textTheme.bodySmall?.copyWith(
  //                       color: Theme.of(context).colorScheme.primary)),
  //         ),
  //       ),
  //       Visibility(
  //         visible: checkboxValue1 == true,
  //         child:
  //       ),
  //     ],
  //   );
  // }
}

class SelectRequestView extends StatefulWidget {
  const SelectRequestView({super.key});

  @override
  State<SelectRequestView> createState() => _SelectRequestViewState();
}

class _SelectRequestViewState extends State<SelectRequestView> {
  bool? checkboxValue1 = false;
  bool? checkboxValue2 = false;

  late TextEditingController identityDataController;
  late TextEditingController foundedPlaceTextController;
  late int selectedRadioTile;

  @override
  void initState() {
    identityDataController = TextEditingController();
    foundedPlaceTextController = TextEditingController();
    // ตั้งค่าค่าเริ่มต้นของ Radio

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

  // Map<String, bool> choices = {
  //   'อยู่ในระหว่างการตรวจสอบตามที่เจ้าของข้อมูลส่วนบุคคลร้องขอให้บริษัทแก้ไขข้อมูลส่วนบุคคล':
  //       false,
  //   'เป็นข้อมูลส่วนบุคคลที่ต้องลบหรือทำลาย เพราะเป็นการประมวลผลข้อมูลส่วนบุคคลโดยไม่ชอบด้วยกฎหมายแต่เจ้าของข้อมูลส่วนบุคคลประสงค์ขอให้ระงับการใช้แทน ':
  //       false,
  //   'ข้อมูลส่วนบุคคลหมดความจำเป็นในการเก็บรักษาไว้ตามวัตถุประสงค์ในการประมวลผลแต่เจ้าของข้อมูลส่วนบุคคลมีความจำเป็นต้องขอให้เก็บรักษาไว้เพื่อใช้ในการก่อตั้งสิทธิเรียกร้องตามกฎหมายการปฏิบัติตามหรือการใช้สิทธิเรียกร้องตามกฎหมาย':
  //       false,
  //   'เหตุผลอื่นๆ โปรดระบุ': false,
  // }; // ตั้งค่า Checkbox เริ่มต้น
  // String otherReason = '';

  final requestReason = [
    RequestReasonTemplateModel(
      id: '1',
      requestTypeId: 'ID:1',
      reasonTypes: const [],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.now(),
      updatedBy: '',
      updatedDate: DateTime.now(),
    ),
    RequestReasonTemplateModel(
      id: '2',
      requestTypeId: 'ID:2',
      reasonTypes: const [],
      status: ActiveStatus.active,
      createdBy: '',
      createdDate: DateTime.now(),
      updatedBy: '',
      updatedDate: DateTime.now(),
    ),
  ];
  bool isExpanded = false;

  void _setExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icons.chevron_left_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          'แบบฟอร์มขอใช้สิทธิ์ตามกฏหมาย', //!
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
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
                    children: requestReason
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: UiConfig.lineGap,
                              ),
                              child: _buildCheckBoxTile(context, item),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  CustomButton(
                    height: 40.0,
                    onPressed: () {
                      context.push(DataSubjectRightRoute.stepSix.path);
                    },
                    child: Text(
                      'ถัดไป', //!
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //? Checkbox List
  Widget _buildCheckBoxTile(
      BuildContext context, RequestReasonTemplateModel requestReason) {
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
                        requestReason.requestTypeId, //!
                        style: isExpanded == false
                            ? Theme.of(context).textTheme.bodyMedium?.copyWith()
                            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: UiConfig.textLineSpacing),
                  _buildExpandedContainer(
                      context, requestReason.reasonTypes), //? Reasons Id
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
      BuildContext context, List<ReasonTypeModel> reasons) {
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
          // Column(
          //   children: choices.keys.map((String choice) {
          //     return choice == 'เหตุผลอื่นๆ โปรดระบุ'
          //         ? Column(
          //             children: [
          //               CheckboxListTile(
          //                 controlAffinity: ListTileControlAffinity.leading,
          //                 contentPadding: const EdgeInsets.only(
          //                     top: 0, left: 0, right: 16, bottom: 0),
          //                 title: Text(choice,
          //                     style: Theme.of(context).textTheme.bodyMedium),
          //                 value: choices[choice]!,
          //                 onChanged: (bool? value) {
          //                   setState(() {
          //                     choices[choice] = value!;
          //                   });
          //                 },
          //               ),
          //               if (choices[choice]!)
          //                 Padding(
          //                   padding: const EdgeInsets.only(left: 16.0),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       const TitleRequiredText(
          //                         text: 'เหตุผล',
          //                         required: true,
          //                       ),
          //                       TextField(
          //                         onChanged: (value) {
          //                           setState(() {
          //                             otherReason = value;
          //                           });
          //                         },
          //                         decoration: const InputDecoration(
          //                           hintText: 'เหตุผล',
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //             ],
          //           )
          //         : CheckboxListTile(
          //             controlAffinity: ListTileControlAffinity.leading,
          //             contentPadding: const EdgeInsets.only(
          //                 top: 0, left: 0, right: 16, bottom: 0),
          //             title: Text(choice,
          //                 style: Theme.of(context).textTheme.bodyMedium),
          //             value: choices[choice]!,
          //             onChanged: (bool? value) {
          //               setState(() {
          //                 choices[choice] = value!;
          //               });
          //             },
          //           );
          //   }).toList(),
          // ),
          Column(
            children: reasons
                .map(
                  (text) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: UiConfig.lineGap,
                      ),
                      child: text == 'เหตุผลอื่นๆ (โปรดระบุ)'
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
                                                text.description.first.text, //!
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
                              context, text.description.first.text, //!
                            )),
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
