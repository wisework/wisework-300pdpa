import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/edit_request_type/edit_request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/request_type/widgets/choose_reject_modal.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
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

    String companyId = '';
    if (bloc.state is SignedInUser) {
      companyId = (bloc.state as SignedInUser).user.currentCompany;
    }

    final event = GetRequestTypesEvent(companyId: companyId);
    context.read<RequestTypeBloc>().add(event);
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
            showToast(
              context,
              text: tr('masterData.cm.purposeCategory.createSuccess'),
            );

            context.pop(
              UpdatedReturn<RequestTypeModel>(
                object: state.requestType,
                type: UpdateType.created,
              ),
            );
          }

          if (state is UpdatedCurrentRequestType) {
            showToast(
              context,
              text: tr('masterData.cm.purposeCategory.updateSuccess'),
            );
          }

          if (state is DeletedCurrentRequestType) {
            showToast(
              context,
              text: tr('masterData.cm.purposeCategory.deleteSuccess'),
            );

            final deleted =
                RequestTypeModel.empty().copyWith(id: state.requestTypeId);

            context.pop(
              UpdatedReturn<RequestTypeModel>(
                object: deleted,
                type: UpdateType.deleted,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GotCurrentRequestType) {
            return EditRequestTypeView(
              initialRequestType: state.requestType,
              rejectTypes: state.rejectTypes,
              currentUser: currentUser,
              isNewRequestType: widget.requestTypeId.isEmpty,
            );
          }
          if (state is UpdatedCurrentRequestType) {
            return EditRequestTypeView(
              initialRequestType: state.requestType,
              rejectTypes: state.rejectTypes,
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
    required this.rejectTypes,
    required this.currentUser,
    required this.isNewRequestType,
  });

  final RequestTypeModel initialRequestType;
  final List<RejectTypeModel> rejectTypes;
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
    const language = 'th-TH';

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
        final description = requestType.description
            .firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            )
            .text;

        descriptionController = TextEditingController(
          text: description,
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
            language: 'th-TH',
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
        requestType = requestType.setCreate(
          widget.currentUser.email,
          DateTime.now(),
        );
        final event = CreateCurrentRequestTypeEvent(
          requestType: requestType,
          companyId: widget.currentUser.currentCompany,
        );
        context.read<EditRequestTypeBloc>().add(event);
      } else {
        requestType = requestType.setUpdate(
          widget.currentUser.email,
          DateTime.now(),
        );

        final event = UpdateCurrentRequestTypeEvent(
          requestType: requestType,
          companyId: widget.currentUser.currentCompany,
        );
        context.read<EditRequestTypeBloc>().add(event);
      }
    }
  }

  void _deleteRequestType() {
    final event = DeleteCurrentRequestTypeEvent(
      requestTypeId: requestType.id,
      companyId: widget.currentUser.currentCompany,
    );
    context.read<EditRequestTypeBloc>().add(event);
  }

  void _goBackAndUpdate() {
    if (!widget.isNewRequestType) {
      context.pop(
        UpdatedReturn<RequestTypeModel>(
          object: widget.initialRequestType,
          type: UpdateType.updated,
        ),
      );
    } else {
      context.pop();
    }
  }

  void _updateEditRequestTypeState(UpdatedReturn<RejectTypeModel> updated) {
    final event = UpdateEditRequestTypeStateEvent(reject: updated.object);
    context.read<EditRequestTypeBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(widget.initialRequestType),
        title: Expanded(
          child: Text(
            widget.isNewRequestType
                ? tr('masterData.dsr.request.create')
                : tr('masterData.dsr.request.edit'),
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        actions: [
          _buildSaveButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: ContentWrapper(
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
                child: _buildConfigurationInfo(
                  context,
                  widget.initialRequestType,
                ),
              ),
            ],
          ),
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
                tr('masterData.dsr.request.title'), 
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.request.requestcode'), 
            required: true,
          ),
          CustomTextField(
            controller: requestTypeCodeController,
            hintText: tr('masterData.dsr.request.requestcodeHint'), 
            onChanged: _setRequestCode,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.request.description'), 
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: tr('masterData.dsr.request.descriptionHint'), 
            onChanged: _setDescription,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.dsr.request.rejectType'), 
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          _buildRejectTypesection(context,
              requestType.rejectTypes.map((reject) => reject.id).toList()),
        ],
      ),
    );
  }

  Column _buildRejectTypesection(BuildContext context, List<String> rejectIds) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: requestType.rejectTypes.length,
            itemBuilder: (context, index) => Column(
              children: <Widget>[
                _buildRejectTile(
                  context,
                  reject: requestType.rejectTypes[index],
                  language: widget.currentUser.defaultLanguage,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildAddRejectButton(context),
      ],
    );
  }

  Row _buildRejectTile(
    BuildContext context, {
    required RejectTypeModel reject,
    required String language,
  }) {
    final description = reject.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            description.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: UiConfig.actionSpacing * 2,
          ),
          child: CustomIconButton(
            onPressed: () {
              final removeId = reject.id;
              final rejectTypes = requestType.rejectTypes
                  .where((reject) => reject.id != removeId)
                  .toList();

              setState(() {
                requestType = requestType.copyWith(
                  rejectTypes: rejectTypes,
                );
              });
            },
            icon: Ionicons.close,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildAddRejectButton(BuildContext context) {
    return CustomButton(
      height: 50.0,
      onPressed: () {
        showBarModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => ChooseRejectTypeModal(
            initialRejectTypes: requestType.rejectTypes,
            rejectTypes: widget.rejectTypes,
            onChanged: (rejectTypes) {
              setState(() {
                requestType = requestType.copyWith(
                  rejectTypes: rejectTypes,
                );
              });
            },
            onUpdated: _updateEditRequestTypeState,
            language: widget.currentUser.defaultLanguage,
          ),
        );
      },
      buttonType: CustomButtonType.outlined,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      borderColor: Theme.of(context).colorScheme.outlineVariant,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConfig.defaultPaddingSpacing,
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Icon(
                Ionicons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: UiConfig.actionSpacing + 11),
            Expanded(
              child: Text(
                tr('masterData.dsr.request.addRejectType'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
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
