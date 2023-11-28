import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

class SubmitScreen extends StatelessWidget {
  const SubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            margin: const EdgeInsets.all(UiConfig.lineSpacing),
            constraints: const BoxConstraints(maxWidth: 500.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  tr("dataSubjectRight.submit.submitted"),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: UiConfig.lineGap),
                Text(
                  tr("dataSubjectRight.submit.notify"),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: UiConfig.lineGap),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 260.0),
                      child: CustomButton(
                        height: 40.0,
                        onPressed: () {
                          final RequestFormState requestFormState = context
                              .read<FormDataSubjectRightCubit>()
                              .state
                              .requestFormState;

                          if (requestFormState == RequestFormState.summarize) {
                            context
                                .read<FormDataSubjectRightCubit>()
                                .resetFormDataSubjectRight();
                          }
                        },
                        child: Text(
                          tr('userSubjectRight.fillAgain'),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }
}
