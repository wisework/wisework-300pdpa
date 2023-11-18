import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          icon: Icons.chevron_left_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('dataSubjectRight.manageRequests'), 
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
              child: _builddataRequesterForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  Form _builddataRequesterForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tr('dataSubjectRight.dataRequester.areYouTheDs'), 
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          DataSubjectRightListTile(
            title: tr('dataSubjectRight.dataRequester.applicantDs'), 
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
            title: 'dataSubjectRight.dataRequester.ApplicantAds', 
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
                tr('dataSubjectRight.dataRequester.ApplicantInformation'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataRequester.namesurename'), 
            required: true,
          ),
          CustomTextField(
            hintText: tr('dataSubjectRight.dataRequester.hintnamesurename'), 
            controller: fullNameController,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataRequester.address'), 
            required: true,
          ),
          CustomTextField(
            hintText: 'dataSubjectRight.dataRequester.address', 
            controller: addressTextController,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataRequester.email'), 
            required: true,
          ),
          CustomTextField(
            hintText: 'dataSubjectRight.dataRequester.hintemail', 
            controller: emailController,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataRequester.telnumber'), 
            required: true,
          ),
          CustomTextField(
            hintText: 'dataSubjectRight.dataRequester.hinttelnumber', 
            controller: phonenumberController,
            keyboardType: TextInputType.phone,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          CustomButton(
            height: 40.0,
            onPressed: () {
              context.push(DataSubjectRightRoute.stepTwo.path);
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
