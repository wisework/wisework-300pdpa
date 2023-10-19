import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form/consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/edit_consent_form/edit_consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/choose_purpose_category/choose_purpose_category_cubit.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/edit_consent_form/widgets/ReorderPurposeCategory.dart';

import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditConsentFormScreen extends StatefulWidget {
  const EditConsentFormScreen({
    super.key,
    required this.consentFormId,
  });

  final String consentFormId;

  @override
  State<EditConsentFormScreen> createState() => _EditConsentFormScreenState();
}

class _EditConsentFormScreenState extends State<EditConsentFormScreen> {
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
    return BlocProvider<EditConsentFormBloc>(
      create: (context) => serviceLocator<EditConsentFormBloc>()
        ..add(
          GetCurrentConsentFormEvent(
            consentFormId: widget.consentFormId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditConsentFormBloc, EditConsentFormState>(
        listener: (context, state) {
          if (state is CreatedCurrentConsentForm) {
            BotToast.showText(
              text: 'Create successfully',
              contentColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              duration: UiConfig.toastDuration,
            );

            context.read<ConsentFormBloc>().add(UpdateConsentFormEvent(
                consentForm: state.consentForm,
                updateType: UpdateType.created));

            context.pop();
          }

          if (state is UpdatedCurrentConsentForm) {
            BotToast.showText(
              text: 'Update successfully',
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
          if (state is GotCurrentConsentForm) {
            return EditConsentFormView(
              initialConsentForm: state.consentForm,
              currentUser: currentUser,
              isNewConsentForm: widget.consentFormId.isEmpty,
              customfields: state.customFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
            );
          }
          // if (state is UpdatedCurrentConsentForm) {
          //   return EditConsentFormView(
          //     initialConsentForm: state.consentForm,
          //     currentUser: currentUser,
          //     isNewConsentForm: widget.consentFormId.isEmpty,
          //   );
          // }
          if (state is EditConsentFormError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditConsentFormView extends StatefulWidget {
  const EditConsentFormView({
    super.key,
    required this.initialConsentForm,
    required this.currentUser,
    required this.isNewConsentForm,
    required this.customfields,
    required this.purposeCategories,
    required this.purposes,
  });

  final ConsentFormModel initialConsentForm;
  final List<CustomFieldModel> customfields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final UserModel currentUser;
  final bool isNewConsentForm;

  @override
  State<EditConsentFormView> createState() => _EditConsentFormViewState();
}

class _EditConsentFormViewState extends State<EditConsentFormView> {
  late ConsentFormModel consentForm;

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> customFieldList = [];

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void _initialData() {
    consentForm = widget.initialConsentForm;

    titleController = TextEditingController();
    descriptionController = TextEditingController();

    customFieldList = consentForm.customFields;

    if (consentForm != ConsentFormModel.empty()) {
      if (consentForm.description.isNotEmpty) {
        titleController = TextEditingController(
          text: consentForm.title.first.text,
        );
      }
      if (consentForm.description.isNotEmpty) {
        descriptionController = TextEditingController(
          text: consentForm.description.first.text,
        );
      }
    }
  }

  void _setTitleController(String? value) {
    setState(() {
      final title = [
        LocalizedModel(
          language: 'en-US',
          text: titleController.text,
        ),
      ];

      consentForm = consentForm.copyWith(title: title);
    });
  }

  void _setDescription(String? value) {
    setState(() {
      final description = [
        LocalizedModel(
          language: 'en-US',
          text: descriptionController.text,
        ),
      ];

      consentForm = consentForm.copyWith(description: description);
    });
  }

  void _savePurpose() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewConsentForm) {
        // consentForm = consentForm.toCreated(
        //   widget.currentUser.email,
        //   DateTime.now(),
        // );

        context.read<EditConsentFormBloc>().add(
              CreateCurrentConsentFormEvent(
                consentForm: consentForm,
                companyId: widget.currentUser.currentCompany,
              ),
            );
      } else {
        // consentForm = consentForm.toUpdated(
        //   widget.currentUser.email,
        //   DateTime.now(),
        // );

        context.read<EditConsentFormBloc>().add(
              UpdateCurrentConsentFormEvent(
                consentForm: consentForm,
                companyId: widget.currentUser.currentCompany,
              ),
            );
      }
    }
  }

  void _goBackAndUpdate() {
    if (!widget.isNewConsentForm) {
      context.read<ConsentFormBloc>().add(UpdateConsentFormEvent(
            consentForm: consentForm,
            updateType: UpdateType.updated,
          ));
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(widget.initialConsentForm),
        title: Text(
          widget.isNewConsentForm
              ? tr('consentManagement.consentForm.createForm.create')
              : tr('consentManagement.consentForm.createForm.edit'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          _buildSaveButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              tr('consentManagement.consentForm.createForm.section'),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: UiConfig.lineSpacing),
                        TitleRequiredText(
                          text: tr('consentManagement.consentForm.createForm.title'),
                          required: true,
                        ),
                        CustomTextField(
                          controller: descriptionController,
                          hintText:
                              tr('consentManagement.consentForm.createForm.title'),
                          onChanged: _setDescription,
                          required: true,
                        ),
                        const SizedBox(height: UiConfig.lineSpacing),
                        TitleRequiredText(
                          text: tr(
                              'consentManagement.consentForm.createForm.description'),
                        ),
                        CustomTextField(
                          controller: titleController,
                          hintText: tr(
                              'consentManagement.consentForm.createForm.description'),
                          onChanged: _setTitleController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  CustomContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              tr("consentManagement.consentForm.consentFormDetails.storedInformation"),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: UiConfig.lineSpacing),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.customfields.length,
                            itemBuilder: (_, index) {
                              const language = "en-US";
                              final title =
                                  widget.customfields[index].title.firstWhere(
                                (item) => item.language == language,
                                orElse: LocalizedModel.empty,
                              );
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    title.text,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  CustomSwitchButton(
                                    value: customFieldList.contains(
                                        widget.customfields[index].id),
                                    onChanged: (value) => {
                                      setState(() {
                                        if (customFieldList.contains(
                                            widget.customfields[index].id)) {
                                          customFieldList.removeWhere((item) =>
                                              item ==
                                              widget.customfields[index].id);
                                        } else {
                                          customFieldList.add(
                                              widget.customfields[index].id);
                                        }
                                        print(customFieldList);
                                      })
                                    },
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  CustomContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tr("consentManagement.consentForm.createForm.purpose"),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          tr("consentManagement.consentForm.createForm.purposeOfDC"),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: UiConfig.lineSpacing),
                        ReorderPurposeCategory(
                          purposeCategory: widget.purposeCategories,
                          consentForm: widget.initialConsentForm,
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.outline,
                          thickness: 0.3,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: OutlinedButton(
                            onPressed: () async {
                              if (consentForm.id.isNotEmpty) {
                                context.push(ConsentFormRoute
                                    .editChoosePurposeCategory.path
                                    .replaceFirst(':id', consentForm.id));
                              } else {
                                context.push(ConsentFormRoute
                                    .choosePurposeCategory.path);
                              }
                            },
                            style: ButtonStyle(
                                side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                )),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    tr("consentManagement.consentForm.createForm.selectPurposeCategory"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton(ConsentFormModel consentForm) {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Ionicons.chevron_back_outline,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Builder _buildSaveButton() {
    return Builder(builder: (context) {
      if (consentForm != widget.initialConsentForm) {
        return CustomIconButton(
          onPressed: _savePurpose,
          icon: Ionicons.save_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        );
      }
      return CustomIconButton(
        icon: Ionicons.save_outline,
        iconColor: Theme.of(context).colorScheme.outlineVariant,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
      );
    });
  }
}
