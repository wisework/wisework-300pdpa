import 'package:easy_localization/easy_localization.dart';
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
        title:  Text(tr('dataSubjectRight.manageRequests')), 
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: _builddataOwnerForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  Form _builddataOwnerForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('dataSubjectRight.dataOwner.dataOwnerDetails'), 
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataOwner.namesurename'), 
            required: true,
          ),
          const CustomTextField(
            hintText: 'dataSubjectRight.dataOwner.hintnamesurename', 
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataOwner.address'), 
            required: true,
          ),
          const CustomTextField(
            hintText: 'dataSubjectRight.dataOwner.hintaddress', 
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataOwner.email'), 
            required: true,
          ),
          const CustomTextField(
            hintText: 'dataSubjectRight.dataOwner.hintemail', 
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataOwner.telnumber'), 
            required: true,
          ),
          const CustomTextField(
            hintText: 'dataSubjectRight.dataOwner.hinttelnumber', 
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
