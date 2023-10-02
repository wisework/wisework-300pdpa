import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditCustomFieldScreen extends StatelessWidget {
  const EditCustomFieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditCustomFieldView();
  }
}

class EditCustomFieldView extends StatefulWidget {
  const EditCustomFieldView({super.key});

  @override
  State<EditCustomFieldView> createState() => _EditCustomFieldViewState();
}

class _EditCustomFieldViewState extends State<EditCustomFieldView> {
  late TextEditingController titleController;
  late TextEditingController placeHolderController;
  late TextEditingController customFieldTypeController;
  late TextEditingController lenghtLimitController;
  late TextEditingController minLineController;
  late TextEditingController maxLineController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    placeHolderController = TextEditingController();
    customFieldTypeController = TextEditingController();
    lenghtLimitController = TextEditingController();
    minLineController = TextEditingController();
    maxLineController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    placeHolderController.dispose();
    customFieldTypeController.dispose();
    lenghtLimitController.dispose();
    minLineController.dispose();
    maxLineController.dispose();

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
            icon: Ionicons.chevron_back_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          title: Text(tr('masterData.cm.customfields.edit'))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: _buildCustomFieldForm(context),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildCustomFieldForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              tr('masterData.cm.customfields.title'), //!
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.formtitle'),
          required: true,
        ),
        CustomTextField(
          controller: titleController,
          hintText: tr('masterData.cm.customfields.formtitlehint'),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.placeholder'),
          required: true,
        ),
        CustomTextField(
          controller: placeHolderController,
          hintText: tr('masterData.cm.customfields.placeholderhint'),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.customfieldtype'),
          required: true,
        ),
        CustomTextField(
          controller: customFieldTypeController,
          hintText: tr('masterData.cm.customfields.customfieldtypehint'),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.lenghtlimit'),
          required: true,
        ),
        CustomTextField(
          hintText: tr('masterData.cm.customfields.lenghtlimithint'),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.maxline'),
          required: true,
        ),
        CustomTextField(
          hintText: tr('masterData.cm.customfields.maxlinehint'),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.minline'),
          required: true,
        ),
        CustomTextField(
          hintText: tr('masterData.cm.customfields.minlinehint'),
        ),
      ],
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
            tr('masterData.cm.customfields.create'), //!
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      actions: [
        CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Ionicons.save_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
      elevation: 1.0,
      shadowColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
