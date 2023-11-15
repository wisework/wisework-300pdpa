import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/edit_request_type/edit_request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
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

class EditRequestTypeScreen extends StatefulWidget {
  const EditRequestTypeScreen({
    super.key,
    required this.requestTypeId,
  });

  final String requestTypeId;

  @override
  State<EditRequestTypeScreen> createState() => _EditRequestTypeScreenState();
}

class _EditRequestTypeScreenState extends State<EditRequestTypeScreen> {
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
    return BlocProvider<EditRequestTypeBloc>(
      create: (context) => serviceLocator<EditRequestTypeBloc>()
        ..add(
          GetCurrentRequestTypeEvent(
            requestTypeId: widget.requestTypeId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditRequestTypeBloc, EditRequestTypeState>(
        listener: (context, state) {
          if (state is CreatedCurrentRequestType) {
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

            context.read<RequestTypeBloc>().add(UpdateRequestTypeEvent(
                requestType: state.requestType,
                updateType: UpdateType.created));

            context.pop();
          }

          if (state is UpdatedCurrentRequestType) {
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

          if (state is DeletedCurrentRequestType) {
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

            final deleted = RequestTypeModel.empty()
                .copyWith(id: state.requestTypeId);

            context.read<RequestTypeBloc>().add(UpdateRequestTypeEvent(
                requestType: deleted, updateType: UpdateType.deleted));

            context.pop();
          }
        },
        builder: (context, state) {
          if (state is GotCurrentRequestType) {
            return EditRequestTypeView(
              initialRequestType: state.requestType,
              currentUser: currentUser,
              isNewRequestType: widget.requestTypeId.isEmpty,
            );
          }
          if (state is UpdatedCurrentRequestType) {
            return EditRequestTypeView(
              initialRequestType: state.requestType,
              currentUser: currentUser,
              isNewRequestType: widget.requestTypeId.isEmpty,
            );
          }
          if (state is EditRequestTypeError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditRequestTypeView extends StatefulWidget {
  const EditRequestTypeView({
    super.key,
    required this.initialRequestType,
    required this.currentUser,
    required this.isNewRequestType,
  });

  final RequestTypeModel initialRequestType;
  final UserModel currentUser;
  final bool isNewRequestType;

  @override
  State<EditRequestTypeView> createState() => _EditRequestTypeViewState();
}

class _EditRequestTypeViewState extends State<EditRequestTypeView> {
  late RequestTypeModel requestType;
  late TextEditingController requestTypeCodeController;
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
    requestTypeCodeController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  void _initialData() {
    requestType = widget.initialRequestType;
    requestTypeCodeController = TextEditingController();
    descriptionController = TextEditingController();

    isActivated = true;

    if (requestType != RequestTypeModel.empty()) {
      if (requestType.requestCode.isNotEmpty) {
        requestTypeCodeController = TextEditingController(
          text: requestType.requestCode,
        );
      }
      if (requestType.description.isNotEmpty) {
        descriptionController = TextEditingController(
          text: requestType.description.first.text,
        );
      }

      isActivated = requestType.status == ActiveStatus.active;
    }
  }

  void _setRequestCode(String? value) {
    setState(() {
      final requestCode = requestTypeCodeController.text;

      requestType = requestType.copyWith(requestCode: requestCode);
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

        requestType = requestType.copyWith(description: description);
      },
    );
  }

  void _setActiveStatus(bool value) {
    setState(() {
      isActivated = value;

      final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

      requestType = requestType.copyWith(status: status);
    });
  }

  void _saveRequestType() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewRequestType) {
        requestType = requestType.toCreated(
          widget.currentUser.email,
          DateTime.now(),
        );
        context.read<EditRequestTypeBloc>().add(CreateCurrentRequestTypeEvent(
              requestType: requestType,
              companyId: widget.currentUser.currentCompany,
            ));
      } else {
        requestType = requestType.toUpdated(
          widget.currentUser.email,
          DateTime.now(),
        );

        context.read<EditRequestTypeBloc>().add(UpdateCurrentRequestTypeEvent(
              requestType: requestType,
              companyId: widget.currentUser.currentCompany,
            ));
      }
    }
  }

  void _deleteRequestType() {
    context.read<EditRequestTypeBloc>().add(DeleteCurrentRequestTypeEvent(
          requestTypeId: requestType.id,
          companyId: widget.currentUser.currentCompany,
        ));
  }

  void _goBackAndUpdate() {
    if (!widget.isNewRequestType) {
      context.read<RequestTypeBloc>().add(UpdateRequestTypeEvent(
            requestType: requestType,
            updateType: UpdateType.updated,
          ));
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(widget.initialRequestType),
        title: Text(
          widget.isNewRequestType
              ? tr('masterData.dsr.request.create')
              : tr('masterData.dsr.request.edit'),
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
              child: _buildRequestTypeForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Visibility(
              visible: widget.initialRequestType != RequestTypeModel.empty(),
              child:
                  _buildConfigurationInfo(context, widget.initialRequestType),
            ),
          ],
        ),
      ),
    );
  }

  Form _buildRequestTypeForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('masterData.dsr.request.title'), //!
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.request.requestcode'), //!
            required: true,
          ),
          CustomTextField(
            controller: requestTypeCodeController,
            hintText: tr('masterData.dsr.request.requestcodeHint'), //!
            onChanged: _setRequestCode,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.request.description'), //!
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: tr('masterData.dsr.request.descriptionHint'), //!
            onChanged: _setDescription,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  CustomIconButton _buildPopButton(RequestTypeModel requestType) {
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
        if (requestType != widget.initialRequestType) {
          return CustomIconButton(
            onPressed: _saveRequestType,
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
    RequestTypeModel requestType,
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
            updatedBy: requestType.updatedBy,
            updatedDate: requestType.updatedDate,
            onDeletePressed: _deleteRequestType,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
