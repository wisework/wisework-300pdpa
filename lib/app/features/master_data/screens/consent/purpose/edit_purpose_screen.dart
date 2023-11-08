import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/edit_purpose/edit_purpose_bloc.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_dropdown_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditPurposeScreen extends StatefulWidget {
  const EditPurposeScreen({
    super.key,
    required this.purposeId,
  });

  final String purposeId;

  @override
  State<EditPurposeScreen> createState() => _EditPurposeScreenState();
}

class _EditPurposeScreenState extends State<EditPurposeScreen> {
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
    return BlocProvider<EditPurposeBloc>(
      create: (context) => serviceLocator<EditPurposeBloc>()
        ..add(
          GetCurrentPurposeEvent(
            purposeId: widget.purposeId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditPurposeBloc, EditPurposeState>(
        listener: (context, state) {
          if (state is CreatedCurrentPurpose) {
            showToast(context,
                text: tr(
                    'consentManagement.consentForm.editConsentTheme.createSuccess')); //!

            context.pop(
              UpdatedReturn<PurposeModel>(
                object: state.purpose,
                type: UpdateType.created,
              ),
            );
          }

          if (state is UpdatedCurrentPurpose) {
            showToast(context,
                text: tr(
                    'consentManagement.consentForm.editConsentTheme.updateSuccess')); //!
          }

          if (state is DeletedCurrentPurpose) {
            showToast(context,
                text: tr(
                    'consentManagement.consentForm.editConsentTheme.deleteSuccess')); //!

            final deleted = PurposeModel.empty().copyWith(id: state.purposeId);
            context.pop(
              UpdatedReturn<PurposeModel>(
                object: deleted,
                type: UpdateType.deleted,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GotCurrentPurpose) {
            return EditPurposeView(
              initialPurpose: state.purpose,
              currentUser: currentUser,
              isNewPurpose: widget.purposeId.isEmpty,
            );
          }
          if (state is UpdatedCurrentPurpose) {
            return EditPurposeView(
              initialPurpose: state.purpose,
              currentUser: currentUser,
              isNewPurpose: widget.purposeId.isEmpty,
            );
          }
          if (state is EditPurposeError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditPurposeView extends StatefulWidget {
  const EditPurposeView({
    super.key,
    required this.initialPurpose,
    required this.currentUser,
    required this.isNewPurpose,
  });

  final PurposeModel initialPurpose;
  final UserModel currentUser;
  final bool isNewPurpose;

  @override
  State<EditPurposeView> createState() => _EditPurposeViewState();
}

class _EditPurposeViewState extends State<EditPurposeView> {
  late PurposeModel purpose;

  late TextEditingController descriptionController;
  late TextEditingController warningDescriptionController;
  late TextEditingController retentionPeriodController;

  late String unitSelected;
  late bool isActivated;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    warningDescriptionController.dispose();
    retentionPeriodController.dispose();

    super.dispose();
  }

  void _initialData() {
    const language = 'th-TH';

    purpose = widget.initialPurpose;

    descriptionController = TextEditingController();
    warningDescriptionController = TextEditingController();
    retentionPeriodController = TextEditingController();

    unitSelected = 'd';
    isActivated = true;

    if (purpose != PurposeModel.empty()) {
      if (purpose.description.isNotEmpty) {
        final description = purpose.description
            .firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            )
            .text;

        descriptionController = TextEditingController(
          text: description,
        );
      }
      if (purpose.warningDescription.isNotEmpty) {
        final warningDescription = purpose.warningDescription
            .firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            )
            .text;

        warningDescriptionController = TextEditingController(
          text: warningDescription,
        );
      }

      retentionPeriodController = TextEditingController(
        text: purpose.retentionPeriod.toString(),
      );

      unitSelected = purpose.periodUnit.isNotEmpty ? purpose.periodUnit : 'd';

      isActivated = purpose.status == ActiveStatus.active;
    }
  }

  void _setDescription(String? value) {
    setState(() {
      final description = [
        LocalizedModel(
          language: 'th-TH',
          text: descriptionController.text,
        ),
      ];

      purpose = purpose.copyWith(description: description);
    });
  }

  void _setWarningDescription(String? value) {
    setState(() {
      final warningDescription = [
        LocalizedModel(
          language: 'th-TH',
          text: warningDescriptionController.text,
        ),
      ];

      purpose = purpose.copyWith(warningDescription: warningDescription);
    });
  }

  void _setRetentionPeriod(String? value) {
    if (value != null && value.isNotEmpty) {
      setState(() {
        final retentionPeriod = int.parse(retentionPeriodController.text);

        purpose = purpose.copyWith(retentionPeriod: retentionPeriod);
      });
    }
  }

  void _setPeriodUnit(String? value) {
    if (value != null) {
      setState(() {
        unitSelected = value;

        purpose = purpose.copyWith(periodUnit: unitSelected);
      });
    }
  }

  void _setActiveStatus(bool value) {
    setState(() {
      isActivated = value;

      final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

      purpose = purpose.copyWith(status: status);
    });
  }

  void _savePurpose() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewPurpose) {
        purpose = purpose.setCreate(
          widget.currentUser.email,
          DateTime.now(),
        );

        final event = CreateCurrentPurposeEvent(
          purpose: purpose,
          companyId: widget.currentUser.currentCompany,
        );

        context.read<EditPurposeBloc>().add(event);
      } else {
        purpose = purpose.setUpdate(
          widget.currentUser.email,
          DateTime.now(),
        );

        final event = UpdateCurrentPurposeEvent(
          purpose: purpose,
          companyId: widget.currentUser.currentCompany,
        );
        context.read<EditPurposeBloc>().add(event);
      }
    }
  }

  void _deletePurpose() {
    final event = DeleteCurrentPurposeEvent(
      purposeId: purpose.id,
      companyId: widget.currentUser.currentCompany,
    );
    context.read<EditPurposeBloc>().add(event);
  }

  void _goBackAndUpdate() {
    if (!widget.isNewPurpose) {
      context.pop(
        UpdatedReturn<PurposeModel>(
          object: widget.initialPurpose,
          type: UpdateType.updated,
        ),
      );
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: Text(
          widget.isNewPurpose
              ? tr('masterData.cm.purpose.create') //!
              : tr('masterData.cm.purpose.edit'), //!
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
              child: _buildPurposeForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Visibility(
              visible: widget.initialPurpose != PurposeModel.empty(),
              child: _buildConfigurationInfo(context, widget.initialPurpose),
            ),
          ],
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Builder _buildSaveButton() {
    return Builder(builder: (context) {
      if (purpose != widget.initialPurpose) {
        return CustomIconButton(
          onPressed: _savePurpose,
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
    });
  }

  Form _buildPurposeForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('masterData.cm.purpose.list'), //!
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purpose.description'), //!
            required: true,
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: tr('masterData.cm.purpose.descriptionHint'), //!
            onChanged: _setDescription,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purpose.warningDescription'), //!
          ),
          CustomTextField(
            controller: warningDescriptionController,
            hintText: tr('masterData.cm.purpose.warningDescriptionHint'), //!
            onChanged: _setWarningDescription,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purpose.retentionPeriod'), //!
            required: true,
          ),
          CustomTextField(
            controller: retentionPeriodController,
            hintText: tr('masterData.cm.purpose.retentionPeriodHint'), //!
            keyboardType: TextInputType.number,
            onChanged: _setRetentionPeriod,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purpose.periodUnit'), //!
          ),
          CustomDropdownButton<String>(
            value: unitSelected,
            items: periodUnits.map(
              (unit) {
                return DropdownMenuItem(
                  value: unit[0].toLowerCase(),
                  child: Text(
                    unit,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ).toList(),
            onSelected: _setPeriodUnit,
          ),
        ],
      ),
    );
  }

  Column _buildConfigurationInfo(
    BuildContext context,
    PurposeModel purpose,
  ) {
    return Column(
      children: <Widget>[
        CustomContainer(
          child: ConfigurationInfo(
            configBody: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  tr('masterData.cm.purposeCategory.active'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                CustomSwitchButton(
                  value: isActivated,
                  onChanged: _setActiveStatus,
                ),
              ],
            ),
            updatedBy: purpose.updatedBy,
            updatedDate: purpose.updatedDate,
            onDeletePressed: _deletePurpose,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
