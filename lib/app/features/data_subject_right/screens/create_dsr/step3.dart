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

class DSRStep3Screen extends StatefulWidget {
  const DSRStep3Screen({super.key});

  @override
  State<DSRStep3Screen> createState() => _DSRStep3ScreenState();
}

class _DSRStep3ScreenState extends State<DSRStep3Screen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
              child: _buildStep3Form(context),
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
  Form _buildStep3Form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          Row(
            children: <Widget>[
              Text(
                'รายละเอียดเจ้าของข้อมูล',
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
                context.push(DataSubjectRightRouter.step4.path);
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