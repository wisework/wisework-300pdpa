import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class CreateRequestPageOne extends StatefulWidget {
  const CreateRequestPageOne({super.key});

  @override
  State<CreateRequestPageOne> createState() => _CreateRequestPageOneState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _CreateRequestPageOneState extends State<CreateRequestPageOne> {
  late int selectedRadioTile;

  @override
  void initState() {
    super.initState();
    // ตั้งค่าค่าเริ่มต้นของ Radio
    selectedRadioTile = 1;
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
        leadingIcon: _buildPopButton(),
        title: const Text('แบบฟอร์มขอใช้สิทธิ์ตามกฏหมาย'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: _buildStep1Form(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: () => context.pop(),
      icon: Ionicons.chevron_back_outline,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Form _buildStep1Form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ท่านเป็นเจ้าของข้อมูลหรือไม่',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          ListTile(
            title: Text('ผู้ยื่นคำร้องเป็นบุคคลเดียวกับเจ้าของข้อมูล',
                style: Theme.of(context).textTheme.bodyMedium),
            leading: Radio(
              value: 1,
              groupValue: selectedRadioTile,
              onChanged: (val) {
                setSelectedRadioTile(val!);
              },
            ),
            onTap: () {
              setSelectedRadioTile(1);
            },
          ),
          Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
          ListTile(
            title: Text('ผู้ยื่นคำร้องเป็นตัวแทนเจ้าของข้อมูล',
                style: Theme.of(context).textTheme.bodyMedium),
            leading: Radio(
              value: 2,
              groupValue: selectedRadioTile,
              onChanged: (val) {
                setSelectedRadioTile(val!);
              },
            ),
            onTap: () {
              setSelectedRadioTile(2);
            },
          ),
          Row(
            children: <Widget>[
              Text(
                'ข้อมูลของผู้ยื่นคำขอ',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'ชื่อ - นามสกุล',
            required: true,
          ),
          const CustomTextField(
            hintText: 'กรอกชื่อ - นามสกุล',
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'ที่อยู่',
            required: true,
          ),
          const CustomTextField(
            hintText: 'กรอกที่อยู่',
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'อีเมล',
            required: true,
          ),
          const CustomTextField(
            hintText: 'กรอกอีเมล',
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'เบอร์โทรติดต่อ',
            required: true,
          ),
          const CustomTextField(
            hintText: 'กรอกเบอร์โทรติดต่อ',
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          CustomButton(
            width: double.infinity,
            height: 50,
            onPressed: () {
              context.push(DataSubjectRightRouter.step2.path);
            },
            child: Text(
              'ถัดไป',
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
