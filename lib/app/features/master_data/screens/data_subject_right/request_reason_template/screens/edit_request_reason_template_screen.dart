import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/edit_request_reason_tp/edit_request_reason_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reason_type/reason_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_reason_tp/request_reason_tp_bloc.dart';
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

            context.read<RequestReasonTpBloc>().add(UpdateRequestReasonTpEvent(
                requestReason: state.requestReasonTp,
                updateType: UpdateType.created));

            context.pop();
          }

          if (state is UpdatedCurrentRequestReasonTp) {
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

          if (state is DeletedCurrentRequestReasonTp) {
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

            final deleted = RequestReasonTemplateModel.empty()
                .copyWith(requestReasonTemplateId: state.requestReasonTpId);

            context.read<RequestReasonTpBloc>().add(UpdateRequestReasonTpEvent(
                requestReason: deleted, updateType: UpdateType.deleted));

            context.pop();
          }
        },
        builder: (context, state) {
          if (state is GotCurrentRequestReasonTp) {
            print('Got');
            return EditRequestReasonTemplateView(
              initialRequestReason: state.requestReasonTp,
              currentUser: currentUser,
              isNewRequestReason: widget.requestReasonId.isEmpty,
            );
          }
          if (state is UpdatedCurrentRequestReasonTp) {
            print('Update');
            return EditRequestReasonTemplateView(
              initialRequestReason: state.requestReasonTp,
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
    required this.currentUser,
    required this.isNewRequestReason,
  });

  final RequestReasonTemplateModel initialRequestReason;
  final UserModel currentUser;
  final bool isNewRequestReason;

  @override
  State<EditRequestReasonTemplateView> createState() =>
      _EditRequestReasonTemplateViewState();
}

class _EditRequestReasonTemplateViewState
    extends State<EditRequestReasonTemplateView> {
  late RequestReasonTemplateModel requestReason;

  late String requestType;
  late List<ReasonTypeModel> reasonTypes;

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

    reasonTypes = [];
    isActivated = true;

    if (requestReason != RequestReasonTemplateModel.empty()) {
      isActivated = requestReason.status == ActiveStatus.active;
    }
  }

  void _setRequestType(String? value) {
    setState(() {
      final requestType = value;
      print(value);
      requestReason = requestReason.copyWith(requestTypeId: requestType);
    });
  }

  void _setReasonTypeList(List<String>? value) {
    setState(() {
      final reasonTypesList = value;
      print(value);
      requestReason = requestReason.copyWith(reasonTypesId: reasonTypesList);
    });
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
      print('pass1');
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
        print('pass2');
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
          requestReasonTpId: requestReason.requestReasonTemplateId,
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
                    final requestName = state.requestTypes.where((id) =>
                        requestReason.requestTypeId.contains(id.requestTypeId));

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
              BlocBuilder<ReasonTypeBloc, ReasonTypeState>(
                builder: (context, state) {
                  if (state is GotReasonTypes) {
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
                                tr('masterData.dsr.requestreasons.reasontype'),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: UiConfig.lineSpacing),
                          Visibility(
                            visible: requestReason.reasonTypesId.isNotEmpty,
                            child: _buildReasonTypeList(context, state),
                          ),
                          Visibility(
                            visible: requestReason.reasonTypesId.isEmpty,
                            child: _buildAddReasonBottomSheet(context, state),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ReasonTypeError) {
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
                visible: widget.initialRequestReason !=
                    RequestReasonTemplateModel.empty(),
                child: _buildConfigurationInfo(
                    context, widget.initialRequestReason),
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
                tr('masterData.dsr.requestreasons.requesttype.create'),
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          MasterDataListTile(
            trail: true,
            title: requestNamefilter != '()'
                ? requestNamefilter
                : tr('masterData.dsr.requestreasons.chooserequesttype'),
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
                        const Text('Request Types'),
                        const SizedBox(height: UiConfig.lineSpacing),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.requestTypes.length,
                          itemBuilder: (_, index) {
                            return Builder(builder: (context) {
                              final item = state.requestTypes[index];

                              if (state.requestTypes.isEmpty) {
                                return const Text('No Data');
                              }
                              return MasterDataListTile(
                                trail: false,
                                title: state
                                    .requestTypes[index].description.first.text,
                                onTap: () {
                                  setState(
                                    () {
                                      // requestReason.requestTypeId =
                                      //     item.requestTypeId;
                                      _setRequestType(item.requestTypeId);

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

  Column _buildReasonTypeList(BuildContext context, GotReasonTypes state) {
    final reasonName = state.reasonTypes
        .where((id) => requestReason.reasonTypesId.contains(id.reasonTypeId))
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListView.separated(
          shrinkWrap: true,
          itemCount: reasonName.length,
          itemBuilder: (context, index) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  reasonName[index].description.first.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: UiConfig.textLineSpacing),
              CustomIconButton(
                onPressed: () {
                  //? Delete purpose from seleted
                  setState(() {
                    requestReason.reasonTypesId
                        .remove(reasonName[index].reasonTypeId);
                    _setReasonTypeList(requestReason.reasonTypesId);
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
        _buildAddReasonBottomSheet(context, state),
      ],
    );
  }

  MaterialInkWell _buildAddReasonBottomSheet(
      BuildContext context, GotReasonTypes state) {
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
                        const Text('Reason Types'),
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
                      itemCount: state.reasonTypes.length,
                      itemBuilder: (_, index) {
                        return Builder(builder: (context) {
                          final item = state.reasonTypes[index];

                          if (state.reasonTypes.isEmpty) {
                            return const Text('No Data');
                          }
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(state
                                .reasonTypes[index].description.first.text),
                            value: false,
                            onChanged: (newValue) {
                              setState(() {
                                if (newValue!) {
                                  requestReason.reasonTypesId
                                      .add(item.reasonTypeId);
                                  _setReasonTypeList(
                                      requestReason.reasonTypesId);
                                } else {
                                  requestReason.reasonTypesId
                                      .remove(item.reasonTypeId);
                                  _setReasonTypeList(
                                      requestReason.reasonTypesId);
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
                'Add Reason',
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

  CustomIconButton _buildPopButton(RequestReasonTemplateModel requestReasonTp) {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Ionicons.chevron_back_outline,
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
        iconColor: Theme.of(context).colorScheme.outlineVariant,
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
                  tr('masterData.etc.active'),
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
