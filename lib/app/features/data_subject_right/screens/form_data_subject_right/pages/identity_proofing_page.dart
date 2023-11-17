import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class IdentityProofingPage extends StatefulWidget {
  const IdentityProofingPage({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.previousPage,
  });

  final PageController controller;
  final int currentPage;
  final int previousPage;

  @override
  State<IdentityProofingPage> createState() => _IdentityProofingPageState();
}

class _IdentityProofingPageState extends State<IdentityProofingPage> {
  bool isExpanded = false;

  void _setExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  List<String> power = [
    'สำเนาทะเบียนบ้าน',
    'สำเนาบัตรประชาชน (กรณีสัญชาติไทย)',
    'สำเนาพาสสปอร์ต (กรณีต่างชาติ)',
    'อื่นๆ ถ้ามี (โปรดระบุ)'
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
                    'เอกสารพิสูจน์ตัวตนและพิสูจน์ถิ่นที่อยู่เจ้าของข้อมูล', //!
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    'ข้าพเจ้าได้แนบเอกสารดังต่อไปนี้เพื่อการตรวจสอบตัวตน', //!
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Column(
                    children: power
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

  //? Checkbox List
  Widget _buildCheckBoxTile(BuildContext context, String name) {
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
                        name, //!
                        style: isExpanded == false
                            ? Theme.of(context).textTheme.bodyMedium?.copyWith()
                            : Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: UiConfig.textLineSpacing),
                  _buildExpandedContainer(context, name),
                ],
              ),
            ),
          ],
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
    if (widget.previousPage == 1) {
      widget.controller.animateToPage(1,
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
      context.read<FormDataSubjectRightCubit>().nextPage(1);
    } else {
      widget.controller.animateToPage(widget.currentPage - 1,
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
      context
          .read<FormDataSubjectRightCubit>()
          .nextPage(widget.currentPage - 1);
    }
  }

  //? Expanded Children
  ExpandedContainer _buildExpandedContainer(BuildContext context, String name) {
    return ExpandedContainer(
      expand: isExpanded,
      duration: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
              visible: name.contains('อื่นๆ ถ้ามี (โปรดระบุ)'),
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
