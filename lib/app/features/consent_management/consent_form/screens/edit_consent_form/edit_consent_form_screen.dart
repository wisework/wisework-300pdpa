import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form/consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/edit_consent_form/edit_consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/edit_consent_form/screens/create_consent_form_success.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

import 'widgets/choose_purpose_category_modal.dart';

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
              text: tr(
                  'consentManagement.consentForm.editConsentTheme.createSuccess'), //!
              contentColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              duration: UiConfig.toastDuration,
            );

            final event = UpdateConsentFormEvent(
              consentForm: state.consentForm,
              updateType: UpdateType.created,
            );

            context.read<ConsentFormBloc>().add(event);

            // context.push(
            //   ConsentFormRoute.createConsentFormScuccess.path
            //       .replaceFirst(':id', state.consentForm.id),
            // );
          }

          if (state is UpdateCurrentConsentForm) {
            BotToast.showText(
              text: tr(
                  'consentManagement.consentForm.editConsentTheme.updateSuccess'), //!
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
          if (state is CreatedCurrentConsentForm) {
            return CreateConsentFormSuccessScreen(
              consentForm: state.consentForm,
              mandatoryFields: state.mandatoryFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
              customFields: state.customFields,
              currentUser: currentUser,
            );
          }
          if (state is GotCurrentConsentForm) {
            return EditConsentFormView(
              consentForm: state.consentForm,
              mandatoryFields: state.mandatoryFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
              customFields: state.customFields,
              currentUser: currentUser,
              isNewConsentForm: widget.consentFormId.isEmpty,
            );
          }
          if (state is UpdateCurrentConsentForm) {
            return EditConsentFormView(
              consentForm: state.consentForm,
              mandatoryFields: state.mandatoryFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
              customFields: state.customFields,
              currentUser: currentUser,
              isNewConsentForm: widget.consentFormId.isEmpty,
            );
          }
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
    required this.consentForm,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.purposes,
    required this.customFields,
    required this.currentUser,
    required this.isNewConsentForm,
  });

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
  final UserModel currentUser;
  final bool isNewConsentForm;

  @override
  State<EditConsentFormView> createState() => _EditConsentFormViewState();
}

class _EditConsentFormViewState extends State<EditConsentFormView> {
  late ConsentFormModel consentForm;
  late List<PurposeCategoryModel> purposeCategories;

  late List<PurposeCategoryModel> purposeCategorySelected;

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool errorPurposeCategoryEmpty = false;

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
    consentForm = widget.consentForm;
    purposeCategories =
        widget.purposeCategories.map((category) => category).toList();

    purposeCategorySelected =
        consentForm.purposeCategories.map((category) => category).toList();

    titleController = TextEditingController();
    descriptionController = TextEditingController();

