import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/email_js/process_request_params.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/request_type/widgets/choose_reject_modal.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class ProcessConsiderRequest extends StatefulWidget {
  const ProcessConsiderRequest({
    super.key,
    required this.processRequest,
    required this.initialProcessRequest,
    required this.requestTypes,
    required this.currentUser,
  });

  final ProcessRequestModel processRequest;
  final ProcessRequestModel initialProcessRequest;
  final List<RequestTypeModel> requestTypes;
  final UserModel currentUser;

  @override
  State<ProcessConsiderRequest> createState() => _ProcessConsiderRequestState();
}

class _ProcessConsiderRequestState extends State<ProcessConsiderRequest> {
  final GlobalKey<FormState> _considerFormKey = GlobalKey<FormState>();

  void _onOptionChanged(RequestResultStatus value, String id) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setConsiderOption(value, id);
  }

  void _setRejectTypes(List<String> value) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setProcessRejectTypes(value, widget.processRequest.id);
  }

  void _addRejectType(UpdatedReturn<RejectTypeModel> updated) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.addRejectType([updated.object]);
  }

  void _removeRejectType(String value) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.removeProcessRejectType(value, widget.processRequest.id);
  }

  void _onRejectReasonChanged(String value) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setRejectConsiderReason(value, widget.processRequest.id);
  }

  void _onEmailSelected(String email) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.selectNotifyEmail(email, widget.processRequest.id);
  }

  void _sendEmails() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();

    final emailParams = _getEmailParams();
    final fromName = '${cubit.state.currentUser.firstName}'
        '${cubit.state.currentUser.lastName.isNotEmpty ? cubit.state.currentUser.lastName : ''}';

    cubit.sendRequestEmails(
      widget.processRequest.id,
      widget.processRequest.notifyEmail,
      emailParams: emailParams?.copyWith(
        toName: '',
        toEmail: '',
        fromName: fromName,
        fromEmail: cubit.state.currentUser.email,
      ),
    );
  }

  void _onSubmitPressed() {
    //? If consider request status of initial process request not none,
    //? exist function.
    if (widget.initialProcessRequest.considerRequestStatus !=
        RequestResultStatus.none) {
      return;
    }

    final cubit = context.read<ProcessDataSubjectRightCubit>();

    if (widget.processRequest.considerRequestStatus ==
        RequestResultStatus.fail) {
      if (widget.processRequest.rejectTypes.isEmpty) {
        cubit.setRejectTypeError(true);
        return;
      }
      if (!_considerFormKey.currentState!.validate()) return;
    }

    final emailParams = _getEmailParams();

    cubit.submitConsiderRequest(
      widget.processRequest.id,
      toRequesterParams: emailParams,
    );
  }

  ProcessRequestTemplateParams? _getEmailParams() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    final dataSubjectRight = cubit.state.dataSubjectRight;

    final emptyRequest = ProcessRequestModel.empty();
    final processRequest = dataSubjectRight.processRequests.firstWhere(
      (request) => request.id == cubit.state.processRequestSelected,
      orElse: () => emptyRequest,
    );

    if (processRequest != emptyRequest) {
      final Map<ProcessRequestStatus, String> statusTexts = {
        ProcessRequestStatus.notProcessed:
            tr('dataSubjectRight.processCondider.notYetProcessed'),
        ProcessRequestStatus.inProgress:
            tr('dataSubjectRight.processCondider.inProgress'),
        ProcessRequestStatus.refused:
            tr('dataSubjectRight.processCondider.refuseProcessing'),
        ProcessRequestStatus.completed:
            tr('dataSubjectRight.processCondider.completed'),
      };

      final status = UtilFunctions.getProcessRequestStatus(
        dataSubjectRight,
        processRequest,
      );
      final requestType = UtilFunctions.getRequestTypeById(
        widget.requestTypes,
        processRequest.requestType,
      );
      final description = requestType.description.firstWhere(
        (item) => item.language == widget.currentUser.defaultLanguage,
        orElse: () => const LocalizedModel.empty(),
      );

      final rejectReason = processRequest.considerRequestStatus ==
              RequestResultStatus.fail
          ? '\n${tr('dataSubjectRight.processCondiDDder.completed')} ${processRequest.rejectConsiderReason}'
          : '';

      return ProcessRequestTemplateParams(
        toName: dataSubjectRight.dataRequester[0].text,
        toEmail: dataSubjectRight.dataRequester[2].text,
        id: dataSubjectRight.id,
        processRequest: description.text,
        processStatus: '${statusTexts[status]}$rejectReason',
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BlocBuilder<ProcessDataSubjectRightCubit, ProcessDataSubjectRightState>(
          builder: (context, state) {
            return Visibility(
              visible: state.userEmails.isNotEmpty,
              child: CustomContainer(
                margin: const EdgeInsets.only(
                  bottom: UiConfig.lineSpacing,
                ),
                color: Theme.of(context).colorScheme.background,
                child: _buildEmailNotification(
                  context,
                  userEmails: state.userEmails,
                  emailSelected: widget.processRequest.notifyEmail,
                  readOnly: widget.processRequest.notifyEmail ==
                              widget.initialProcessRequest.notifyEmail &&
                          widget.initialProcessRequest.notifyEmail.isNotEmpty ||
                      widget.initialProcessRequest.considerRequestStatus !=
                          RequestResultStatus.none,
                  isLoading: state.loadingStatus.sendingEmail,
                ),
              ),
            );
          },
        ),
        CustomContainer(
          margin: EdgeInsets.zero,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tr('dataSubjectRight.processCondiDDder.considerTakingAction'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: UiConfig.lineGap),
              _buildRadioOption(
                context,
                onChanged: (value) {
                  if (value != null) {
                    _onOptionChanged(value, widget.processRequest.id);
                  }
                },
              ),
              ExpandedContainer(
                expand: widget.initialProcessRequest.considerRequestStatus ==
                    RequestResultStatus.none,
                duration: const Duration(milliseconds: 400),
                child: Padding(
                  padding: const EdgeInsets.only(top: UiConfig.lineGap),
                  child: _buildSubmitButton(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildEmailNotification(
    BuildContext context, {
    required List<String> userEmails,
    required List<String> emailSelected,
    bool readOnly = false,
    bool isLoading = false,
  }) {
    final isEqual = emailSelected.length ==
            widget.initialProcessRequest.notifyEmail.length &&
        emailSelected.every((email) =>
            widget.initialProcessRequest.notifyEmail.contains(email));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('dataSubjectRight.processCondider.sendEmail'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: UiConfig.lineGap),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4.0,
                    right: UiConfig.actionSpacing,
                  ),
                  child: CustomCheckBox(
                    value: emailSelected.contains(userEmails[index]),
                    onChanged: !readOnly
                        ? (_) {
                            _onEmailSelected(userEmails[index]);
                          }
                        : null,
                    activeColor: readOnly
                        ? Theme.of(context).colorScheme.outlineVariant
                        : null,
                  ),
                ),
                Expanded(
                  child: Text(
                    userEmails[index],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            );
          },
          itemCount: userEmails.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: UiConfig.lineGap,
          ),
        ),
        if (!readOnly)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CustomButton(
                width: 65.0,
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                ),
                margin: const EdgeInsets.only(top: UiConfig.lineGap),
                onPressed: !readOnly ? _sendEmails : () {},
                backgroundColor: isEqual
                    ? Theme.of(context).colorScheme.outlineVariant
                    : null,
                child: isLoading
                    ? LoadingIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 28.0,
                        loadingType: LoadingType.horizontalRotatingDots,
                      )
                    : Text(
                        tr('dataSubjectRight.processCondider.confirm'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
              ),
            ],
          ),
      ],
    );
  }

  Column _buildRadioOption(
    BuildContext context, {
    Function(RequestResultStatus? value)? onChanged,
  }) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomRadioButton<RequestResultStatus>(
              value: RequestResultStatus.pass,
              selected: widget.processRequest.considerRequestStatus,
              onChanged: widget.initialProcessRequest.considerRequestStatus ==
                      RequestResultStatus.none
                  ? onChanged
                  : null,
              activeColor: widget.initialProcessRequest.considerRequestStatus !=
                      RequestResultStatus.none
                  ? Theme.of(context).colorScheme.outlineVariant
                  : null,
              margin: const EdgeInsets.only(right: UiConfig.actionSpacing),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  tr('dataSubjectRight.processCondider.carryOut'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomRadioButton<RequestResultStatus>(
              value: RequestResultStatus.fail,
              selected: widget.processRequest.considerRequestStatus,
              onChanged: widget.initialProcessRequest.considerRequestStatus ==
                      RequestResultStatus.none
                  ? onChanged
                  : null,
              activeColor: widget.initialProcessRequest.considerRequestStatus !=
                      RequestResultStatus.none
                  ? Theme.of(context).colorScheme.outlineVariant
                  : null,
              margin: const EdgeInsets.only(right: UiConfig.actionSpacing),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tr('dataSubjectRight.processCondider.list'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    ExpandedContainer(
                      expand: widget.processRequest.considerRequestStatus ==
                          RequestResultStatus.fail,
                      duration: const Duration(milliseconds: 400),
                      child: Form(
                        key: _considerFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: UiConfig.lineGap),
                            BlocBuilder<ProcessDataSubjectRightCubit,
                                ProcessDataSubjectRightState>(
                              builder: (context, state) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: UiConfig.lineSpacing,
                                  ),
                                  child: _buildRejectTypeSelection(
                                    context,
                                    initialRejectTypes: state.rejectTypes,
                                  ),
                                );
                              },
                            ),
                            TitleRequiredText(
                              text:
                                  tr('dataSubjectRight.processCondider.reason'),
                              required: widget.initialProcessRequest
                                      .considerRequestStatus ==
                                  RequestResultStatus.none,
                            ),
                            CustomTextField(
                              initialValue:
                                  widget.processRequest.rejectConsiderReason,
                              hintText:
                                  tr('dataSubjectRight.processCondider.since'),
                              maxLines: 5,
                              onChanged: (value) {
                                _onRejectReasonChanged(value);
                              },
                              readOnly: widget.initialProcessRequest
                                      .considerRequestStatus !=
                                  RequestResultStatus.none,
                              required: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            const SizedBox(height: UiConfig.lineGap),
            BlocBuilder<ProcessDataSubjectRightCubit,
                ProcessDataSubjectRightState>(
              builder: (context, state) {
                return _buildWarningContainer(
                  context,
                  text: tr('dataSubjectRight.processCondider.pleaseSelect'),
                  isWarning:
                      state.considerError.contains(widget.processRequest.id),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Column _buildRejectTypeSelection(
    BuildContext context, {
    required List<RejectTypeModel> initialRejectTypes,
  }) {
    final rejectTypesSelected = UtilFunctions.filterRejectTypesByIds(
      initialRejectTypes,
      widget.processRequest.rejectTypes,
    );

    return Column(
      children: <Widget>[
        ExpandedContainer(
          expand: rejectTypesSelected.isNotEmpty,
          duration: const Duration(milliseconds: 400),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: widget.initialProcessRequest.considerRequestStatus !=
                      RequestResultStatus.fail
                  ? UiConfig.lineSpacing
                  : 0,
            ),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final rejectTypeId = rejectTypesSelected[index].id;
                final description = rejectTypesSelected[index]
                    .description
                    .firstWhere(
                      (item) =>
                          item.language == widget.currentUser.defaultLanguage,
                      orElse: () => const LocalizedModel.empty(),
                    )
                    .text;

                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: UiConfig.textSpacing,
                        ),
                        child: Text(
                          description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    if (widget.initialProcessRequest.considerRequestStatus !=
                        RequestResultStatus.fail)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: UiConfig.actionSpacing,
                        ),
                        child: CustomIconButton(
                          onPressed: () {
                            _removeRejectType(rejectTypeId);
                          },
                          icon: Ionicons.trash_outline,
                          iconSize: 18.0,
                          iconColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                  ],
                );
              },
              itemCount: rejectTypesSelected.length,
              separatorBuilder: (context, index) => Divider(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.5),
              ),
            ),
          ),
        ),
        if (widget.initialProcessRequest.considerRequestStatus !=
            RequestResultStatus.fail)
          CustomButton(
            height: 50.0,
            onPressed: () {
              showBarModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => ChooseRejectTypeModal(
                  rejectTypes: initialRejectTypes,
                  initialRejectTypes: rejectTypesSelected,
                  onChanged: (rejectTypes) {
                    final ids = rejectTypes.map((reject) => reject.id).toList();
                    _setRejectTypes(ids);
                  },
                  onUpdated: _addRejectType,
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
                  Expanded(
                    child: Text(
                      tr('dataSubjectRight.processCondider.addReasons'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),
        BlocBuilder<ProcessDataSubjectRightCubit, ProcessDataSubjectRightState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                top: widget.initialProcessRequest.considerRequestStatus !=
                        RequestResultStatus.fail
                    ? UiConfig.lineGap
                    : 0,
              ),
              child: _buildWarningContainer(
                context,
                text: tr('dataSubjectRight.processCondider.selectReject'),
                isWarning: state.rejectError,
              ),
            );
          },
        ),
      ],
    );
  }

  ExpandedContainer _buildWarningContainer(
    BuildContext context, {
    required String text,
    required bool isWarning,
  }) {
    return ExpandedContainer(
      expand: isWarning,
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          border: Border.all(
            color: Theme.of(context).colorScheme.onError,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: UiConfig.textSpacing),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Icon(
                Icons.warning_outlined,
                size: 18.0,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            const SizedBox(width: UiConfig.textSpacing),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder _buildSubmitButton(BuildContext context) {
    return BlocBuilder<ProcessDataSubjectRightCubit,
        ProcessDataSubjectRightState>(
      builder: (context, state) {
        final isLoading =
            state.loadingStatus.consideringRequest == widget.processRequest.id;

        return CustomButton(
          height: 45.0,
          onPressed: _onSubmitPressed,
          child: isLoading
              ? LoadingIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 28.0,
                  loadingType: LoadingType.horizontalRotatingDots,
                )
              : Text(
                  tr('dataSubjectRight.processCondider.submit'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
        );
      },
    );
  }
}
