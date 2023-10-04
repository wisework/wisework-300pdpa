import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/custom_field/custom_field_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/edit_custom_field/bloc/edit_custom_field_bloc.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
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

class EditCustomFieldScreen extends StatefulWidget {
  const EditCustomFieldScreen({
    super.key,
    required this.customfieldId,
  });

  final String customfieldId;

  @override
  State<EditCustomFieldScreen> createState() => _EditCustomFieldScreenState();
}

class _EditCustomFieldScreenState extends State<EditCustomFieldScreen> {
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
    return BlocProvider<EditCustomFieldBloc>(
      create: (context) => serviceLocator<EditCustomFieldBloc>()
        ..add(
          GetCurrentCustomFieldEvent(
            customfieldId: widget.customfieldId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditCustomFieldBloc, EditCustomFieldState>(
        listener: (context, state) {
          if (state is CreatedCurrentCustomField) {
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

            context.read<CustomFieldBloc>().add(UpdateCustomFieldEvent(
                customfield: state.customfield,
                updateType: UpdateType.created));

            context.pop();
          }

          if (state is UpdatedCurrentCustomField) {
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

          if (state is DeletedCurrentCustomField) {
            BotToast.showText(
              text: 'Delete successfully',
              contentColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              duration: UiConfig.toastDuration,
            );

            final deleted =
                CustomFieldModel.empty().copyWith(id: state.customfieldId);

            context.read<CustomFieldBloc>().add(UpdateCustomFieldEvent(
                customfield: deleted, updateType: UpdateType.deleted));

            context.pop();
          }
        },
        builder: (context, state) {
          if (state is GotCurrentCustomField) {
            return EditCustomFieldView(
              initialCustomField: state.customfield,
              currentUser: currentUser,
              isNewCustomField: widget.customfieldId.isEmpty,
            );
          }
          if (state is UpdatedCurrentCustomField) {
            return EditCustomFieldView(
              initialCustomField: state.customfield,
              currentUser: currentUser,
              isNewCustomField: widget.customfieldId.isEmpty,
            );
          }
          if (state is EditCustomFieldError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditCustomFieldView extends StatefulWidget {
  const EditCustomFieldView({
    super.key,
    required this.initialCustomField,
    required this.currentUser,
    required this.isNewCustomField,
  });

  final CustomFieldModel initialCustomField;
  final UserModel currentUser;
  final bool isNewCustomField;

  @override
  State<EditCustomFieldView> createState() => _EditCustomFieldViewState();
}

class _EditCustomFieldViewState extends State<EditCustomFieldView> {
  late CustomFieldModel customfield;

  late TextEditingController titleController;
  late TextEditingController hintTextController;
  late TextEditingController customFieldTypeController;
  late TextEditingController lenghtLimitController;
  late TextEditingController minLineController;
  late TextEditingController maxLineController;

  late String typeSelected;
  late bool isActivated;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initialData();

    titleController = TextEditingController();
    hintTextController = TextEditingController();
    customFieldTypeController = TextEditingController();
    lenghtLimitController = TextEditingController();
    minLineController = TextEditingController();
    maxLineController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    hintTextController.dispose();
    customFieldTypeController.dispose();
    lenghtLimitController.dispose();
    minLineController.dispose();
    maxLineController.dispose();

    super.dispose();
  }

  void _initialData() {
    customfield = widget.initialCustomField;

    titleController = TextEditingController();
    hintTextController = TextEditingController();
    customFieldTypeController = TextEditingController();
    lenghtLimitController = TextEditingController();
    minLineController = TextEditingController();
    maxLineController = TextEditingController();

    typeSelected = 'd';
    isActivated = true;

    if (customfield != CustomFieldModel.empty()) {
      if (customfield.title.isNotEmpty) {
        titleController = TextEditingController(
          text: customfield.title.first.text,
        );
      }
      if (customfield.hintText.isNotEmpty) {
        hintTextController = TextEditingController(
          text: customfield.hintText.first.text,
        );
      }

      // retentionPeriodController = TextEditingController(
      //   text: customfield.retentionPeriod.toString(),
      // );

      typeSelected =
          customfield.inputType.isNotEmpty ? customfield.inputType : 'd';

      isActivated = customfield.status == ActiveStatus.active;

      if (customfield.lengthLimit.isNotEmpty) {
        hintTextController = TextEditingController(
          text: customfield.hintText.first.text,
        );
      }
      if (customfield.maxLines != 0) {
        hintTextController = TextEditingController(
          text: customfield.hintText.first.text,
        );
      }
      if (customfield.minLines != 0) {
        hintTextController = TextEditingController(
          text: customfield.hintText.first.text,
        );
      }
    }
  }

  void _setTitle(String? value) {
    setState(() {
      final title = [
        LocalizedModel(
          language: 'en-US',
          text: titleController.text,
        ),
      ];

      customfield = customfield.copyWith(title: title);
    });
  }

  void _setHintText(String? value) {
    setState(
      () {
        final hintText = [
          LocalizedModel(
            language: 'en-US',
            text: hintTextController.text,
          ),
        ];

        customfield = customfield.copyWith(hintText: hintText);
      },
    );
  }

  void _setInputType(String? value) {
    if (value != null) {
      setState(() {
        typeSelected = value;

        customfield = customfield.copyWith(inputType: typeSelected);
      });
    }
  }

  void _setLenghtLimit(String? value) {
    setState(() {
      final lenghtLimit = lenghtLimitController.text;
      customfield = customfield.copyWith(lengthLimit: lenghtLimit);
    });
  }

  void _setMaxLines(String? value) {
    setState(() {
      final maxLines = int.parse(maxLineController.text);

      customfield = customfield.copyWith(maxLines: maxLines);
    });
  }

  void _setMinLines(String? value) {
    setState(() {
      final minLines = int.parse(minLineController.text);

      customfield = customfield.copyWith(minLines: minLines);
    });
  }

  void _setActiveStatus(bool value) {
    setState(() {
      isActivated = value;

      final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

      customfield = customfield.copyWith(status: status);
    });
  }

  void _saveCustomField() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewCustomField) {
        customfield = customfield.toCreated(
          widget.currentUser.email,
          DateTime.now(),
        );
        print(customfield);
        context.read<EditCustomFieldBloc>().add(CreateCurrentCustomFieldEvent(
              customfield: customfield,
              companyId: widget.currentUser.currentCompany,
            ));
      } else {
        customfield = customfield.toUpdated(
          widget.currentUser.email,
          DateTime.now(),
        );

        context.read<EditCustomFieldBloc>().add(UpdateCurrentCustomFieldEvent(
              customfield: customfield,
              companyId: widget.currentUser.currentCompany,
            ));
      }
    }
  }

  void _deleteCustomField() {
    context.read<EditCustomFieldBloc>().add(DeleteCurrentCustomFieldEvent(
          customfieldId: customfield.id,
          companyId: widget.currentUser.currentCompany,
        ));
  }

  void _goBackAndUpdate() {
    if (!widget.isNewCustomField) {
      context.read<CustomFieldBloc>().add(UpdateCustomFieldEvent(
            customfield: customfield,
            updateType: UpdateType.updated,
          ));
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(widget.initialCustomField),
        title: Text(
          widget.isNewCustomField
              ? tr('masterData.cm.customfields.create')
              : tr('masterData.cm.customfields.edit'),
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
            CustomContainer(
              child: _buildCustomFieldForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Visibility(
              visible: widget.initialCustomField != CustomFieldModel.empty(),
              child:
                  _buildConfigurationInfo(context, widget.initialCustomField),
            ),
          ],
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton(CustomFieldModel customfield) {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Ionicons.chevron_back_outline,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Builder _buildSaveButton() {
    return Builder(
      builder: (context) {
        if (customfield != widget.initialCustomField) {
          return CustomIconButton(
            onPressed: _saveCustomField,
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
      },
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
          text: tr('masterData.cm.customfields.formtitle'), //!
          required: true,
        ),
        CustomTextField(
          controller: titleController,
          hintText: tr('masterData.cm.customfields.formtitlehint'), //!
          onChanged: _setTitle,
          required: true,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.placeholder'), //!
          required: true,
        ),
        CustomTextField(
          controller: hintTextController,
          hintText: tr('masterData.cm.customfields.placeholderhint'), //!
          onChanged: _setHintText,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.customfieldtype'), //!
          required: true,
        ),
        CustomTextField(
          controller: customFieldTypeController,
          hintText: tr('masterData.cm.customfields.customfieldtypehint'), //!
          onChanged: _setInputType,
          required: true,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.lenghtlimit'), //!
          required: true,
        ),
        CustomTextField(
          hintText: tr('masterData.cm.customfields.lenghtlimithint'), //!
          onChanged: _setLenghtLimit,
          required: true,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.maxline'), //!
          required: true,
        ),
        CustomTextField(
          hintText: tr('masterData.cm.customfields.maxlinehint'), //!
          onChanged: _setMaxLines,
          required: true,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        TitleRequiredText(
          text: tr('masterData.cm.customfields.minline'), //!
          required: true,
        ),
        CustomTextField(
          hintText: tr('masterData.cm.customfields.minlinehint'), //!
          onChanged: _setMinLines,
          required: true,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Column _buildConfigurationInfo(
    BuildContext context,
    CustomFieldModel customfield,
  ) {
    return Column(
      children: <Widget>[
        CustomContainer(
          child: ConfigurationInfo(
            configBody: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  tr('masterData.etc.active'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                CustomSwitchButton(
                  value: isActivated,
                  onChanged: _setActiveStatus,
                ),
              ],
            ),
            updatedBy: customfield.updatedBy,
            updatedDate: customfield.updatedDate,
            onDeletePressed: _deleteCustomField,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
