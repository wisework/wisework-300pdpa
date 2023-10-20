import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form/consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form_detail/consent_form_detail_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/edit_consent_form/edit_consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';

class CreateConsentFormSuccessScreen extends StatefulWidget {
  const CreateConsentFormSuccessScreen({
    super.key,
    required this.consentFormId,
  });

  final String consentFormId;

  @override
  State<CreateConsentFormSuccessScreen> createState() =>
      _CreateConsentFormSuccessScreenState();
}

class _CreateConsentFormSuccessScreenState
    extends State<CreateConsentFormSuccessScreen> {
  late UserModel currentUser;

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<ConsentFormDetailBloc>()
            ..add(
              GetConsentFormEvent(
                consentFormId: widget.consentFormId,
                companyId: currentUser.currentCompany,
              ),
            ),
        ),
        BlocProvider(
            create: (context) => serviceLocator<EditConsentFormBloc>()),
      ],
      child: BlocBuilder<ConsentFormDetailBloc, ConsentFormDetailState>(
        builder: (context, state) {
          if (state is GotConsentFormDetail) {
            return CreateConsentFormSuccessView(
              consentForm: state.consentForm,
              mandatoryFields: state.mandatoryFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
              customFields: state.customFields,
              currentUser: currentUser,
            );
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class CreateConsentFormSuccessView extends StatefulWidget {
  const CreateConsentFormSuccessView({
    super.key,
    required this.consentForm,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.customFields,
    required this.purposes,
    required this.currentUser,
  });

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final UserModel currentUser;

  @override
  State<CreateConsentFormSuccessView> createState() =>
      _CreateConsentFormSuccessViewState();
}

class _CreateConsentFormSuccessViewState
    extends State<CreateConsentFormSuccessView> {
  @override
  Widget build(BuildContext context) {
    ConsentFormModel consentForm = widget.consentForm;
    const String language = 'en-US';

    final title = widget.consentForm.title.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    final description = widget.consentForm.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    return SingleChildScrollView(
      child: CustomContainer(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: UiConfig.lineSpacing),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Congratulations!",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    "สร้างแบบฟอร์มคำยินยอมแล้ว",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.consentForm.id.isNotEmpty
                      ? _consentInfo(
                          context,
                          title,
                          description,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              "No consent details.",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: UiConfig.lineSpacing),
                    child: Divider(
                      color: Theme.of(context).colorScheme.outline,
                      thickness: 0.3,
                    ),
                  ),
                  _customFieldInfo(context, language),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: UiConfig.lineSpacing),
                    child: Divider(
                      color: Theme.of(context).colorScheme.outline,
                      thickness: 0.3,
                    ),
                  ),
                  _purposeCategoriesInfo(context, language),
                ],
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              margin: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "คุณต้องการตั้งค่าแบบฟอร์มยินยอม (ข้อความ สี รูปภาพ ฯลฯ) หรือไม่ ?",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          context.read<ConsentFormBloc>().add(
                              UpdateConsentFormEvent(
                                  consentForm: widget.consentForm,
                                  updateType: UpdateType.created,
                                  purposeCategories: widget.purposeCategories));

                          final url = UtilFunctions.getUserConsentForm(
                            widget.consentForm.id,
                            widget.currentUser.currentCompany,
                          );

                          // final cubit = context.read<CurrentConsentFormSettingsCubit>();
                          // cubit.generateConsentFormUrl(url);

                          consentForm = widget.consentForm.setUrl(url);

                          context.read<EditConsentFormBloc>().add(
                                UpdateCurrentConsentFormEvent(
                                  consentForm: consentForm,
                                  companyId: widget.currentUser.currentCompany,
                                ),
                              );

                          context.push(
                            ConsentFormRoute.consentForm.path,
                          );
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )),
                        child: Text(
                          "ภายหลัง",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: () async {
                          final url = UtilFunctions.getUserConsentForm(
                            widget.consentForm.id,
                            widget.currentUser.currentCompany,
                          );

                          // final cubit = context.read<CurrentConsentFormSettingsCubit>();
                          // cubit.generateConsentFormUrl(url);

                          consentForm = widget.consentForm.setUrl(url);

                          context.read<EditConsentFormBloc>().add(
                                UpdateCurrentConsentFormEvent(
                                  consentForm: consentForm,
                                  companyId: widget.currentUser.currentCompany,
                                ),
                              );
                          context.push(
                            ConsentFormRoute.consentFormSettings.path
                                .replaceFirst(':id', widget.consentForm.id),
                          );
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            )),
                        child: Text(
                          "ตกลง",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _purposeCategoriesInfo(BuildContext context, String language) {
    final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
      widget.purposeCategories,
      widget.consentForm.purposeCategories,
    );
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
                    "No purposes added.",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
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
      purposeCategory.purposes,
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
                      "${purposeFiltered[index].retentionPeriod} ${purposeFiltered[index].periodUnit}",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
            "ข้อมูลที่จัดเก็บ",
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
                    "No input fields added.",
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
        Text(
          "ID: ${widget.consentForm.id}",
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
    );
  }
}
