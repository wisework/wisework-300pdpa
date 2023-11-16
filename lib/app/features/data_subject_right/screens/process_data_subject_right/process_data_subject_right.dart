import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/steps/considering_step.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/steps/process_result_step.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/steps/processing_step.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/steps/verifying_step.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_stepper.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class ProcessDataSubjectRightScreen extends StatefulWidget {
  const ProcessDataSubjectRightScreen({
    super.key,
    required this.dataSubjectRightId,
  });

  final String dataSubjectRightId;

  @override
  State<ProcessDataSubjectRightScreen> createState() =>
      _ProcessDataSubjectRightScreenState();
}

class _ProcessDataSubjectRightScreenState
    extends State<ProcessDataSubjectRightScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return ProcessDataSubjectRightView(
      initialDataSubjectRight: DataSubjectRightModel.empty(),
      currentUser: currentUser,
    );
  }
}

class ProcessDataSubjectRightView extends StatefulWidget {
  const ProcessDataSubjectRightView({
    super.key,
    required this.initialDataSubjectRight,
    required this.currentUser,
  });

  final DataSubjectRightModel initialDataSubjectRight;
  final UserModel currentUser;

  @override
  State<ProcessDataSubjectRightView> createState() =>
      _ProcessDataSubjectRightViewState();
}

class _ProcessDataSubjectRightViewState
    extends State<ProcessDataSubjectRightView> {
  late DataSubjectRightModel dataSubjectRight;

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int stepIndex = 0;
  int progressIndex = 0;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    dataSubjectRight = widget.initialDataSubjectRight;
  }

  void _goBackAndUpdate() {
    context.pop(
      UpdatedReturn<DataSubjectRightModel>(
        object: widget.initialDataSubjectRight,
        type: UpdateType.updated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: Text(
          'Process Data Subject Right', //!
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: ContentWrapper(
          child: CustomContainer(
            margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Data Subject Right',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                CustomStepper(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  steps: _getSteps(context),
                  currentStep: stepIndex,
                  progressStep: progressIndex,
                  onStepCancel: stepIndex != 0
                      ? () {
                          if (stepIndex > 0) {
                            setState(() {
                              stepIndex -= 1;
                            });
                          }
                        }
                      : null,
                  onStepContinue: stepIndex != 3
                      ? () {
                          // if (_formKey.currentState!.validate()) {
                          if (stepIndex < _getSteps(context).length) {
                            setState(() {
                              stepIndex += 1;
                              progressIndex = stepIndex;
                            });
                          }
                          // }
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
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

  List<CustomStep> _getSteps(BuildContext context) {
    return <CustomStep>[
      CustomStep(
        title: Text(
          'ตรวจสอบคำขอ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: progressIndex >= 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        content: const VerifyingStep(),
        isActive: progressIndex >= 0,
      ),
      CustomStep(
        title: Text(
          'พิจารณาดำเนินการ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: progressIndex >= 1
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        content: const ConsideringStep(),
        isActive: progressIndex >= 1,
      ),
      CustomStep(
        title: Text(
          'ดำเนินการ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: progressIndex >= 2
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        content: const ProcessingStep(),
        isActive: progressIndex >= 2,
      ),
      CustomStep(
        title: Text(
          'ผลการดำเนินการ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: progressIndex >= 3
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        content: const ProcessResultStep(),
        isActive: progressIndex >= 3,
      ),
    ];
  }
}
