import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/process_data_subject_right/process_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/models/process_request_loading_status.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/steps/consider_request_step.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/steps/verify_form_step.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class ProcessDataSubjectRightScreen extends StatelessWidget {
  const ProcessDataSubjectRightScreen({
    super.key,
    required this.initialDataSubjectRight,
    required this.currentUser,
    required this.userEmails,
  });

  final DataSubjectRightModel initialDataSubjectRight;
  final UserModel currentUser;
  final List<String> userEmails;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProcessDataSubjectRightCubit>(
      create: (context) => ProcessDataSubjectRightCubit(
        dataSubjectRightRepository: serviceLocator(),
        generalRepository: serviceLocator(),
      )..initialSettings(
          initialDataSubjectRight,
          currentUser,
          userEmails,
        ),
      child: const ProcessDataSubjectRightView(),
    );
  }
}

class ProcessDataSubjectRightView extends StatefulWidget {
  const ProcessDataSubjectRightView({super.key});

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

  void _goBackAndUpdate() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    if (cubit.state.dataSubjectRight != cubit.state.initialDataSubjectRight) {
      Navigator.pop(context, cubit.state.dataSubjectRight);
    } else {
      Navigator.pop(context);
    }
  }

  void _onBackStepPressed() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    cubit.onBackStepPressed();
  }

  void _onNextStepPressed() {
    final cubit = context.read<ProcessDataSubjectRightCubit>();
    final verifyFormStatus = cubit.state.dataSubjectRight.verifyFormStatus;
    final stepIndex = cubit.state.stepIndex;

    if (stepIndex == 0) {
      //? If choose reject, reject verify reason should not empty.
      if (verifyFormStatus == RequestResultStatus.fail) {
        if (!_verifyFormKey.currentState!.validate()) return;
      }

      cubit.onVerifyFormValidate(stepLength);
    } else {
      cubit.onNextStepPressed(stepLength);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: Text(
          'การดำเนินการ', //!
          style: Theme.of(context).textTheme.titleLarge,
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
                      const ConsiderRequestStep(),
                      const Text('3'),
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
                    'ย้อนกลับ',
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
                          'ถัดไป',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: currentIndex != (stepLength - 1)
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .outlineVariant),
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
