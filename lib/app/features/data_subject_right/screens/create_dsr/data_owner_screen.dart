import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class RequestDataOwnerScreen extends StatefulWidget {
  const RequestDataOwnerScreen({super.key});

  @override
  State<RequestDataOwnerScreen> createState() => _RequestDataOwnerScreenState();
}

class _RequestDataOwnerScreenState extends State<RequestDataOwnerScreen> {
  @override
  Widget build(BuildContext context) {
    return const DataOwnerView();
  }
}

class DataOwnerView extends StatefulWidget {
  const DataOwnerView({super.key});

  @override
  State<DataOwnerView> createState() => _DataOwnerViewState();
}

class _DataOwnerViewState extends State<DataOwnerView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        title: const Text('แบบฟอร์มขอใช้สิทธิ์ตามกฏหมาย'), //!
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: _buildStep3Form(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
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
                'รายละเอียดเจ้าของข้อมูล', //!
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
          const CustomTextField(
            hintText: 'กรอกชื่อ - นามสกุล', //!
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'ที่อยู่', //!
            required: true,
          ),
          const CustomTextField(
            hintText: 'กรอกที่อยู่', //!
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'อีเมล', //!
            required: true,
          ),
          const CustomTextField(
            hintText: 'กรอกอีเมล', //!
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'เบอร์โทรติดต่อ', //!
            required: true,
          ),
          const CustomTextField(
            hintText: 'กรอกเบอร์โทรติดต่อ', //!
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          CustomButton(
            height: 40.0,
            onPressed: () {
              context.push(DataSubjectRightRoute.stepFour.path);
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
