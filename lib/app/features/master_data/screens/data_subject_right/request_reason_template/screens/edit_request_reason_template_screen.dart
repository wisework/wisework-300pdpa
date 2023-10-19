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
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/edit_request_reason_tp/edit_request_reason_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reason_type/reason_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_reason_tp/request_reason_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
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
            return EditRequestReasonTemplateView(
              initialRequestReason: state.requestReasonTp,
              currentUser: currentUser,
              isNewRequestReason: widget.requestReasonId.isEmpty,
            );
          }
          if (state is UpdatedCurrentRequestReasonTp) {
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

  late List<RequestTypeModel> requestTypeList;
  late List<ReasonTypeModel> reasonTypeList;
  // late List<RequestTypeModel> purposeList;

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

    requestTypeList = [];
    reasonTypeList = [];
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
      final reasonTypeList = value;
      print(value);
      requestReason = requestReason.copyWith(reasonTypesId: reasonTypeList);
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
              CustomContainer(
                child: _buildRequestReasonForm(context),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              const SizedBox(height: UiConfig.lineSpacing),
              CustomContainer(
                child: _buildChooseReasonsForm(context),
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

  Column _buildRequestReasonForm(BuildContext context) {
    return (Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              tr('masterData.dsr.requestreasons.requesttype.create'),
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 500,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Modal BottomSheet'),
                          ElevatedButton(
                            child: const Text('Close BottomSheet'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tr('masterData.dsr.requestreasons.chooserequesttype.create'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

  Column _buildChooseReasonsForm(BuildContext context) {
    return (Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              tr('masterData.dsr.requestreasons.reasontype'),
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Text(
          'เพิ่มตัวเลือกการปฏิเสธที่อนุญาตในประเภทคำร้องนี้',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 500,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Modal BottomSheet'),
                          ElevatedButton(
                            child: const Text('Close BottomSheet'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tr('masterData.dsr.requestreasons.choosereasontype'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        )
      ],
    ));
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
