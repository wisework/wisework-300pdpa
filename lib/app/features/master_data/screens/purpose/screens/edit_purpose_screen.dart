import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
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
            Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: _buildPurposeForm(context),
            ),
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
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(text: 'Period Unit'),
        const CustomTextField(
          hintText: 'Enter period unit',
        ),
      ],
    );
  }
}
