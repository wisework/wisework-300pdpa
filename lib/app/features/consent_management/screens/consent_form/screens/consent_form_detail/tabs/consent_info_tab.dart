import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

class ConsentInfoTab extends StatefulWidget {
  const ConsentInfoTab({
    super.key,
    required this.consentForm,
    required this.purposeCategories,
    required this.customFields,
    required this.purposes,
  });

  final ConsentFormModel consentForm;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;

  @override
  State<ConsentInfoTab> createState() => _ConsentInfoTabState();
}

class _ConsentInfoTabState extends State<ConsentInfoTab> {
  late UserModel currentUser;
  late String consentId;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
    } else {
      currentUser = UserModel.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomContainer(
        padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
        margin: const EdgeInsets.only(top: UiConfig.lineSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            ConsentInfo(consentForm: widget.consentForm),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: UiConfig.lineSpacing),
              child: Divider(
                color: Theme.of(context).colorScheme.outline,
                thickness: 0.3,
              ),
            ),
            CustomFieldInfo(customFields: widget.customFields),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: UiConfig.lineSpacing),
              child: Divider(
                color: Theme.of(context).colorScheme.outline,
                thickness: 0.3,
              ),
            ),
            PurposeCategoryInfo(
              purposeCategories: widget.purposeCategories,
              purposes: widget.purposes,
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }
}

class ConsentInfo extends StatelessWidget {
  const ConsentInfo({
    super.key,
    required this.consentForm,
  });

  final ConsentFormModel consentForm;

  @override
  Widget build(BuildContext context) {
    const language = 'en-US';

    final title = consentForm.title.firstWhere(
      (item) => item.language == language,
      orElse: LocalizedModel.empty,
    );

    final description = consentForm.description.firstWhere(
      (item) => item.language == language,
      orElse: LocalizedModel.empty,
    );

    return consentForm.id.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "ID: ${consentForm.id}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
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
          )
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                "No consent details.",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          );
  }
}

class CustomFieldInfo extends StatelessWidget {
  const CustomFieldInfo({
    super.key,
    required this.customFields,
  });

  final List<CustomFieldModel> customFields;

  @override
  Widget build(BuildContext context) {
    const language = 'en-US';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "ข้อมูลที่จัดเก็บ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.surfaceTint,
                ),
          ),
        ),
        customFields.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: customFields.length,
                itemBuilder: (_, index) {
                  final title = customFields[index].title.firstWhere(
                        (item) => item.language == language,
                        orElse: LocalizedModel.empty,
                      );
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: customFields.last != customFields[index]
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
                    "No input fields added.",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
      ],
    );
  }
}

class PurposeCategoryInfo extends StatelessWidget {
  const PurposeCategoryInfo(
      {super.key, required this.purposeCategories, required this.purposes});

  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;

  @override
  Widget build(BuildContext context) {
    const language = 'en-US';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "วัตถุประสงค์",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.surfaceTint,
                ),
          ),
        ),
        purposeCategories.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: purposeCategories.length,
                itemBuilder: (_, index) {
                  final title = purposeCategories[index].title.firstWhere(
                        (item) => item.language == language,
                        orElse: LocalizedModel.empty,
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
                      PurposeInfo(
                        purpose: purposes,
                      ),
                    ],
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    "No purposes added.",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
      ],
    );
  }
}

class PurposeInfo extends StatelessWidget {
  const PurposeInfo({
    super.key,
    required this.purpose,
  });
  final List<PurposeModel> purpose;

  @override
  Widget build(BuildContext context) {
    const language = 'en-US';
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: purpose.length,
      itemBuilder: (_, index) {
        final description = purpose[index].description.firstWhere(
              (item) => item.language == language,
              orElse: LocalizedModel.empty,
            );

        return Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
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
                      "${purpose[index].retentionPeriod} ${purpose[index].periodUnit}",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