    if (consentForm != ConsentFormModel.empty()) {
      if (consentForm.title.isNotEmpty) {
        titleController = TextEditingController(
          text: consentForm.title.first.text,
        );
      }
      if (consentForm.description.isNotEmpty) {
        descriptionController = TextEditingController(
          text: consentForm.description.first.text,
        );
      }
    } else {
      consentForm = consentForm.copyWith(
        mandatoryFields: widget.mandatoryFields
            .map((mandatoryField) => mandatoryField.id)
            .toList(),
      );
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

  void _selectMandatoryField(int index) {
    setState(() {
      if (consentForm.mandatoryFields.contains(
        widget.mandatoryFields[index].id,
      )) {
        consentForm.mandatoryFields.removeWhere(
          (item) => item == widget.mandatoryFields[index].id,
        );
      } else {
        consentForm.mandatoryFields.add(
          widget.mandatoryFields[index].id,
        );
      }
    });
  }

  // void _setPriority(int oldIndex, int newIndex) {
  //   if (oldIndex < newIndex) {
  //     newIndex -= 1;
  //   }

  //   final selected = purposeCategorySelected.removeAt(oldIndex);
  //   purposeCategorySelected.insert(newIndex, selected);

  //   consentForm = consentForm.copyWith(
  //     purposeCategories: UtilFunctions.reorderPurposeCategories(
  //       purposeCategorySelected,
  //     ),
  //   );
  // }

  void _saveConsentForm() {
    if (consentForm.purposeCategories.isEmpty) {
      setState(() {
        errorPurposeCategoryEmpty = true;
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      consentForm = consentForm.copyWith(
        title: [
          LocalizedModel(
            language: 'en-US',
            text: titleController.text,
          ),
        ],
        description: [
          LocalizedModel(
            language: 'en-US',
            text: descriptionController.text,
          ),
        ],
      );

      if (widget.isNewConsentForm) {
        consentForm = consentForm.setCreate(
          widget.currentUser.email,
          DateTime.now(),
        );

        final event = CreateCurrentConsentFormEvent(
          consentForm: consentForm,
          companyId: widget.currentUser.currentCompany,
        );

        context.read<EditConsentFormBloc>().add(event);
      } else {
        consentForm = consentForm.setUpdate(
          widget.currentUser.email,
          DateTime.now(),
        );

        final event = UpdateCurrentConsentFormEvent(
          consentForm: consentForm,
          companyId: widget.currentUser.currentCompany,
        );

        context.read<EditConsentFormBloc>().add(event);
      }
    }
  }

  void _goBackAndUpdate() {
    if (!widget.isNewConsentForm) {
      final event = UpdateConsentFormEvent(
        consentForm: consentForm,
        updateType: UpdateType.updated,
      );

      context.read<ConsentFormBloc>().add(event);
    }

    context.pop();
  }

  void _updateEditConsentFormState(
    UpdatedReturn<PurposeCategoryModel> updated,
  ) {
    final event = UpdateEditConsentFormStateEvent(
      purposeCategory: updated.object,
    );
    context.read<EditConsentFormBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(widget.consentForm),
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
                children: <Widget>[
                  _buildInformationSection(context),
                  const SizedBox(height: UiConfig.lineSpacing),
                  _buildMandatorySection(context),
                  const SizedBox(height: UiConfig.lineSpacing),
                  _buildPurposeCategorySection(context),
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
      if (consentForm != widget.consentForm) {
        return CustomIconButton(
          onPressed: _saveConsentForm,
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

  CustomContainer _buildInformationSection(BuildContext context) {
    return CustomContainer(
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
            controller: titleController,
            hintText: tr('consentManagement.consentForm.createForm.hinttitle'),
            onChanged: _setDescription,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('consentManagement.consentForm.createForm.description'),
          ),
          CustomTextField(
            controller: descriptionController,
            hintText:
                tr('consentManagement.consentForm.createForm.description'),
            onChanged: _setTitleController,
          ),
        ],
      ),
    );
  }

  CustomContainer _buildMandatorySection(BuildContext context) {
    return CustomContainer(
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
            itemCount: widget.mandatoryFields.length,
            itemBuilder: (_, index) {
              const language = "en-US";
              final title = widget.mandatoryFields[index].title.firstWhere(
                (item) => item.language == language,
                orElse: () => const LocalizedModel.empty(),
              );

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  CustomSwitchButton(
                    value: consentForm.mandatoryFields.contains(
                      widget.mandatoryFields[index].id,
                    ),
                    onChanged: (_) => _selectMandatoryField(index),
                  ),
                ],
              );
            },
          ),
          _buildWarningDescription(
            context,
            isWarning: consentForm.mandatoryFields.isEmpty,
            text: tr(
                'consentManagement.consentForm.createForm.pleaseSelectOneField'), //!
          ),
        ],
      ),
    );
  }

  CustomContainer _buildPurposeCategorySection(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            tr("consentManagement.consentForm.createForm.purpose"),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Text(
            tr("consentManagement.consentForm.createForm.purposeOfDC"),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: UiConfig.lineGap),
          purposeCategorySelected.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return _buildItemTile(
                      context,
                      purposeCategory: UtilFunctions.getPurposeCategoryById(
                        purposeCategories,
                        purposeCategorySelected[index].id,
                      ),
                    );
                  },
                  itemCount: purposeCategorySelected.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                )
              // ? ReorderableListView.builder(
              //     itemBuilder: (context, index) {
              //       return _buildItemTile(
              //         context,
              //         purposeCategory: UtilFunctions.getPurposeCategoryById(
              //           purposeCategories,
              //           purposeCategorySelected[index].id,
              //         ),
              //       );
              //     },
              //     itemCount: purposeCategorySelected.length,
              //     onReorder: _setPriority,
              //     buildDefaultDragHandles: false,
              //     physics: const NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //   )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Icon(
                    Icons.format_list_bulleted,
                    size: 36.0,
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
          const SizedBox(height: UiConfig.lineGap),
          CustomButton(
            height: 50.0,
            onPressed: () {
              showBarModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => ChoosePurposeCategoryModal(
                  purposeCategories: purposeCategories,
                  initialPurposeCategory: purposeCategorySelected,
                  onChanged: (categories) {
                    final categoryIds = purposeCategories
                        .map((category) => category.id)
                        .toList();

                    setState(() {
                      purposeCategories = purposeCategories
                        ..addAll(categories.where(
                            (category) => !categoryIds.contains(category.id)));

                      purposeCategorySelected = categories;

                      consentForm = consentForm.copyWith(
                        purposeCategories:
                            UtilFunctions.reorderPurposeCategories(
                          purposeCategorySelected,
                        ),
                      );

                      errorPurposeCategoryEmpty =
                          purposeCategorySelected.isEmpty;
                    });
                  },
                  onUpdated: _updateEditConsentFormState,
                ),
              );
            },
            buttonType: CustomButtonType.outlined,
            buttonColor: Theme.of(context).colorScheme.outlineVariant,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UiConfig.defaultPaddingSpacing,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      tr("consentManagement.consentForm.createForm.selectPurposeCategory"),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
          _buildWarningDescription(
            context,
            isWarning: errorPurposeCategoryEmpty,
            text: tr(
                'consentManagement.consentForm.createForm.pleaseSelectPurposeCategory'), //!
          ),
        ],
      ),
    );
  }

  Row _buildItemTile(
    BuildContext context, {
    required PurposeCategoryModel purposeCategory,
  }) {
    const language = 'en-US';
    final title = purposeCategory.title.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    return Row(
      key: ValueKey(purposeCategory.id),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(UiConfig.actionSpacing),
          child: Icon(
            Icons.circle,
            size: 8.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(UiConfig.actionSpacing),
        //   child: ReorderableDragStartListener(
        //     index: purposeCategorySelected.indexOf(purposeCategory),
        //     child: Icon(
        //       Ionicons.reorder_two_outline,
        //       color: Theme.of(context).colorScheme.primary,
        //     ),
        //   ),
        // ),
        Expanded(
          child: Text(
            title.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  ExpandedContainer _buildWarningDescription(
    BuildContext context, {
    required bool isWarning,
    required String text,
  }) {
    return ExpandedContainer(
      expand: isWarning,
      duration: const Duration(milliseconds: 400),
      child: Column(
        children: <Widget>[
          const SizedBox(width: UiConfig.lineGap),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              border: Border.all(
                color: Theme.of(context).colorScheme.onError,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            margin: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Icon(
                    Ionicons.warning_outline,
                    size: 18.0,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
                const SizedBox(width: UiConfig.actionSpacing),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
