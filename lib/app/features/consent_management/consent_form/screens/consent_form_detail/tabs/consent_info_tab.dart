import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

class ConsentInfoTab extends StatefulWidget {
  const ConsentInfoTab({
    super.key,
    required this.consentForm,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.customFields,
    required this.purposes,
    required this.language,
  });

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final String language;

  @override
  State<ConsentInfoTab> createState() => _ConsentInfoTabState();
}

class _ConsentInfoTabState extends State<ConsentInfoTab> {
  late UserModel currentUser;
  late String consentId;
  late String language;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
      language = currentUser.defaultLanguage;
    } else {
      currentUser = UserModel.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.consentForm.title.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    final description = widget.consentForm.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          CustomContainer(
            child: widget.consentForm.id.isNotEmpty
                ? _consentInfo(
                    context,
                    title,
                    description,
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        tr('consentManagement.consentForm.congratulations.noConsentDetails'),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: UiConfig.lineSpacing),
          //   child: Divider(
          //     color: Theme.of(context).colorScheme.outline,
          //     thickness: 0.3,
          //   ),
          // ),
          CustomContainer(child: _customFieldInfo(context, language)),
          const SizedBox(height: UiConfig.lineSpacing),

          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: UiConfig.lineSpacing),
          //   child: Divider(
          //     color: Theme.of(context).colorScheme.outline,
          //     thickness: 0.3,
          //   ),
          // ),
          CustomContainer(child: _purposeCategoriesInfo(context, language)),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  Column _purposeCategoriesInfo(BuildContext context, String language) {
    final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
      widget.purposeCategories,
      widget.consentForm.purposeCategories.map((item) => item.id).toList(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(UiConfig.textLineSpacing),
          child: Text(
            tr("consentManagement.consentForm.consentFormDetails.Purposes"),
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
                        (item) => item.language == language,
                        orElse: () => const LocalizedModel.empty(),
                      );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          title.text,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                height: 1.6,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                      _purposesInfo(
                          language, context, purposeCategoryFiltered[index]),
                    ],
                  );
                },
                separatorBuilder: (context, _) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: UiConfig.lineSpacing,
                  ),
                  child: Divider(
                    height: 0.1,
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withOpacity(0.6),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    tr("consentManagement.consentForm.noPurposesAdded"),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
      ],
    );
  }

  ListView _purposesInfo(String language, BuildContext context,
      PurposeCategoryModel purposeCategory) {
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
              (item) => item.language == language,
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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          height: 1.8,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    "${purposeFiltered[index].retentionPeriod} ${purposeFiltered[index].periodUnit}",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
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
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
        ),
      ),
    );
  }

  Column _customFieldInfo(BuildContext context, String language) {
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
            tr("consentManagement.consentForm.consentFormDetails.storedInformation"),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.surfaceTint,
                ),
          ),
        ),
        mandatoryFiltered.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mandatoryFiltered.length,
                itemBuilder: (_, index) {
                  final title = mandatoryFiltered[index].title.firstWhere(
                        (item) => item.language == language,
                        orElse: () => const LocalizedModel.empty(),
                      );
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: widget.mandatoryFields.last !=
                                widget.mandatoryFields[index]
                            ? 8.0
                            : 0.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 10.0),
                        Text(title.text,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                      ],
                    ),
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    tr("consentManagement.consentForm.noInputFieldsAdded"),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
      ],
    );
  }

  Column _consentInfo(
      BuildContext context, LocalizedModel title, LocalizedModel description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "ID: ${widget.consentForm.id}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title.text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        if (description.text.isNotEmpty)
          Text(
            description.text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  height: 1.8,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
      ],
    );
  }
}
