import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditPurposeScreen extends StatelessWidget {
  const EditPurposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditPurposeView();
  }
}

class EditPurposeView extends StatefulWidget {
  const EditPurposeView({super.key});

  @override
  State<EditPurposeView> createState() => _EditPurposeViewState();
}

class _EditPurposeViewState extends State<EditPurposeView> {
  late TextEditingController descriptionController;
  late TextEditingController warningDescriptionController;
  late TextEditingController retentionPeriodController;

  @override
  void initState() {
    super.initState();

    descriptionController = TextEditingController();
    warningDescriptionController = TextEditingController();
    retentionPeriodController = TextEditingController();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    warningDescriptionController.dispose();
    retentionPeriodController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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
              child: _buildPurposeForm(context),
            ),
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
              child: _buildConfiguration(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          CustomIconButton(
            onPressed: () {
              context.pop();
            },
            icon: Ionicons.chevron_back_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          const SizedBox(width: UiConfig.appBarTitleSpacing),
          Text(
            'Edit Purpose',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      elevation: 1.0,
      shadowColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Column _buildPurposeForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Purpose',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(
          text: 'Description',
          required: true,
        ),
        CustomTextField(
          controller: descriptionController,
          hintText: 'Enter description',
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(text: 'Warning Description'),
        CustomTextField(
          controller: warningDescriptionController,
          hintText: 'Enter warning description',
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(text: 'Retention Period'),
        CustomTextField(
          controller: retentionPeriodController,
          hintText: 'Enter retention period',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(text: 'Period Unit'),
        const CustomTextField(
          hintText: 'Enter period unit',
        ),
      ],
    );
  }

  Column _buildConfiguration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Active',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            CustomSwitchButton(
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          children: <Widget>[
            Text(
              'Update Info',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'admin@gmail.com',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: UiConfig.textSpacing),
            Text(
              '30/09/2023 12:00:00',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: UiConfig.textSpacing),
          ],
        ),
      ],
    );
  }
}
