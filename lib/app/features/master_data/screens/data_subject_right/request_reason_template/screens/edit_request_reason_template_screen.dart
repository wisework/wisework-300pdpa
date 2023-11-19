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
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/edit_request_reason_tp/edit_request_reason_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reason_type/reason_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_reason_tp/request_reason_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/request_reason_template/widgets/choose_reason_modal.dart';
import 'package:pdpa/app/features/master_data/widgets/choose_request_modal.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditRequestReasonTemplateScreen extends StatefulWidget {
  const EditRequestReasonTemplateScreen({
    super.key,
    required this.requestReasonId,
  });

  final String requestReasonId;

  @override
  State<EditRequestReasonTemplateScreen> createState() =>
      _EditRequestReasonTemplateScreenState();
}

class _EditRequestReasonTemplateScreenState
    extends State<EditRequestReasonTemplateScreen> {
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
        .read<ReasonTypeBloc>()
        .add(GetReasonTypeEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditRequestReasonTpBloc>(
      create: (context) => serviceLocator<EditRequestReasonTpBloc>()
        ..add(
          GetCurrentRequestReasonTpEvent(
            requestReasonTpId: widget.requestReasonId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditRequestReasonTpBloc, EditRequestReasonTpState>(
        listener: (context, state) {
          if (state is CreatedCurrentRequestReasonTp) {
            showToast(context,
                text: tr(
                    'consentManagement.consentForm.editConsentTheme.createSuccess'));

            context.pop(
              UpdatedReturn<RequestReasonTemplateModel>(
                object: state.requestReasonTp,
                type: UpdateType.created,
              ),
            );
          }

          if (state is UpdatedCurrentRequestReasonTp) {
            showToast(
              context,
              text: tr(
                  'consentManagement.consentForm.editConsentTheme.updateSuccess'),
            );
          }

          if (state is DeletedCurrentRequestReasonTp) {
            showToast(
              context,
              text: tr(
                  'consentManagement.consentForm.editConsentTheme.deleteSuccess'),
            );

            final deleted = RequestReasonTemplateModel.empty()
                .copyWith(id: state.requestReasonTpId);

            context.read<RequestReasonTpBloc>().add(UpdateRequestReasonTpEvent(
                requestReason: deleted, updateType: UpdateType.deleted));

            context.pop(
              UpdatedReturn<RequestReasonTemplateModel>(
                object: deleted,
                type: UpdateType.created,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GotCurrentRequestReasonTp) {
            return EditRequestReasonTemplateView(
              initialRequestReason: state.requestReasonTp,
              reasons: state.reasons,
              requestId: state.requestReasonTp.requestTypeId,
              currentUser: currentUser,
              isNewRequestReason: widget.requestReasonId.isEmpty,
            );
          }
          if (state is UpdatedCurrentRequestReasonTp) {
            return EditRequestReasonTemplateView(
              initialRequestReason: state.requestReasonTp,
              reasons: state.reasons,
              requestId: state.requestReasonTp.requestTypeId,
              currentUser: currentUser,
              isNewRequestReason: widget.requestReasonId.isEmpty,
            );
          }
          if (state is EditRequestReasonTpError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditRequestReasonTemplateView extends StatefulWidget {
  const EditRequestReasonTemplateView({
    super.key,
    required this.initialRequestReason,
    required this.reasons,
    required this.requestId,
    required this.currentUser,
    required this.isNewRequestReason,
  });

  final RequestReasonTemplateModel initialRequestReason;
  final List<ReasonTypeModel> reasons;
  final String requestId;
  final UserModel currentUser;
  final bool isNewRequestReason;

  @override
  State<EditRequestReasonTemplateView> createState() =>
      _EditRequestReasonTemplateViewState();
}

class _EditRequestReasonTemplateViewState
    extends State<EditRequestReasonTemplateView> {
  late RequestReasonTemplateModel requestReason;

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
    requestReason = widget.initialRequestReason;

    isActivated = true;

    if (requestReason != RequestReasonTemplateModel.empty()) {
      isActivated = requestReason.status == ActiveStatus.active;
    }
  }

  void _setActiveStatus(bool value) {
    setState(() {
      isActivated = value;

      final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

      requestReason = requestReason.copyWith(status: status);
    });
  }

  void _saveRequestReason() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewRequestReason) {
        requestReason = requestReason.setCreate(
          widget.currentUser.email,
          DateTime.now(),
        );

        context
            .read<EditRequestReasonTpBloc>()
            .add(CreateCurrentRequestReasonTpEvent(
              requestReasonTp: requestReason,
              companyId: widget.currentUser.currentCompany,
            ));
      } else {
        requestReason = requestReason.setUpdate(
          widget.currentUser.email,
          DateTime.now(),
        );

        context
            .read<EditRequestReasonTpBloc>()
            .add(UpdateCurrentRequestReasonTpEvent(
              requestReasonTp: requestReason,
              companyId: widget.currentUser.currentCompany,
            ));
      }
    }
  }

  void _deleteRequestReason() {
    context
        .read<EditRequestReasonTpBloc>()
        .add(DeleteCurrentRequestReasonTpEvent(
          requestReasonTpId: requestReason.id,
          companyId: widget.currentUser.currentCompany,
        ));
  }

  void _goBackAndUpdate() {
    if (!widget.isNewRequestReason) {
      context.read<RequestReasonTpBloc>().add(UpdateRequestReasonTpEvent(
            requestReason: requestReason,
            updateType: UpdateType.updated,
          ));
    }

    context.pop();
  }

  void _updateEditRequestReasonTemplateState(
      UpdatedReturn<ReasonTypeModel> updated) {
    final event = UpdateEditRequestReasonTpStateEvent(reason: updated.object);
    context.read<EditRequestReasonTpBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(widget.initialRequestReason),
        title: Text(
          widget.isNewRequestReason
              ? tr('masterData.dsr.requestreasons.create')
              : tr('masterData.dsr.requestreasons.edit'),
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
                child: _buildRequestReasonForm(context),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Visibility(
                visible: widget.initialRequestReason !=
                    RequestReasonTemplateModel.empty(),
                child: _buildConfigurationInfo(
                  context,
                  widget.initialRequestReason,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form _buildRequestReasonForm(BuildContext context) {
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
              //     initialRequests: requestReason.requestTypeId,
              //     request: widget.request,
              //     onChanged: (reasons) {
              //       setState(() {
              //         requestReason = requestReason.copyWith(
              //           reasonTypes: reasons,
              //         );
              //       });
              //     },
              //     onUpdated: _updateEditRequestReasonTemplateState,
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
                      requestReason.requestTypeId,
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
          _buildReasonSection(context,
              requestReason.reasonTypes.map((reason) => reason.id).toList()),
        ],
      ),
    );
  }

  Column _buildReasonSection(BuildContext context, List<String> reasonIds) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: requestReason.reasonTypes.length,
            itemBuilder: (context, index) => Column(
              children: <Widget>[
                _buildReasonTile(
                  context,
                  reason: requestReason.reasonTypes[index],
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
        _buildAddReasonButton(context),
      ],
    );
  }

  Row _buildReasonTile(
    BuildContext context, {
    required ReasonTypeModel reason,
    required String language,
  }) {
    final description = reason.description.firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            ) !=
            ''
        ? reason.description.last.text
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
              final removeId = reason.id;
              final reasons = requestReason.reasonTypes
                  .where((reason) => reason.id != removeId)
                  .toList();

              setState(() {
                requestReason = requestReason.copyWith(
                  reasonTypes: reasons,
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

  Widget _buildAddReasonButton(BuildContext context) {
    return CustomButton(
      height: 50.0,
      onPressed: () {
        showBarModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => ChooseReasonModal(
            initialReasons: requestReason.reasonTypes,
            reasons: widget.reasons,
            onChanged: (reasons) {
              setState(() {
                requestReason = requestReason.copyWith(
                  reasonTypes: reasons,
                );
              });
            },
            onUpdated: _updateEditRequestReasonTemplateState,
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

  CustomIconButton _buildPopButton(RequestReasonTemplateModel requestReasonTp) {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Builder _buildSaveButton() {
    return Builder(builder: (context) {
      if (requestReason != widget.initialRequestReason) {
        return CustomIconButton(
          onPressed: _saveRequestReason,
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
    RequestReasonTemplateModel requestReasonTp,
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
            updatedBy: requestReasonTp.updatedBy,
            updatedDate: requestReasonTp.updatedDate,
            onDeletePressed: _deleteRequestReason,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
