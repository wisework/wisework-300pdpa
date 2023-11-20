import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_list_tile.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class OwnerVerifyPage extends StatefulWidget {
  const OwnerVerifyPage({
    super.key,
    required this.controller,
    required this.currentPage,
  });

  final PageController controller;
  final int currentPage;

  @override
  State<OwnerVerifyPage> createState() => _OwnerVerifyPageState();
}

class _OwnerVerifyPageState extends State<OwnerVerifyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late int selectedRadioTile;

  late TextEditingController fullNameController;
  late TextEditingController addressTextController;
  late TextEditingController emailController;
  late TextEditingController phonenumberController;

  @override
  void initState() {
    fullNameController = TextEditingController();
    addressTextController = TextEditingController();
    emailController = TextEditingController();
    phonenumberController = TextEditingController();

    selectedRadioTile = 1;
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressTextController.dispose();
    emailController.dispose();
    phonenumberController.dispose();

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
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          CustomContainer(
            padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
            child: _buildStep1Form(context),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
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
      ),
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
        Container(),
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
    if (selectedRadioTile == 1) {
      widget.controller.jumpToPage(
        4,
      );
      context.read<FormDataSubjectRightCubit>().nextPage(4);
    } else {
      widget.controller.animateToPage(widget.currentPage + 1,
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
      context
          .read<FormDataSubjectRightCubit>()
          .nextPage(widget.currentPage + 1);
    }
  }

  Form _buildStep1Form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ท่านเป็นเจ้าของข้อมูลหรือไม่', //!
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          DataSubjectRightListTile(
            title: 'ผู้ยื่นคำร้องเป็นบุคคลเดียวกับเจ้าของข้อมูล', //!
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
          DataSubjectRightListTile(
            title: 'ผู้ยื่นคำร้องเป็นตัวแทนเจ้าของข้อมูล', //!
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
          Row(
            children: <Widget>[
              Text(
                'ข้อมูลของผู้ยื่นคำขอ', //!
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'ชื่อ - นามสกุล', //!
            required: true,
          ),
          CustomTextField(
            hintText: 'กรอกชื่อ - นามสกุล', //!
            controller: fullNameController,
            required: true,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'ที่อยู่', //!
            required: true,
          ),
          CustomTextField(
            hintText: 'กรอกที่อยู่', //!
            controller: addressTextController,
            required: true,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'อีเมล', //!
            required: true,
          ),
          CustomTextField(
            hintText: 'กรอกอีเมล', //!
            controller: emailController,
            required: true,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'เบอร์โทรติดต่อ', //!
            required: true,
          ),
          CustomTextField(
            hintText: 'กรอกเบอร์โทรติดต่อ', //!
            controller: phonenumberController,
            keyboardType: TextInputType.phone,
            required: true,
            maxLength: 10,
          ),
        ],
      ),
    );
  }
}
