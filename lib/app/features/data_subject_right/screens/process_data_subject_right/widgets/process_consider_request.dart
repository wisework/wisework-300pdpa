import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/email_js/process_request_params.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
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
    required this.language,
  });

  final ProcessRequestModel processRequest;
  final ProcessRequestModel initialProcessRequest;
  final List<RequestTypeModel> requestTypes;
  final String language;

  @override
  State<ProcessConsiderRequest> createState() => _ProcessConsiderRequestState();
}

class _ProcessConsiderRequestState extends State<ProcessConsiderRequest> {
  final GlobalKey<FormState> _considerFormKey = GlobalKey<FormState>();

  void _onOptionChanged(RequestResultStatus value, String id) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setConsiderOption(value, id);
  }

  void _onRejectReasonChanged(String value) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setRejectConsiderReason(value, widget.processRequest.id);
  }

  void _onEmailSelected(String email) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.selectNotifyEmail(email, widget.processRequest.id);
  }

  void _onSubmitPressed() {
    //? If consider request status of initial process request not none,
    //? exist function.
    if (widget.initialProcessRequest.considerRequestStatus !=
        RequestResultStatus.none) {
      return;
    }

    if (widget.processRequest.considerRequestStatus ==
        RequestResultStatus.fail) {
      if (!_considerFormKey.currentState!.validate()) return;
    }

    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.submitConsiderRequest(
      widget.processRequest.id,
      emailParams: _getEmailParams(),
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
        ProcessRequestStatus.notProcessed: 'ยังไม่ดำเนินการ',
        ProcessRequestStatus.inProgress: 'อยู่ระหว่างการดำเนินการ',
        ProcessRequestStatus.refused: 'ปฏิเสธการดำเนินการ',
        ProcessRequestStatus.completed: 'ดำเนินการเสร็จสิ้น',
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
        (item) => item.language == widget.language,
        orElse: () => const LocalizedModel.empty(),
      );

      final rejectReason =
          processRequest.considerRequestStatus == RequestResultStatus.fail
              ? '\nเหตุผล: ${processRequest.rejectConsiderReason}'
              : '';

      return ProcessRequestTemplateParams(
        toName: dataSubjectRight.dataRequester[0].text,
        toEmail: dataSubjectRight.dataRequester[2].text,
        dataSubjectRightId: dataSubjectRight.id,
        processRequest: description.text,
        processStatus: '${statusTexts[status]}$rejectReason',
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'พิจารณาดำเนินการ',
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
          BlocBuilder<ProcessDataSubjectRightCubit,
              ProcessDataSubjectRightState>(
            builder: (context, state) {
              return Visibility(
                visible: state.userEmails.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                  ),
                  child: _buildEmailNotification(
                    context,
                    userEmails: state.userEmails,
                    emailSelected: widget.processRequest.notifyEmail,
                    readOnly:
                        widget.initialProcessRequest.considerRequestStatus !=
                            RequestResultStatus.none,
                  ),
                ),
              );
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
                  'ดำเนินการ',
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
                      'ปฏิเสธคำขอ',
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
                            TitleRequiredText(
                              text: 'เหตุผลประกอบ',
                              required: widget.initialProcessRequest
                                      .considerRequestStatus ==
                                  RequestResultStatus.none,
                            ),
                            CustomTextField(
                              initialValue:
                                  widget.processRequest.rejectConsiderReason,
                              hintText: 'เนื่องด้วย...',
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

  ExpandedContainer _buildWarningContainer(
    BuildContext context, {
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
                'โปรดเลือกตัวเลือกเพื่อดำเนินการต่อ',
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

  Column _buildEmailNotification(
    BuildContext context, {
    required List<String> userEmails,
    required List<String> emailSelected,
    bool readOnly = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'ส่งการแจ้งเตือนทางอีเมล',
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
      ],
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
                  'ส่งผลการตรวจสอบ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
        );
      },
    );
  }
}
