import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/edit_reject_type/edit_reject_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reject_type/reject_type_bloc.dart';
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

class EditRejectTypeScreen extends StatefulWidget {
  const EditRejectTypeScreen({
    super.key,
    required this.rejectTypeId,
  });

  final String rejectTypeId;

  @override
  State<EditRejectTypeScreen> createState() => _EditRejectTypeScreenState();
}

class _EditRejectTypeScreenState extends State<EditRejectTypeScreen> {
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
    return BlocProvider<EditRejectTypeBloc>(
      create: (context) => serviceLocator<EditRejectTypeBloc>()
        ..add(
          GetCurrentRejectTypeEvent(
            rejectTypeId: widget.rejectTypeId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditRejectTypeBloc, EditRejectTypeState>(
        listener: (context, state) {
          if (state is CreatedCurrentRejectType) {
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

            context.read<RejectTypeBloc>().add(UpdateRejectTypeEvent(
                rejectType: state.rejectType, updateType: UpdateType.created));

            context.pop();
          }

          if (state is UpdatedCurrentRejectType) {
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

          if (state is DeletedCurrentRejectType) {
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

            final deleted = RejectTypeModel.empty()
                .copyWith(rejectTypeId: state.rejectTypeId);

            context.read<RejectTypeBloc>().add(UpdateRejectTypeEvent(
                rejectType: deleted, updateType: UpdateType.deleted));

            context.pop();
          }
        },
        builder: (context, state) {
          if (state is GotCurrentRejectType) {
            return EditRejectTypeView(
              initialRejectType: state.rejectType,
              currentUser: currentUser,
              isNewRejectType: widget.rejectTypeId.isEmpty,
            );
          }
          if (state is UpdatedCurrentRejectType) {
            return EditRejectTypeView(
              initialRejectType: state.rejectType,
              currentUser: currentUser,
              isNewRejectType: widget.rejectTypeId.isEmpty,
            );
          }
          if (state is EditRejectTypeError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditRejectTypeView extends StatefulWidget {
  const EditRejectTypeView({
    super.key,
    required this.initialRejectType,
    required this.currentUser,
    required this.isNewRejectType,
  });

  final RejectTypeModel initialRejectType;
  final UserModel currentUser;
  final bool isNewRejectType;

  @override
  State<EditRejectTypeView> createState() => _EditRejectTypeViewState();
}

class _EditRejectTypeViewState extends State<EditRejectTypeView> {
  late RejectTypeModel rejectType;
  late TextEditingController rejectTypeCodeController;
  late TextEditingController descriptionController;
  late bool isActivated;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initialData();
  }

  @override
  void dispose() {
    rejectTypeCodeController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void _initialData() {
    rejectType = widget.initialRejectType;
    rejectTypeCodeController = TextEditingController();
    descriptionController = TextEditingController();

    isActivated = true;

    if (rejectType != RejectTypeModel.empty()) {
      if (rejectType.rejectCode.isNotEmpty) {
        rejectTypeCodeController = TextEditingController(
          text: rejectType.rejectCode,
        );
      }
      if (rejectType.description.isNotEmpty) {
        descriptionController = TextEditingController(
          text: rejectType.description.first.text,
        );
      }

      isActivated = rejectType.status == ActiveStatus.active;
    }
  }

  void _setRejectCode(String? value) {
    setState(() {
      final rejectCode = rejectTypeCodeController.text;

      rejectType = rejectType.copyWith(rejectCode: rejectCode);
    });
  }

  void _setDescription(String? value) {
    setState(
      () {
        final description = [
          LocalizedModel(
            language: 'en-US',
            text: descriptionController.text,
          ),
        ];

        rejectType = rejectType.copyWith(description: description);
      },
    );
  }

  void _setActiveStatus(bool value) {
    setState(() {
      isActivated = value;

      final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

      rejectType = rejectType.copyWith(status: status);
    });
  }

  void _saveRejectType() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewRejectType) {
        rejectType = rejectType.setCreate(
          widget.currentUser.email,
          DateTime.now(),
        );
        context.read<EditRejectTypeBloc>().add(CreateCurrentRejectTypeEvent(
              rejectType: rejectType,
              companyId: widget.currentUser.currentCompany,
            ));
      } else {
        rejectType = rejectType.setUpdate(
          widget.currentUser.email,
          DateTime.now(),
        );

        context.read<EditRejectTypeBloc>().add(UpdateCurrentRejectTypeEvent(
              rejectType: rejectType,
              companyId: widget.currentUser.currentCompany,
            ));
      }
    }
  }

  void _deleteRejectType() {
    context.read<EditRejectTypeBloc>().add(DeleteCurrentRejectTypeEvent(
          rejectTypeId: rejectType.rejectTypeId,
          companyId: widget.currentUser.currentCompany,
        ));
  }

  void _goBackAndUpdate() {
    if (!widget.isNewRejectType) {
      context.read<RejectTypeBloc>().add(UpdateRejectTypeEvent(
            rejectType: rejectType,
            updateType: UpdateType.updated,
          ));
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(widget.initialRejectType),
        title: Text(
          widget.isNewRejectType
              ? tr('masterData.dsr.rejections.create')
              : tr('masterData.dsr.rejections.edit'),
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
              child: _buildRejectTypeForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Visibility(
              visible: widget.initialRejectType != RejectTypeModel.empty(),
              child: _buildConfigurationInfo(context, widget.initialRejectType),
            ),
          ],
        ),
      ),
    );
  }

  Form _buildRejectTypeForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('masterData.dsr.rejections.title'), //!
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.rejections.rejectcode'), //!
            required: true,
          ),
          CustomTextField(
            controller: rejectTypeCodeController,
            hintText: tr('masterData.dsr.rejections.rejectcodeHint'), //!
            onChanged: _setRejectCode,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.rejections.description'), //!
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: tr('masterData.dsr.rejections.descriptionHint'), //!
            onChanged: _setDescription,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  CustomIconButton _buildPopButton(RejectTypeModel rejectType) {
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
        if (rejectType != widget.initialRejectType) {
          return CustomIconButton(
            onPressed: _saveRejectType,
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

  Column _buildConfigurationInfo(
    BuildContext context,
    RejectTypeModel rejectType,
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
            updatedBy: rejectType.updatedBy,
            updatedDate: rejectType.updatedDate,
            onDeletePressed: _deleteRejectType,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
