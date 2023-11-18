import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class VerifyingStep extends StatefulWidget {
  const VerifyingStep({super.key});

  @override
  State<VerifyingStep> createState() => _VerifyingStepState();
}

class _VerifyingStepState extends State<VerifyingStep> {
  late TextEditingController reasonController;

  int isSelected = 0;

  @override
  void initState() {
    super.initState();

    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    reasonController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tr('dataSubjectRight.StepProcessDsr.verifying.resultOfInspection'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomRadioButton<int>(
              value: 1,
              selected: isSelected,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    isSelected = value;
                  });
                }
              },
              margin: const EdgeInsets.only(right: UiConfig.actionSpacing),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  tr('dataSubjectRight.StepProcessDsr.verifying.pass'),
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
            CustomRadioButton<int>(
              value: 2,
              selected: isSelected,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    isSelected = value;
                  });
                }
              },
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
                      tr('dataSubjectRight.StepProcessDsr.verifying.notPass'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    ExpandedContainer(
                      expand: isSelected == 2,
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: UiConfig.lineGap),
                           TitleRequiredText(
                            text: tr('dataSubjectRight.StepProcessDsr.verifying.reason'),
                            required: true,
                          ),
                          CustomTextField(
                            controller: reasonController,
                            hintText: tr('dataSubjectRight.StepProcessDsr.verifying.since'),
                            maxLines: 5,
                            onChanged: (value) {},
                            required: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
