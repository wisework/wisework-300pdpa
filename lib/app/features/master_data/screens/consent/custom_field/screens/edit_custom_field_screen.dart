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
import 'package:pdpa/app/shared/widgets/customs/custom_dropdown_button.dart';
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
              text: 'Create successfully', //!
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
              text: 'Update successfully', //!
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
              text: 'Delete successfully', //!
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
  late TextEditingController lenghtLimitController;
  late TextEditingController minLineController;
  late TextEditingController maxLineController;

  late int inputTypeSelected;

  int? lenghtLimit;
  late bool isActivated;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<TextInputType, String> customInputTypeNames = {
    TextInputType.text: tr('app.text'),
    TextInputType.multiline: tr('app.multiline'),
    TextInputType.number: tr('app.number'),
    TextInputType.phone: tr('app.phone'),
    TextInputType.emailAddress: tr('app.emailAddress'),
    TextInputType.url: tr('app.url'),
  };

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  void dispose() {
    titleController.dispose();
    hintTextController.dispose();
    lenghtLimitController.dispose();
    minLineController.dispose();
    maxLineController.dispose();

    super.dispose();
  }

  void _initialData() {
    customfield = widget.initialCustomField;

    titleController = TextEditingController();
    hintTextController = TextEditingController();
    lenghtLimitController = TextEditingController();
    minLineController = TextEditingController();
    maxLineController = TextEditingController();

    inputTypeSelected = 0;
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
      if (customfield.lengthLimit != 0) {
        lenghtLimitController = TextEditingController(
          text: customfield.lengthLimit.toString(),
        );
      }
      if (customfield.maxLines != 0) {
        maxLineController = TextEditingController(
          text: customfield.maxLines.toString(),
        );
      }
      if (customfield.minLines != 0) {
        minLineController = TextEditingController(
          text: customfield.minLines.toString(),
        );
      }

      inputTypeSelected = customfield.inputType.index;
      isActivated = customfield.status == ActiveStatus.active;
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

  void _setInputType(int? value) {
    if (value != null) {
      setState(() {
        inputTypeSelected = value;

        customfield = customfield.copyWith(
          inputType: TextInputType.values[value],
        );
      });
    }
  }

  void _setLenghtLimit(String? value) {
    if (value != null) {
      setState(() {
        lenghtLimit = int.parse(value);

        customfield = customfield.copyWith(lengthLimit: lenghtLimit);
      });
    }
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
        customfield = customfield.setCreate(
          widget.currentUser.email,
          DateTime.now(),
        );
        context.read<EditCustomFieldBloc>().add(CreateCurrentCustomFieldEvent(
              customfield: customfield,
              companyId: widget.currentUser.currentCompany,
            ));
      } else {
        customfield = customfield.setUpdate(
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
              ? tr('masterData.cm.customfields.create') //!
              : tr('masterData.cm.customfields.edit'), //!
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

  Form _buildCustomFieldForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
            text: tr('masterData.cm.customfields.hinttext'), //!
            required: true,
          ),
          CustomTextField(
            controller: hintTextController,
            hintText: tr('masterData.cm.customfields.hinttexthint'), //!
            onChanged: _setHintText,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.customfields.inputtype'), //!
            required: true,
          ),
          CustomDropdownButton<int>(
            value: inputTypeSelected,
            items: customInputTypeNames.keys.map(
              (inputType) {
                return DropdownMenuItem(
                  value: inputType.index,
                  child: Text(
                    customInputTypeNames[inputType].toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ).toList(),
            onSelected: _setInputType,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.customfields.lenghtlimit'), //!
          ),
          CustomTextField(
            controller: lenghtLimitController,
            hintText: tr('masterData.cm.customfields.lenghtlimithint'), //!
            onChanged: _setLenghtLimit,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.customfields.maxline'), //!
            required: true,
          ),
          CustomTextField(
            controller: maxLineController,
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
            controller: minLineController,
            hintText: tr('masterData.cm.customfields.minlinehint'), //!
            onChanged: _setMinLines,
            required: true,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  CustomIconButton _buildPopButton(CustomFieldModel customfield) {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Icons.chevron_left_outlined,
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
          iconColor: Theme.of(context).colorScheme.onTertiary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        );
      },
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
                  tr('masterData.cm.purposeCategory.active'), //!
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
