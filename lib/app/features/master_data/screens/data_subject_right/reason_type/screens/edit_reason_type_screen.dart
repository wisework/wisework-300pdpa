import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditReasonTypeScreen extends StatelessWidget {
  const EditReasonTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditReasonTypeView();
  }
}

class EditReasonTypeView extends StatefulWidget {
  const EditReasonTypeView({super.key});

  @override
  State<EditReasonTypeView> createState() => _EditReasonTypeViewState();
}

class _EditReasonTypeViewState extends State<EditReasonTypeView> {
  late TextEditingController reasonTypeCodeController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    reasonTypeCodeController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    reasonTypeCodeController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void _goBackAndUpdate() {
    context.pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: _goBackAndUpdate,
          icon: Ionicons.chevron_back_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('masterData.dsr.reason.create'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          CustomIconButton(
            onPressed: () {},
            icon: Ionicons.save_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: UiConfig.defaultPaddingSpacing,
              ),
              child: _buildReasonTypeForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  Column _buildReasonTypeForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              tr('masterData.dsr.reason.title'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.dsr.reason.reasoncode'),
          required: true,
        ),
        CustomTextField(
          controller: reasonTypeCodeController,
          hintText: tr('masterData.dsr.reason.reasoncodehint'),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.dsr.reason.reasondescription'),
        ),
        CustomTextField(
          controller: descriptionController,
          hintText: tr('masterData.dsr.reason.reasondescriptionhint'),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              tr('masterData.dsr.reason.needmoreinformation'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            CustomSwitchButton(
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
      ],
    );
  }

}
