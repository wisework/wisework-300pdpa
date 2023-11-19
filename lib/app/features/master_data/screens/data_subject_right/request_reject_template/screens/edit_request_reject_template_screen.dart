import 'package:bot_toast/bot_toast.dart';
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
import 'package:pdpa/app/data/models/master_data/request_reject_template_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/edit_request_reject_tp/edit_request_reject_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reject_type/reject_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_reject_tp/request_reject_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/request_reject_template/widgets/choose_reject_modal.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditRequestRejectTemplateScreen extends StatefulWidget {
  const EditRequestRejectTemplateScreen({
    super.key,
    required this.requestRejectId,
  });

  final String requestRejectId;

  @override
  State<EditRequestRejectTemplateScreen> createState() =>
      _EditRequestRejectTemplateScreenState();
}

class _EditRequestRejectTemplateScreenState
    extends State<EditRequestRejectTemplateScreen> {
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

    context
        .read<RequestTypeBloc>()
        .add(GetRequestTypeEvent(companyId: companyId));
    context
        .read<RejectTypeBloc>()
        .add(GetRejectTypeEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditRequestRejectTpBloc>(
      create: (context) => serviceLocator<EditRequestRejectTpBloc>()
        ..add(
          GetCurrentRequestRejectTpEvent(
            requestRejectTpId: widget.requestRejectId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditRequestRejectTpBloc, EditRequestRejectTpState>(
        listener: (context, state) {
          if (state is CreatedCurrentRequestRejectTp) {
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

            context.read<RequestRejectTpBloc>().add(UpdateRequestRejectTpEvent(
                requestReject: state.requestRejectTp,
                updateType: UpdateType.created));

            context.pop();
          }

          if (state is UpdatedCurrentRequestRejectTp) {
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

          if (state is DeletedCurrentRequestRejectTp) {
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

            final deleted = RequestRejectTemplateModel.empty()
                .copyWith(id: state.requestRejectTpId);

            context.read<RequestRejectTpBloc>().add(UpdateRequestRejectTpEvent(
                requestReject: deleted, updateType: UpdateType.deleted));

            context.pop();
          }
        },
        builder: (context, state) {
          if (state is GotCurrentRequestRejectTp) {
            return EditRequestRejectTemplateView(
              initialRequestReject: state.requestRejectTp,
              rejects: state.rejects,
              currentUser: currentUser,
              isNewRequestReject: widget.requestRejectId.isEmpty,
            );
          }
          if (state is UpdatedCurrentRequestRejectTp) {
            return EditRequestRejectTemplateView(
              initialRequestReject: state.requestRejectTp,
              rejects: state.rejects,
              currentUser: currentUser,
              isNewRequestReject: widget.requestRejectId.isEmpty,
            );
          }
          if (state is EditRequestRejectTpError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditRequestRejectTemplateView extends StatefulWidget {
  const EditRequestRejectTemplateView({
    super.key,
    required this.initialRequestReject,
    required this.rejects,
    required this.currentUser,
    required this.isNewRequestReject,
  });

  final RequestRejectTemplateModel initialRequestReject;
  final List<RejectTypeModel> rejects;
  final UserModel currentUser;
  final bool isNewRequestReject;
  @override
  State<EditRequestRejectTemplateView> createState() =>
      _EditRequestRejectTemplateViewState();
}

class _EditRequestRejectTemplateViewState
    extends State<EditRequestRejectTemplateView> {
  late RequestRejectTemplateModel requestReject;

  late List<RequestTypeModel> requestTypeList;
  late List<RejectTypeModel> rejectTypeList;

  late bool isActivated;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initialData() {
    requestReject = widget.initialRequestReject;

    requestTypeList = [];
    rejectTypeList = [];
    isActivated = true;

    if (requestReject != RequestRejectTemplateModel.empty()) {
      isActivated = requestReject.status == ActiveStatus.active;
    }
  }

  // void _setRequestType(String? value) {
  //   setState(() {
  //     final requestType = value;
  //     requestReject = requestReject.copyWith(requestTypeId: requestType);
  //   });
  // }

  // void _setRejectTypeList(List<String>? value) {
  //   setState(() {
  //     final rejectTypeList = value;
  //     requestReject = requestReject.copyWith(rejectTypesId: rejectTypeList);
  //   });
  // }

  void _setActiveStatus(bool value) {
    setState(() {
      isActivated = value;

      final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

      requestReject = requestReject.copyWith(status: status);
    });
  }

  void _saveRequestReject() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewRequestReject) {
        requestReject = requestReject.toCreated(
          widget.currentUser.email,
          DateTime.now(),
        );

        context
            .read<EditRequestRejectTpBloc>()
            .add(CreateCurrentRequestRejectTpEvent(
              requestRejectTp: requestReject,
              companyId: widget.currentUser.currentCompany,
            ));
      } else {
        requestReject = requestReject.toUpdated(
          widget.currentUser.email,
          DateTime.now(),
        );
        context
            .read<EditRequestRejectTpBloc>()
            .add(UpdateCurrentRequestRejectTpEvent(
              requestRejectTp: requestReject,
              companyId: widget.currentUser.currentCompany,
            ));
      }
    }
  }

  void _deleteRequestReject() {
    context
        .read<EditRequestRejectTpBloc>()
        .add(DeleteCurrentRequestRejectTpEvent(
          requestRejectTpId: requestReject.id,
          companyId: widget.currentUser.currentCompany,
        ));
  }

  void _goBackAndUpdate() {
    if (!widget.isNewRequestReject) {
      context.read<RequestRejectTpBloc>().add(UpdateRequestRejectTpEvent(
            requestReject: requestReject,
            updateType: UpdateType.updated,
          ));
    }

    context.pop();
  }

  void _updateEditRequestRejectTemplateState(
      UpdatedReturn<RejectTypeModel> updated) {
    final event = UpdateEditRequestRejectTpStateEvent(reject: updated.object);
    context.read<EditRequestRejectTpBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(widget.initialRequestReject),
        title: Text(
          widget.isNewRequestReject
              ? tr('masterData.dsr.requestrejects.create')
              : tr('masterData.dsr.requestrejects.edit'),
          style: Theme.of(context).textTheme.titleLarge,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
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
                child: _buildRequestRejectForm(context),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Visibility(
                visible: widget.initialRequestReject !=
                    RequestRejectTemplateModel.empty(),
                child: _buildConfigurationInfo(
                    context, widget.initialRequestReject),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form _buildRequestRejectForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('masterData.cm.purposeCategory.list'), //!
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purposeCategory.description'), //!
          ),
          CustomButton(
            height: 50.0,
            onPressed: () {
              // ? Request Modal
              // showBarModalBottomSheet(
              //   context: context,
              //   backgroundColor: Colors.transparent,
              //   builder: (context) => ChooseRequestModal(
              //     initialRequests: requestReject.requestTypeId,
              //     request: widget.request,
              //     onChanged: (rejects) {
              //       setState(() {
              //         requestReject = requestReject.copyWith(
              //           rejectTypes: rejects,
              //         );
              //       });
              //     },
              //     onUpdated: _updateEditRequestRejectTemplateState,
              //     language: widget.currentUser.defaultLanguage,
              //   ),
              // );
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
                  const SizedBox(width: UiConfig.actionSpacing + 11),
                  Expanded(
                    child: Text(
                      requestReject.requestTypeId,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purposeCategory.purposes'), //!
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          _buildRejectSection(context,
              requestReject.rejectTypes.map((reject) => reject.id).toList()),
        ],
      ),
    );
  }

  Column _buildRejectSection(BuildContext context, List<String> rejectIds) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: requestReject.rejectTypes.length,
            itemBuilder: (context, index) => Column(
              children: <Widget>[
                _buildRejectTile(
                  context,
                  reject: requestReject.rejectTypes[index],
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
            ) !=
            ''
        ? reject.description.last.text
        : '';

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            description,
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
              final rejects = requestReject.rejectTypes
                  .where((reject) => reject.id != removeId)
                  .toList();

              setState(() {
                requestReject = requestReject.copyWith(
                  rejectTypes: rejects,
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
          builder: (context) => ChooseRejectModal(
            initialRejects: requestReject.rejectTypes,
            rejects: widget.rejects,
            onChanged: (rejects) {
              setState(() {
                requestReject = requestReject.copyWith(
                  rejectTypes: rejects,
                );
              });
            },
            onUpdated: _updateEditRequestRejectTemplateState,
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
                tr('masterData.cm.purposeCategory.addPurpose'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton(RequestRejectTemplateModel requestRejectTp) {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Builder _buildSaveButton() {
    return Builder(builder: (context) {
      if (requestReject != widget.initialRequestReject) {
        return CustomIconButton(
          onPressed: _saveRequestReject,
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

  Column _buildConfigurationInfo(
    BuildContext context,
    RequestRejectTemplateModel requestRejectTp,
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
            updatedBy: requestRejectTp.updatedBy,
            updatedDate: requestRejectTp.updatedDate,
            onDeletePressed: _deleteRequestReject,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
