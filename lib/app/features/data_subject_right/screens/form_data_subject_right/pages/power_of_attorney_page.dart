import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/power_verification_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class PowerOfAttorneyPage extends StatefulWidget {
  const PowerOfAttorneyPage({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.dataSubjectRight,
  });

  final PageController controller;
  final int currentPage;
  final DataSubjectRightModel dataSubjectRight;

  @override
  State<PowerOfAttorneyPage> createState() => _PowerOfAttorneyPageState();
}

class _PowerOfAttorneyPageState extends State<PowerOfAttorneyPage> {
  bool isExpanded = false;
  List<PowerVerificationModel> selectPowerVerification = [];

  void _setPowerVerifications(PowerVerificationModel powerVerification) {
    final selectIds =
        selectPowerVerification.map((selected) => selected.id).toList();

    setState(() {
      if (selectIds.contains(powerVerification.id)) {
        selectPowerVerification = selectPowerVerification
            .where((selected) => selected.id != powerVerification.id)
            .toList();
      } else {
        selectPowerVerification = selectPowerVerification
            .map((selected) => selected)
            .toList()
          ..add(powerVerification);
      }
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
        const SizedBox(height: UiConfig.lineSpacing),
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
    final selectIds =
        selectPowerVerification.map((category) => category.id).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: UiConfig.actionSpacing,
              ),
              child: CustomCheckBox(
                value: selectIds.contains(powerVerification.id),
                onChanged: (_) {
                  _setPowerVerifications(powerVerification);
                },
              ),
            ),
            Expanded(
              child: Text(
                powerVerification.title, //!
                style: !selectIds.contains(powerVerification.id)
                    ? Theme.of(context).textTheme.bodyMedium?.copyWith()
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
        ExpandedContainer(
          expand: selectIds.contains(powerVerification.id),
          duration: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.only(
              left: UiConfig.actionSpacing,
              right: UiConfig.actionSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: powerVerification.additionalReq,
                  child: const Column(
                    children: [
                      SizedBox(height: UiConfig.lineSpacing),
                      Row(
                        children: <Widget>[
                          TitleRequiredText(
                            text: 'ประเภทเอกสาร',
                            required: true, //!
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: 'ระบุประเภทเอกสาร',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                const Row(
                  children: <Widget>[
                    TitleRequiredText(
                      text: 'ไฟล์สำเนา',
                      required: true, //!
                    ),
                  ],
                ),
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
                        backgroundColor:
                            Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
