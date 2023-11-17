import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/power_verification_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class PowerOfAttorneyPage extends StatefulWidget {
  const PowerOfAttorneyPage({
    super.key,
    required this.controller,
    required this.currentPage,
  });

  final PageController controller;
  final int currentPage;

  @override
  State<PowerOfAttorneyPage> createState() => _PowerOfAttorneyPageState();
}

class _PowerOfAttorneyPageState extends State<PowerOfAttorneyPage> {
  bool isExpanded = false;

  void _setExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  List<PowerVerificationModel> powerVerifications = const [
    PowerVerificationModel(
      id: '1',
      title: 'หนังสือมอบอำนาจ',
      additionalReq: false,
    ),
    PowerVerificationModel(
      id: '2',
      title: 'อื่นๆ ถ้ามี (โปรดระบุ)',
      additionalReq: true,
    ),
  ];

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
                    'เอกสารพิสูจน์อำนาจดำเนินการแทน', //!
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    'ทั้งนี้ข้าพเจ้าได้แนบเอกสารดังต่อไปนี้เพื่อการตรวจสอบอำนาจตัวตนและถิ่นที่อยู่ของผู้ยื่นคำร้องและเจ้าของข้อมูลส่วนบุคคลเพื่อให้บริษัทสามารถดำเนินการตามสิทธิที่ร้องขอได้อย่างถูกต้อง', //!
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Column(
                    children: powerVerifications
                        .map((menu) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: UiConfig.lineGap,
                              ),
                              child: _buildCheckBoxTile(context, menu),
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
          child: Text(
            tr("app.next"),
          ),
        ),
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
      BuildContext context, PowerVerificationModel powerVerification) {
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
                        powerVerification.title, //!
                        style: isExpanded == false
                            ? Theme.of(context).textTheme.bodyMedium?.copyWith()
                            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: UiConfig.textLineSpacing),
                  _buildExpandedContainer(
                      context, powerVerification.additionalReq),
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
      BuildContext context, bool additionalReq) {
    return ExpandedContainer(
      expand: isExpanded,
      duration: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
              visible: additionalReq,
              child: const Column(
                children: [
                  Row(
                    children: <Widget>[
                      TitleRequiredText(
                        text: 'ประเภทเอกสาร',
                        required: true, //!
                      ),
                    ],
                  ),
                  SizedBox(height: UiConfig.lineSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: 'ระบุประเภทเอกสาร',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: UiConfig.lineSpacing),
                ],
              )),
          const Row(
            children: <Widget>[
              TitleRequiredText(
                text: 'ไฟล์สำเนา',
                required: true, //!
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              const Expanded(
                child: CustomTextField(
                  hintText: 'ไม่ได้เลือกไฟล์',
                  readOnly: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomIconButton(
                  onPressed: () {},
                  icon: Ionicons.cloud_upload,
                  iconColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }
}
