import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/email_js/process_request_params.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/models/process_request_loading_status.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/steps/consider_request_step.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/steps/summary_request_step.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/steps/verify_form_step.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class ProcessDataSubjectRightScreen extends StatelessWidget {
  const ProcessDataSubjectRightScreen({
    super.key,
    required this.initialDataSubjectRight,
    required this.requestTypes,
    required this.reasonTypes,
    required this.rejectTypes,
    required this.processRequestSelected,
    required this.currentUser,
    required this.userEmails,
  });

  final DataSubjectRightModel initialDataSubjectRight;
  final List<RequestTypeModel> requestTypes;
  final List<ReasonTypeModel> reasonTypes;
  final List<RejectTypeModel> rejectTypes;
  final String processRequestSelected;
  final UserModel currentUser;
  final List<String> userEmails;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProcessDataSubjectRightCubit>(
      create: (context) => ProcessDataSubjectRightCubit(
        dataSubjectRightRepository: serviceLocator(),
        generalRepository: serviceLocator(),
        emailJsRepository: serviceLocator(),
      )..initialSettings(
          initialDataSubjectRight,
          processRequestSelected,
          currentUser,
          userEmails,
        ),
      child: ProcessDataSubjectRightView(
        requestTypes: requestTypes,
        reasonTypes: reasonTypes,
        rejectTypes: rejectTypes,
        language: currentUser.defaultLanguage,
      ),
    );
  }
}

class ProcessDataSubjectRightView extends StatefulWidget {
  const ProcessDataSubjectRightView({
    super.key,
    required this.requestTypes,
    required this.reasonTypes,
    required this.rejectTypes,
    required this.language,
  });

  final List<RequestTypeModel> requestTypes;
  final List<ReasonTypeModel> reasonTypes;
  final List<RejectTypeModel> rejectTypes;
  final String language;

  @override
  State<ProcessDataSubjectRightView> createState() =>
      _ProcessDataSubjectRightViewState();
}

class _ProcessDataSubjectRightViewState
    extends State<ProcessDataSubjectRightView> {
  final GlobalKey<FormState> _verifyFormKey = GlobalKey<FormState>();

  final int stepLength = 3;

  List<String> emailSelected = [];
  List<String> moreEmails = [];

  bool isButtonDisabled = false;

  void _goBackAndUpdate() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    Navigator.pop(context, cubit.state.initialDataSubjectRight);
  }

  void _onBackStepPressed() {
    if (!isButtonDisabled) {
      final cubit = context.read<ProcessDataSubjectRightCubit>();
      cubit.onBackStepPressed();

      isButtonDisabled = true;

      Timer(const Duration(seconds: 1), () {
        isButtonDisabled = false;
      });
    }
  }

  void _onNextStepPressed() {
    if (!isButtonDisabled) {
      final cubit = context.read<ProcessDataSubjectRightCubit>();
      final verifyFormStatus = cubit.state.dataSubjectRight.verifyFormStatus;
      final stepIndex = cubit.state.stepIndex;

      if (stepIndex == (stepLength - 1)) {
        context.pushReplacement(DataSubjectRightRoute.dataSubjectRight.path);
        return;
      }

      if (stepIndex == 0) {
        //? If choose reject, reject verify reason should not empty.
        if (verifyFormStatus == RequestResultStatus.fail) {
          if (!_verifyFormKey.currentState!.validate()) return;
        }

        cubit.onVerifyFormValidate(
          stepLength,
          emailParams: _getEmailParams(),
        );
      } else {
        cubit.onNextStepPressed(stepLength);
      }

      isButtonDisabled = true;

      Timer(const Duration(seconds: 1), () {
        isButtonDisabled = false;
      });
    }
  }

  ProcessRequestTemplateParams? _getEmailParams() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    final dataSubjectRight = cubit.state.dataSubjectRight;

    List<String> requests = [];
    for (ProcessRequestModel request in dataSubjectRight.processRequests) {
      final requestType = UtilFunctions.getRequestTypeById(
        widget.requestTypes,
        request.requestType,
      );
      final description = requestType.description.firstWhere(
        (item) => item.language == widget.language,
        orElse: () => const LocalizedModel.empty(),
      );

      requests.add(description.text);
    }

    final rejectReason = dataSubjectRight.rejectVerifyReason.isNotEmpty
        ? '${tr('dataSubjectRight.processDsr.reason')}: ${dataSubjectRight.rejectVerifyReason}'
        : '';

    final status = dataSubjectRight.verifyFormStatus == RequestResultStatus.pass
        ? tr('dataSubjectRight.processDsr.pass')
        : dataSubjectRight.verifyFormStatus == RequestResultStatus.fail
            ? '${tr('dataSubjectRight.processDsr.notPass')}: $rejectReason'
            : tr('dataSubjectRight.processDsr.notYetVerified');

    if (requests.isNotEmpty) {
      return ProcessRequestTemplateParams(
        toName: dataSubjectRight.dataRequester[0].text,
        toEmail: dataSubjectRight.dataRequester[2].text,
        id: dataSubjectRight.id,
        processRequest: requests.join('\n'),
        processStatus: status,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: BlocBuilder<ProcessDataSubjectRightCubit,
            ProcessDataSubjectRightState>(
          builder: (context, state) {
            return Text(
              state.stepIndex == 0
                  ? tr('dataSubjectRight.processDsr.check')
                  : state.stepIndex == 2
                      ? tr('dataSubjectRight.processDsr.summary')
                      : tr('dataSubjectRight.processDsr.operation'),
              style: Theme.of(context).textTheme.titleLarge,
            );
          },
        ),
      ),
      body: BlocBuilder<ProcessDataSubjectRightCubit,
          ProcessDataSubjectRightState>(
        builder: (context, state) {
          return Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: ContentWrapper(
                    child: [
                      VerifyFormStep(
                        formKey: _verifyFormKey,
                      ),
                      ConsiderRequestStep(
                        requestTypes: widget.requestTypes,
                        reasonTypes: widget.reasonTypes,
                        rejectTypes: widget.rejectTypes,
                        language: widget.language,
                      ),
                      SummaryRequestStep(
                        requestTypes: widget.requestTypes,
                        language: widget.language,
                      ),
                    ].elementAt(state.stepIndex),
                  ),
                ),
              ),
              ContentWrapper(
                child: Container(
                  padding: const EdgeInsets.all(
                    UiConfig.defaultPaddingSpacing,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.outline,
                        blurRadius: 1.0,
                        offset: const Offset(0, -2.0),
                      ),
                    ],
                  ),
                  child: _buildStepControl(
                    context,
                    currentIndex: state.stepIndex,
                    loadingStatus: state.loadingStatus,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Row _buildStepControl(
    BuildContext context, {
    required int currentIndex,
    required ProcessRequestLoadingStatus loadingStatus,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              CustomButton(
                onPressed: _onBackStepPressed,
                buttonType: CustomButtonType.text,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: Text(
                    tr('app.back'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: currentIndex != 0
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            '${currentIndex + 1}/$stepLength',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CustomButton(
                onPressed: _onNextStepPressed,
                buttonType: CustomButtonType.text,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: loadingStatus.verifyingForm
                      ? LoadingIndicator(
                          color: Theme.of(context).colorScheme.primary,
                          size: 18.0,
                          loadingType: LoadingType.horizontalRotatingDots,
                        )
                      : Text(
                          currentIndex != 2 ? tr('app.next') : tr('app.finish'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
