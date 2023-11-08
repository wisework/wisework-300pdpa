import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class CreateConsentFormSuccessScreen extends StatefulWidget {
  const CreateConsentFormSuccessScreen({
    super.key,
    required this.consentForm,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.purposes,
    required this.customFields,
    required this.currentUser,
  });

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
  final UserModel currentUser;

  @override
  State<CreateConsentFormSuccessScreen> createState() =>
      _CreateConsentFormSuccessScreenState();
}

class _CreateConsentFormSuccessScreenState
    extends State<CreateConsentFormSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            context.pushReplacement(
              ConsentFormRoute.consentForm.path,
            );
          },
          icon: Icons.chevron_left_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tr('consentManagement.consentForm.congratulations.title'),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: ContentWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: UiConfig.lineSpacing),
                    CustomContainer(
                      child: _buildConsentForm(context),
                    ),
                    const SizedBox(height: UiConfig.lineSpacing),
                  ],
                ),
              ),
            ),
          ),
          ContentWrapper(
            child: Container(
              padding: const EdgeInsets.all(
                UiConfig.defaultPaddingSpacing,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.outline,
                    blurRadius: 1.0,
                    offset: const Offset(0, -2.0),
                  ),
                ],
              ),
              child: _buildShortcutSettingForm(context),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildConsentForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('consentManagement.consentForm.congratulations.created'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        widget.consentForm.id.isNotEmpty
            ? _buildConsentInfo(context)
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    tr('consentManagement.consentForm.congratulations.noConsentDetails'),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
        const SizedBox(height: UiConfig.lineSpacing),
        _buildCustomFieldInfo(context),
        const SizedBox(height: UiConfig.lineSpacing),
        _buildPurposeCategoriesInfo(context),
      ],
    );
  }

  Column _buildConsentInfo(BuildContext context) {
    final title = widget.consentForm.title.firstWhere(
      (item) => item.language == widget.currentUser.defaultLanguage,
      orElse: () => const LocalizedModel.empty(),
    );

    final description = widget.consentForm.description.firstWhere(
      (item) => item.language == widget.currentUser.defaultLanguage,
      orElse: () => const LocalizedModel.empty(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("ID: ${widget.consentForm.id}",
            style: Theme.of(context).textTheme.bodyMedium),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title.text,
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.6),
          ),
        ),
        if (description.text.isNotEmpty)
          Text(
            description.text,
            style:
                Theme.of(context).textTheme.labelLarge?.copyWith(height: 1.8),
          ),
      ],
    );
  }

  Column _buildCustomFieldInfo(BuildContext context) {
    final mandatoryFiltered = UtilFunctions.filterMandatoryFieldsByIds(
      widget.mandatoryFields,
      widget.consentForm.mandatoryFields,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            tr('consentManagement.consentForm.consentFormDetails.storedInformation'),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.surfaceTint),
          ),
        ),
        mandatoryFiltered.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mandatoryFiltered.length,
                itemBuilder: (_, index) {
                  final title = mandatoryFiltered[index].title.firstWhere(
                        (item) =>
                            item.language == widget.currentUser.defaultLanguage,
                        orElse: () => const LocalizedModel.empty(),
                      );

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: widget.mandatoryFields.last !=
                              widget.mandatoryFields[index]
                          ? 8.0
                          : 0.0,
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.circle,
                          size: 8.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          title.text,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    tr('consentManagement.consentForm.consentFormDetails.noInputField'),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
      ],
    );
  }

  Column _buildPurposeCategoriesInfo(BuildContext context) {
    final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
      widget.purposeCategories,
      widget.consentForm.purposeCategories
          .map((category) => category.id)
          .toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            tr('consentManagement.consentForm.consentFormDetails.Purposes'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.surfaceTint,
                ),
          ),
        ),
        purposeCategoryFiltered.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: purposeCategoryFiltered.length,
                itemBuilder: (_, index) {
                  final title = purposeCategoryFiltered[index].title.firstWhere(
                        (item) =>
                            item.language == widget.currentUser.defaultLanguage,
                        orElse: () => const LocalizedModel.empty(),
                      );

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Icon(
                          Icons.circle,
                          size: 8.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                title.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(height: 1.6),
                              ),
                            ),
                            _buildPurposesInfo(
                              context,
                              purposeCategory: purposeCategoryFiltered[index],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, _) => const SizedBox(
                  height: UiConfig.lineSpacing,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    tr('consentManagement.consentForm.consentFormDetails.noPurposes'),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
      ],
    );
  }

  ListView _buildPurposesInfo(
    BuildContext context, {
    required PurposeCategoryModel purposeCategory,
  }) {
    final purposeFiltered = UtilFunctions.filterPurposeByIds(
      widget.purposes,
      purposeCategory.purposes.map((purpose) => purpose.id).toList(),
    );

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: purposeFiltered.length,
      itemBuilder: (_, index) {
        final description = purposeFiltered[index].description.firstWhere(
              (item) => item.language == widget.currentUser.defaultLanguage,
              orElse: () => const LocalizedModel.empty(),
            );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    description.text,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(height: 1.8),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    "${purposeFiltered[index].retentionPeriod} ${purposeFiltered[index].periodUnit}",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      separatorBuilder: (context, _) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: UiConfig.lineSpacing,
        ),
        child: Divider(
          height: 0.1,
          thickness: 0.3,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }

  Column _buildShortcutSettingForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('consentManagement.consentForm.congratulations.settingConsentTheme'),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: () {
                context.pushReplacement(
                  ConsentFormRoute.consentForm.path,
                );
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.onBackground,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )),
              child: Text(
                tr('consentManagement.consentForm.congratulations.later'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () async {
                context.pushReplacement(
                  ConsentFormRoute.consentFormQuickSettings.path
                      .replaceFirst(':id', widget.consentForm.id),
                );
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )),
              child: Text(
                tr('consentManagement.consentForm.congratulations.ok'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        )
      ],
    );
  }
}
