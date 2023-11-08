import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/data/models/etc/user_input_purpose.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/user_consent_form/user_consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_user_consent_form/current_user_consent_form_cubit.dart';
import 'package:pdpa/app/features/consent_management/consent_form/widgets/consent_form_preview.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/wise_work_shimmer.dart';

class UserConsentFormScreen extends StatefulWidget {
  const UserConsentFormScreen({
    super.key,
    required this.companyId,
    required this.consentFormId,
  });

  final String companyId;
  final String consentFormId;

  @override
  State<UserConsentFormScreen> createState() => _UserConsentFormScreenState();
}

class _UserConsentFormScreenState extends State<UserConsentFormScreen> {
  @override
  void initState() {
    super.initState();

    _getUserConsentForm();
  }

  void _getUserConsentForm() {
    final bloc = context.read<UserConsentFormBloc>();
    bloc.add(GetUserConsentFormEvent(
      consentFormId: widget.consentFormId,
      companyId: widget.companyId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserConsentFormBloc, UserConsentFormState>(
      listener: (context, state) {
        if (state is SubmittedUserConsentForm) {
          BotToast.showText(
            text: tr(
                'consentManagement.userConsent.consentFormDetails.edit.submitSuccess'),
            contentColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.75),
            borderRadius: BorderRadius.circular(8.0),
            textStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            duration: UiConfig.toastDuration,
          );
        }
      },
      builder: (context, state) {
        if (state is GotUserConsentForm) {
          return BlocProvider<CurrentUserConsentFormCubit>(
            create: (context) => CurrentUserConsentFormCubit()
              ..initialUserConsent(state.consentForm, state.purposeCategories),
            child: UserConsentFormView(
              consentForm: state.consentForm,
              mandatoryFields: state.mandatoryFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
              customFields: state.customFields,
              consentTheme: state.consentTheme,
              companyId: widget.companyId,
            ),
          );
        }
        if (state is SubmittingUserConsentForm) {
          return const LoadingScreen();
        }
        if (state is SubmittedUserConsentForm) {
          return _buildSubmittedScreen(
            context,
            consentForm: state.consentForm,
          );
        }
        if (state is UserConsentFormError) {
          return ErrorMessageScreen(message: state.message);
        }
        return _buildLoadingScreen(context);
      },
    );
  }

  Scaffold _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: WiseWorkShimmer(),
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Scaffold _buildSubmittedScreen(
    BuildContext context, {
    required ConsentFormModel consentForm,
  }) {
    return Scaffold(
      appBar: PdpaAppBar(
        title: SizedBox(
          height: 40.0,
          child: Image.asset(
            'assets/images/general/dpo_online_mini.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: CustomContainer(
            margin: const EdgeInsets.all(UiConfig.lineSpacing),
            constraints: const BoxConstraints(maxWidth: 500.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  tr('consentManagement.userConsent.consentFormDetails.edit.decription'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: UiConfig.lineGap),
                Text(
                  consentForm.headerText.first.text,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260.0),
                  child: CustomButton(
                    height: 40.0,
                    onPressed: () {
                      final event = GetUserConsentFormEvent(
                        consentFormId: consentForm.id,
                        companyId: widget.companyId,
                      );
                      context.read<UserConsentFormBloc>().add(event);
                    },
                    child: Text(
                      tr('consentManagement.userConsent.consentFormDetails.edit.fillOutTheFormAgain'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserConsentFormView extends StatefulWidget {
  const UserConsentFormView({
    super.key,
    required this.consentForm,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.purposes,
    required this.customFields,
    required this.consentTheme,
    required this.companyId,
  });

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
  final ConsentThemeModel consentTheme;
  final String companyId;

  @override
  State<UserConsentFormView> createState() => _UserConsentFormViewState();
}

class _UserConsentFormViewState extends State<UserConsentFormView> {
  @override
  Widget build(BuildContext context) {
    final userConsent = context.select(
      (CurrentUserConsentFormCubit cubit) => cubit.state.userConsent,
    );
    final cubit = context.read<CurrentUserConsentFormCubit>();

    return Scaffold(
      appBar: PdpaAppBar(
        title: SizedBox(
          height: 40.0,
          child: Image.asset(
            'assets/images/general/dpo_online_mini.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ConsentFormPreview(
          consentForm: widget.consentForm,
          mandatoryFields: widget.mandatoryFields,
          purposeCategories: widget.purposeCategories,
          purposes: widget.purposes,
          customFields: widget.customFields,
          consentTheme: widget.consentTheme,
          onMandatoryFieldChanged: (mandatoryFieldId, value) {
            List<UserInputText> mandatoryFields = [];

            for (UserInputText mandatoryField in userConsent.mandatoryFields) {
              if (mandatoryField.id == mandatoryFieldId) {
                mandatoryFields.add(
                  UserInputText(
                    id: mandatoryField.id,
                    text: value,
                  ),
                );
              } else {
                mandatoryFields.add(mandatoryField);
              }
            }

            cubit.setUserConsentForm(
              userConsent.copyWith(mandatoryFields: mandatoryFields),
            );
          },
          onPurposeChanged: (purposeId, categoryId, value) {
            List<UserInputPurpose> purposes = [];

            for (UserInputPurpose purpose in userConsent.purposes) {
              if (purpose.id == purposeId) {
                purposes.add(
                  UserInputPurpose(
                    id: purpose.id,
                    purposeCategoryId: categoryId,
                    value: value,
                  ),
                );
              } else {
                purposes.add(purpose);
              }
            }

            cubit.setUserConsentForm(
              userConsent.copyWith(purposes: purposes),
            );
          },
          onConsentAccepted: (value) {
            cubit.setUserConsentForm(
              userConsent.copyWith(isAcceptConsent: value),
            );
          },
          onSubmitted: () {
            if (!userConsent.isAcceptConsent) {
              BotToast.showText(
                text: tr(
                    'consentManagement.userConsent.consentFormDetails.edit.pleaseAcceptConsent'),
                contentColor:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.75),
                borderRadius: BorderRadius.circular(8.0),
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                duration: UiConfig.toastDuration,
              );
              return;
            }

            final updated = userConsent.setCreate('', DateTime.now());
            final event = SubmitUserConsentFormEvent(
              userConsent: updated,
              consentForm: widget.consentForm,
              companyId: widget.companyId,
            );

            context.read<UserConsentFormBloc>().add(event);
          },
          isVerifyRequired: true,
        ),
      ),
    );
  }
}
