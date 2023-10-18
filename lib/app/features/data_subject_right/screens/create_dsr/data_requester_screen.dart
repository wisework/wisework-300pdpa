import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_list_tile.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class RequestDataRequesterScreen extends StatefulWidget {
  const RequestDataRequesterScreen({super.key});

  @override
  State<RequestDataRequesterScreen> createState() =>
      _RequestDataRequesterScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _RequestDataRequesterScreenState
    extends State<RequestDataRequesterScreen> {
  @override
  Widget build(BuildContext context) {
    return const DataRequesterView();
  }
}

class DataRequesterView extends StatefulWidget {
  const DataRequesterView({super.key});

  @override
  State<DataRequesterView> createState() => _DataRequesterViewState();
}

class _DataRequesterViewState extends State<DataRequesterView> {
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

    // ตั้งค่าค่าเริ่มต้นของ Radio
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
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Ionicons.chevron_back_outline,
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
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: _buildStep1Form(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
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
          // ListTile(
          //   title: Text('ผู้ยื่นคำร้องเป็นบุคคลเดียวกับเจ้าของข้อมูล',
          //       style: Theme.of(context).textTheme.bodyMedium),
          //   leading: Radio(
          //     value: 1,
          //     groupValue: selectedRadioTile,
          //     onChanged: (val) {
          //       setSelectedRadioTile(val!);
          //     },
          //   ),
          //   onTap: () {
          //     setSelectedRadioTile(1);
          //   },
          // ),
          // Divider(
          //   color:
          //       Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          // ),
          // ListTile(
          //   title: Text('ผู้ยื่นคำร้องเป็นตัวแทนเจ้าของข้อมูล',
          //       style: Theme.of(context).textTheme.bodyMedium),
          //   leading: Radio(
          //     value: 2,
          //     groupValue: selectedRadioTile,
          //     onChanged: (val) {
          //       setSelectedRadioTile(val!);
          //     },
          //   ),
          //   onTap: () {
          //     setSelectedRadioTile(2);
          //   },
          // ),
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
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          CustomButton(
            height: 40.0,
            onPressed: () {
              context.push(DataSubjectRightRouter.stepTwo.path);
            },
            child: Text(
              'ถัดไป', //!
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
