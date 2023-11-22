import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({
    super.key,
    required this.controller,
    required this.currentPage,
  });

  final PageController controller;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomContainer(
        margin: const EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'M',
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Text(
              tr('dataSubjectRight.intro.title'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Divider(
              color:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            ),
            Text(
              tr('dataSubjectRight.intro.description'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            CustomButton(
                width: double.infinity,
                height: 50,
                onPressed: () {
                  context
                      .read<FormDataSubjectRightCubit>()
                      .nextPage(currentPage + 1);
                  controller.animateToPage(currentPage + 1,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeIn);
                },
                child: Text(
                  tr('dataSubjectRight.intro.button'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                ))
          ],
        ),
      ),
    );
  }
}
