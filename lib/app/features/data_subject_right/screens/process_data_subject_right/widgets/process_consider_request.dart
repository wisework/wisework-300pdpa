import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
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
  });

  final ProcessRequestModel processRequest;
  final ProcessRequestModel initialProcessRequest;

  @override
  State<ProcessConsiderRequest> createState() => _ProcessConsiderRequestState();
}

class _ProcessConsiderRequestState extends State<ProcessConsiderRequest> {
  final GlobalKey<FormState> _considerFormKey = GlobalKey<FormState>();

  void _onOptionChanged(RequestResultStatus value, String id) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setConsiderOption(value, id);
  }

  void _onRejectReasonChanged(String value, String id) {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.setRejectConsiderReason(value, id);
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
    cubit.submitConsiderRequest(widget.processRequest.id);
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
            processRequest: widget.processRequest,
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
    );
  }

  Column _buildRadioOption(
    BuildContext context, {
    required ProcessRequestModel processRequest,
    Function(RequestResultStatus? value)? onChanged,
  }) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomRadioButton<RequestResultStatus>(
              value: RequestResultStatus.pass,
              selected: processRequest.considerRequestStatus,
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
              selected: processRequest.considerRequestStatus,
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
                      expand: processRequest.considerRequestStatus ==
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
                              initialValue: processRequest.rejectConsiderReason,
                              hintText: 'เนื่องด้วย...',
                              maxLines: 5,
                              onChanged: (value) {
                                _onRejectReasonChanged(
                                  value,
                                  processRequest.id,
                                );
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
                  isWarning: state.considerError.contains(processRequest.id),
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
