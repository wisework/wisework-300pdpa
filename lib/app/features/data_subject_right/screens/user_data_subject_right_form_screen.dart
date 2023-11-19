import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/user_data_subject_right_form/user_data_subject_right_form_bloc.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
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
  void initState() {
    super.initState();

    _getUserDataSubjectRightForm();
  }

  void _getUserDataSubjectRightForm() {
    final bloc = context.read<UserDataSubjectRightFormBloc>();
    bloc.add(GetUserDataSubjectRightFormEvent(
      companyId: widget.companyId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDataSubjectRightFormBloc,
        UserDataSubjectRightFormState>(
      listener: (context, state) {
        if (state is SubmittedUserDataSubjectRightForm) {
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
        if (state is GotUserDataSubjectRightForm) {
          return const UserDataSubjectRightView();
          // return BlocProvider<CurrentUserConsentFormCubit>(
          //   create: (context) => CurrentUserConsentFormCubit()
          //     ..initialUserConsent(state.consentForm, state.purposeCategories),
          //   child: const UserDataSubjectRightView(),
          // );
        }
        if (state is UserDataSubjectRightFormError) {
          return ErrorMessageScreen(message: state.message);
        }
        if (state is SubmittedUserDataSubjectRightForm) {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'I have collected your consent from filling out the form',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: UiConfig.lineGap),
                  Text(
                    'Data Subject Right Form',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 260.0),
                    child: CustomButton(
                      height: 40.0,
                      onPressed: () {
                        final event = GetUserDataSubjectRightFormEvent(
                          companyId: widget.companyId,
                        );
                        context.read<UserDataSubjectRightFormBloc>().add(event);
                      },
                      child: Text(
                        'Fill out the form again',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }
}

class UserDataSubjectRightView extends StatefulWidget {
  const UserDataSubjectRightView({super.key});

  @override
  State<UserDataSubjectRightView> createState() =>
      _UserDataSubjectRightViewState();
}

class _UserDataSubjectRightViewState extends State<UserDataSubjectRightView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
