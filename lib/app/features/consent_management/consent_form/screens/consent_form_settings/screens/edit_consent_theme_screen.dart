import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form_settings/consent_form_settings_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/edit_consent_theme/edit_consent_theme_bloc.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/color_picker_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditConsentThemeScreen extends StatefulWidget {
  const EditConsentThemeScreen({
    super.key,
    required this.consentThemeId,
    this.copyConsentThemeId,
  });

  final String consentThemeId;
  final String? copyConsentThemeId;

  @override
  State<EditConsentThemeScreen> createState() => _EditConsentThemeScreenState();
}

class _EditConsentThemeScreenState extends State<EditConsentThemeScreen> {
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
    return BlocProvider<EditConsentThemeBloc>(
      create: (context) => serviceLocator<EditConsentThemeBloc>()
        ..add(
          GetCurrentConsentThemeEvent(
            consentThemeId: widget.copyConsentThemeId != null
                ? widget.copyConsentThemeId!
                : widget.consentThemeId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditConsentThemeBloc, EditConsentThemeState>(
        listener: (context, state) {
          if (state is CreatedCurrentConsentTheme) {
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

            final event = UpdateConsentThemesEvent(
              consentTheme: state.consentTheme,
              updateType: UpdateType.created,
            );
            context.read<ConsentFormSettingsBloc>().add(event);

            context.pop();
          }

          if (state is UpdatedCurrentConsentTheme) {
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

          if (state is DeletedCurrentConsentTheme) {
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

            final deleted = ConsentThemeModel.empty().copyWith(
              id: state.consentThemeId,
            );
            final event = UpdateConsentThemesEvent(
              consentTheme: deleted,
              updateType: UpdateType.deleted,
            );

            context.read<ConsentFormSettingsBloc>().add(event);

            context.pop();
          }
        },
        builder: (context, state) {
          if (state is GotCurrentConsentTheme) {
            return EditConsentThemeView(
              initialConsentTheme: state.consentTheme,
              currentUser: currentUser,
              isNewConsentTheme: widget.consentThemeId.isEmpty,
            );
          }
          if (state is UpdatedCurrentConsentTheme) {
            return EditConsentThemeView(
              initialConsentTheme: state.consentTheme,
              currentUser: currentUser,
              isNewConsentTheme: widget.consentThemeId.isEmpty,
            );
          }
          if (state is EditConsentThemeError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditConsentThemeView extends StatefulWidget {
  const EditConsentThemeView({
    super.key,
    required this.initialConsentTheme,
    required this.currentUser,
    required this.isNewConsentTheme,
  });

  final ConsentThemeModel initialConsentTheme;
  final UserModel currentUser;
  final bool isNewConsentTheme;

  @override
  State<EditConsentThemeView> createState() => _EditConsentThemeViewState();
}

class _EditConsentThemeViewState extends State<EditConsentThemeView> {
  late ConsentThemeModel consentTheme;

  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  void _initialData() {
    consentTheme = widget.initialConsentTheme;

    titleController = TextEditingController(
      text: consentTheme.title.toString(),
    );
  }

  void _setThemeTitle(String? value) {
    if (value != null) {
      setState(() {
        consentTheme = consentTheme.copyWith(
          title: titleController.text,
        );
      });
    }
  }

  void _saveConsentTheme() {
    if (widget.isNewConsentTheme) {
      consentTheme = consentTheme.setCreate(
        widget.currentUser.email,
        DateTime.now(),
      );

      final event = CreateCurrentConsentThemeEvent(
        consentTheme: consentTheme,
        companyId: widget.currentUser.currentCompany,
      );

      context.read<EditConsentThemeBloc>().add(event);
    } else {
      consentTheme = consentTheme.setUpdate(
        widget.currentUser.email,
        DateTime.now(),
      );

      final event = UpdateCurrentConsentThemeEvent(
        consentTheme: consentTheme,
        companyId: widget.currentUser.currentCompany,
      );

      context.read<EditConsentThemeBloc>().add(event);
    }
  }

  void _deleteConsentTheme() {
    final event = DeleteCurrentConsentThemeEvent(
      consentThemeId: consentTheme.id,
      companyId: widget.currentUser.currentCompany,
    );

    context.read<EditConsentThemeBloc>().add(event);
  }

  void _goBackAndUpdate() {
    if (!widget.isNewConsentTheme) {
      final event = UpdateConsentThemesEvent(
        consentTheme: consentTheme,
        updateType: UpdateType.updated,
      );

      context.read<ConsentFormSettingsBloc>().add(event);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(widget.initialConsentTheme),
        title: Text(
          widget.isNewConsentTheme ? 'New consent theme' : 'Edit consent theme',
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
            _buildThemeInfoSection(context),
            const SizedBox(height: UiConfig.lineSpacing),
            _buildHeaderSection(context),
            const SizedBox(height: UiConfig.lineSpacing),
            _buildBodySection(context),
            const SizedBox(height: UiConfig.lineSpacing),
            _buildFooterSection(context),
            const SizedBox(height: UiConfig.lineSpacing),
            Visibility(
              visible: !widget.isNewConsentTheme,
              child: _buildConfigurationInfo(
                context,
                consentTheme: widget.initialConsentTheme,
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton(ConsentThemeModel consentTheme) {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Ionicons.chevron_back_outline,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Builder _buildSaveButton() {
    return Builder(builder: (context) {
      if (consentTheme != widget.initialConsentTheme) {
        return CustomIconButton(
          onPressed: _saveConsentTheme,
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

  CustomContainer _buildThemeInfoSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Consent Theme Infomation',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'Title',
          ),
          CustomTextField(
            controller: titleController,
            hintText: 'Enter consent theme title',
            onChanged: _setThemeTitle,
          ),
        ],
      ),
    );
  }

  CustomContainer _buildHeaderSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Header',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Header text color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.headerTextColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      headerTextColor: color,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Header background color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.headerBackgroundColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      headerBackgroundColor: color,
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  CustomContainer _buildBodySection(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Body',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Form text color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.formTextColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      formTextColor: color,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Action button color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.actionButtonColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      actionButtonColor: color,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Category icon color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.categoryIconColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      categoryIconColor: color,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Category title text color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.categoryTitleTextColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      categoryTitleTextColor: color,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Body background color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.bodyBackgroundColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      bodyBackgroundColor: color,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Background color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.backgroundColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      backgroundColor: color,
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  CustomContainer _buildFooterSection(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Footer',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Link to policy text color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.linkToPolicyTextColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      linkToPolicyTextColor: color,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Submit button color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.submitButtonColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      submitButtonColor: color,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Submit text color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.submitTextColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      submitTextColor: color,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Cancel button color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.cancelButtonColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      cancelButtonColor: color,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Cancel text color',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ColorPickerButton(
                initialColor: consentTheme.cancelTextColor,
                onColorChanged: (color) {
                  setState(() {
                    consentTheme = consentTheme.copyWith(
                      cancelTextColor: color,
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildConfigurationInfo(
    BuildContext context, {
    required ConsentThemeModel consentTheme,
  }) {
    return Column(
      children: <Widget>[
        CustomContainer(
          child: ConfigurationInfo(
            updatedBy: consentTheme.updatedBy,
            updatedDate: consentTheme.updatedDate,
            onDeletePressed: _deleteConsentTheme,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
