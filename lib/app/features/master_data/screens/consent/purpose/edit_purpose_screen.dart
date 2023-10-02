import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/edit_purpose/edit_purpose_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose/purpose_bloc.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_dropdown_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
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

    _getUserInfo();
  }

  void _getUserInfo() {
    final signInBloc = BlocProvider.of<SignInBloc>(context, listen: false);
    if (signInBloc.state is SignedInUser) {
      final signedIn = signInBloc.state as SignedInUser;

      currentUser = signedIn.user;
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
      child: EditPurposeView(
        currentUser: currentUser,
      ),
    );
  }
}

class EditPurposeView extends StatefulWidget {
  const EditPurposeView({
    super.key,
    required this.currentUser,
  });

  final UserModel currentUser;

  @override
  State<EditPurposeView> createState() => _EditPurposeViewState();
}

class _EditPurposeViewState extends State<EditPurposeView> {
  late TextEditingController descriptionController;
  late TextEditingController warningDescriptionController;
  late TextEditingController retentionPeriodController;

  late String unitSelected;
  late bool isActivated;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    warningDescriptionController = TextEditingController();
    retentionPeriodController = TextEditingController();

    unitSelected = 'd';
    isActivated = true;
  }

  @override
  void dispose() {
    descriptionController.dispose();
    warningDescriptionController.dispose();
    retentionPeriodController.dispose();

    super.dispose();
  }

  void _initialData(PurposeModel purpose) {
    if (purpose != PurposeModel.empty()) {
      if (purpose.description.isNotEmpty) {
        descriptionController = TextEditingController(
          text: purpose.description.first.text,
        );
      }
      if (purpose.warningDescription.isNotEmpty) {
        warningDescriptionController = TextEditingController(
          text: purpose.warningDescription.first.text,
        );
      }

      retentionPeriodController = TextEditingController(
        text: purpose.retentionPeriod.toString(),
      );

      unitSelected = purpose.periodUnit.isNotEmpty ? purpose.periodUnit : 'd';

      isActivated = purpose.status == ActiveStatus.active;
    }
  }

  void _setPeriodUnit(String? value) {
    if (value != null) {
      setState(() {
        unitSelected = value;
      });
    }
  }

  void _setActiveStatus(bool value) {
    setState(() {
      isActivated = value;
    });
  }

  void _savePurpose() {
    if (_formKey.currentState!.validate()) {
      final editPurposeBloc = BlocProvider.of<EditPurposeBloc>(
        context,
        listen: false,
      );

      if (editPurposeBloc.state is GotCurrentPurpose) {
        final purpose = (editPurposeBloc.state as GotCurrentPurpose).purpose;
        _updatePurpose(purpose);
      }
    }
  }

  void _updatePurpose(PurposeModel initialPurpose) {
    final description = [
      LocalizedModel(
        language: 'en-US',
        text: descriptionController.text,
      ),
    ];
    final warningDescription = [
      LocalizedModel(
        language: 'en-US',
        text: warningDescriptionController.text,
      ),
    ];
    final retentionPeriod = int.parse(retentionPeriodController.text);
    final periodUnit = unitSelected;
    final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

    PurposeModel updated = initialPurpose != PurposeModel.empty()
        ? initialPurpose
        : PurposeModel.empty().copyWith(
            createdBy: widget.currentUser.email,
            createdDate: DateTime.now(),
          );

    updated = updated.copyWith(
      description: description,
      warningDescription: warningDescription,
      retentionPeriod: retentionPeriod,
      periodUnit: periodUnit,
      status: status,
      updatedBy: widget.currentUser.email,
      updatedDate: DateTime.now(),
    );

    context.read<EditPurposeBloc>().add(UpdateCurrentPurposeEvent(
        purpose: updated, companyId: widget.currentUser.currentCompany));
  }

  void _goBack() {
    final editPurposeBloc = BlocProvider.of<EditPurposeBloc>(
      context,
      listen: false,
    );

    if (editPurposeBloc.state is GotCurrentPurpose) {
      final purpose = (editPurposeBloc.state as GotCurrentPurpose).purpose;

      context.read<PurposeBloc>().add(UpdatePurposeEvent(purpose: purpose));
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: _goBack,
          icon: Ionicons.chevron_back_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('masterData.cm.purpose.edit'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          CustomIconButton(
            onPressed: _savePurpose,
            icon: Ionicons.save_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
      body: BlocConsumer<EditPurposeBloc, EditPurposeState>(
        listener: (context, state) {
          if (state is GotCurrentPurpose) {
            _initialData(state.purpose);
          }
        },
        builder: (context, state) {
          if (state is GotCurrentPurpose) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: UiConfig.lineSpacing),
                  CustomContainer(
                    child: _buildPurposeForm(context),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Visibility(
                    visible: state.purpose != PurposeModel.empty(),
                    child: _buildConfigurationInfo(context, state.purpose),
                  ),
                ],
              ),
            );
          }
          if (state is EditPurposeError) {
            return CustomContainer(
              margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: Center(
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }
          return const CustomContainer(
            margin: EdgeInsets.all(UiConfig.defaultPaddingSpacing),
            child: Center(
              child: LoadingIndicator(),
            ),
          );
        },
      ),
    );
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
                tr('masterData.cm.purpose.list'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purpose.description'),
            required: true,
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: tr('masterData.cm.purpose.descriptionHint'),
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purpose.warningDescription'),
          ),
          CustomTextField(
            controller: warningDescriptionController,
            hintText: tr('masterData.cm.purpose.warningDescriptionHint'),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purpose.retentionPeriod'),
            required: true,
          ),
          CustomTextField(
            controller: retentionPeriodController,
            hintText: tr('masterData.cm.purpose.retentionPeriodHint'),
            keyboardType: TextInputType.number,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purpose.periodUnit'),
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
                  tr('masterData.etc.active'),
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
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
