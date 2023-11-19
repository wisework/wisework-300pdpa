import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reject_template_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/edit_request_reject_tp/edit_request_reject_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reject_type/reject_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_reject_tp/request_reject_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_list_tile.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

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
              text: tr(
                  'consentManagement.consentForm.editConsentTheme.createSuccess'), //!
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
              text: tr(
                  'consentManagement.consentForm.editConsentTheme.updateSuccess'), //!
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
              text: tr(
                  'consentManagement.consentForm.editConsentTheme.deleteSuccess'), //!
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
              currentUser: currentUser,
              isNewRequestReject: widget.requestRejectId.isEmpty,
            );
          }
          if (state is UpdatedCurrentRequestRejectTp) {
            return EditRequestRejectTemplateView(
              initialRequestReject: state.requestRejectTp,
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
    required this.currentUser,
    required this.isNewRequestReject,
  });

  final RequestRejectTemplateModel initialRequestReject;
  final UserModel currentUser;
  final bool isNewRequestReject;

  @override
  State<EditRequestRejectTemplateView> createState() =>
      _EditRequestRejectTemplateViewState();
}

class _EditRequestRejectTemplateViewState
    extends State<EditRequestRejectTemplateView> {
  late RequestRejectTemplateModel requestReject;

  late String requestType;
  late List<RejectTypeModel> rejectTypes;

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

    rejectTypes = [];
    isActivated = true;

    if (requestReject != RequestRejectTemplateModel.empty()) {
      isActivated = requestReject.status == ActiveStatus.active;
    }
  }

  void _setRequestType(String? value) {
    setState(() {
      final requestType = value;

      requestReject = requestReject.copyWith(requestTypeId: requestType);
    });
  }

  void _setRejectTypeList(List<String>? value) {
    setState(() {
      final rejectTypesList = value;

      requestReject = requestReject.copyWith(rejectTypesId: rejectTypesList);
    });
  }

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
        requestReject = requestReject.setCreate(
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
        requestReject = requestReject.setUpdate(
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
        ),
        actions: [
          _buildSaveButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: UiConfig.lineSpacing),
              BlocBuilder<RequestTypeBloc, RequestTypeState>(
                builder: (context, state) {
                  if (state is GotRequestTypes) {
                    final requestName = state.requestTypes.where(
                        (id) => requestReject.requestTypeId.contains(id.id));

                    final requestNamefilter = requestName
                        .map((e) => e.description.first.text)
                        .toString();

                    return _buildRequestType(context, requestNamefilter, state);
                  }
                  if (state is RequestTypeError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              BlocBuilder<RejectTypeBloc, RejectTypeState>(
                builder: (context, state) {
                  if (state is GotRejectTypes) {
                    return CustomContainer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: UiConfig.lineSpacing),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr('masterData.dsr.requestrejects.rejecttype'),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: UiConfig.lineSpacing),
                          Visibility(
                            visible: requestReject.rejectTypesId.isNotEmpty,
                            child: _buildRejectTypeList(context, state),
                          ),
                          Visibility(
                            visible: requestReject.rejectTypesId.isEmpty,
                            child: _buildAddRejectBottomSheet(context, state),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is RejectTypeError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
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

  CustomContainer _buildRequestType(
      BuildContext context, String requestNamefilter, GotRequestTypes state) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tr('masterData.dsr.requestrejects.requesttype.create'),
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          MasterDataListTile(
            trail: true,
            title: requestNamefilter != '()'
                ? requestNamefilter
                : tr('masterData.dsr.requestrejects.chooserequesttype'),
            onTap: () async {
              //? Open ModalBottomSheet to add Purposes selected
              await showModalBottomSheet(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
                useSafeArea: true,
                isScrollControlled: true, //* required for min/max child size

                context: context,
                builder: (ctx) {
                  return CustomContainer(
                    child: Column(
                      children: [
                        const SizedBox(height: UiConfig.lineSpacing),
                        const Text('Request Types'), //!
                        const SizedBox(height: UiConfig.lineSpacing),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.requestTypes.length,
                          itemBuilder: (_, index) {
                            return Builder(builder: (context) {
                              final item = state.requestTypes[index];

                              if (state.requestTypes.isEmpty) {
                                return const Text('No Data'); //!
                              }
                              return MasterDataListTile(
                                trail: false,
                                title: state
                                    .requestTypes[index].description.first.text,
                                onTap: () {
                                  setState(
                                    () {
                                      // requestReject.requestTypeId =
                                      //     item.requestTypeId;
                                      _setRequestType(item.id);

                                      context.pop();
                                    },
                                  );
                                },
                              );
                            });
                          },
                        ),
                        const SizedBox(height: UiConfig.lineSpacing),
                        _buildNewRequestButton(context),
                        const SizedBox(height: UiConfig.lineSpacing),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Column _buildRejectTypeList(BuildContext context, GotRejectTypes state) {
    final rejectName = state.rejectTypes
        .where((id) => requestReject.rejectTypesId.contains(id.id))
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListView.separated(
          shrinkWrap: true,
          itemCount: rejectName.length,
          itemBuilder: (context, index) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  rejectName[index].description.first.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: UiConfig.textLineSpacing),
              CustomIconButton(
                onPressed: () {
                  //? Delete purpose from seleted
                  setState(() {
                    requestReject.rejectTypesId.remove(rejectName[index].id);
                    _setRejectTypeList(requestReject.rejectTypesId);
                  });
                },
                icon: Ionicons.close,
                iconColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
          separatorBuilder: (context, _) => Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        _buildAddRejectBottomSheet(context, state),
      ],
    );
  }

  MaterialInkWell _buildAddRejectBottomSheet(
      BuildContext context, GotRejectTypes state) {
    return MaterialInkWell(
      onTap: () async {
        //? Open ModalBottomSheet to add Purposes selected
        await showModalBottomSheet(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          useSafeArea: true,
          isScrollControlled: true, //* required for min/max child size
          context: context,
          builder: (ctx) {
            return SingleChildScrollView(
              child: CustomContainer(
                child: Column(
                  children: [
                    const SizedBox(height: UiConfig.lineSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Reject Types'), //!
                        CustomIconButton(
                          icon: Ionicons.close,
                          onPressed: () {
                            context.pop();
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: UiConfig.lineSpacing),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.rejectTypes.length,
                      itemBuilder: (_, index) {
                        return Builder(builder: (context) {
                          final item = state.rejectTypes[index];

                          if (state.rejectTypes.isEmpty) {
                            return const Text('No Data'); //!
                          }
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(state
                                .rejectTypes[index].description.first.text),
                            value: false,
                            onChanged: (newValue) {
                              setState(() {
                                if (newValue!) {
                                  requestReject.rejectTypesId.add(item.id);
                                  _setRejectTypeList(
                                      requestReject.rejectTypesId);
                                } else {
                                  requestReject.rejectTypesId.remove(item.id);
                                  _setRejectTypeList(
                                      requestReject.rejectTypesId);
                                }
                              });
                            },
                          );
                        });
                      },
                    ),
                    const SizedBox(height: UiConfig.lineSpacing),
                    _buildNewRequestButton(context),
                    const SizedBox(height: UiConfig.lineSpacing),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                tr('masterData.dsr.requestrejects.addReject'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  MaterialInkWell _buildNewRequestButton(BuildContext context) {
    return MaterialInkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                'New Request Type',
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
