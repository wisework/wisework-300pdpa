import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/form_data_sub_ject_right/form_data_sub_ject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/form_data_subject_right.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/widgets/summit_screen.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/wise_work_shimmer.dart';

class UserDataSubjectRightFormScreen extends StatefulWidget {
  const UserDataSubjectRightFormScreen({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  State<UserDataSubjectRightFormScreen> createState() =>
      _UserDataSubjectRightFormScreenState();
}

class _UserDataSubjectRightFormScreenState
    extends State<UserDataSubjectRightFormScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FormDataSubjectRightCubit, FormDataSubjectRightState>(
      listener: (context, state) {
        if (state.requestFormState == RequestFormState.summarize) {
          BotToast.showText(
            text: tr(
                'consentManagement.consentForm.consentFormDetails.edit.submitSuccess'), //!
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
      },
      builder: (context, state) {
        if (state.requestFormState == RequestFormState.requesting) {
          return UserDataSubjectRightView(
            companyId: widget.companyId,
          );
        }

        if (state.requestFormState == RequestFormState.summarize) {
          return _buildSubmittedScreen(
            context,
            dataSubjectRight: state.dataSubjectRight,
          );
        }

        return _buildLoadingScreen(context);
      },
    );
  }

  Scaffold _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: WiseWorkShimmer(),
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Scaffold _buildSubmittedScreen(
    BuildContext context, {
    required DataSubjectRightModel dataSubjectRight,
  }) {
    return Scaffold(
      appBar: PdpaAppBar(
        title: SizedBox(
          height: 40.0,
          child: Image.asset(
            'assets/images/general/dpo_online_mini.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: const SubmitScreen(),
    );
  }
}

class UserDataSubjectRightView extends StatelessWidget {
  const UserDataSubjectRightView({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        title: SizedBox(
          height: 40.0,
          child: Image.asset(
            'assets/images/general/dpo_online_mini.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: BlocProvider<FormDataSubJectRightBloc>(
        create: (context) => serviceLocator<FormDataSubJectRightBloc>()
          ..add(
            GetFormDataSubJectRightEvent(companyId: companyId),
          ),
        child: FormDataSubjectRightView(
          companyId: companyId,
        ),
      ),
    );
  }
}
