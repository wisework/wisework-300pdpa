import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class ConsideringStep extends StatefulWidget {
  const ConsideringStep({super.key});

  @override
  State<ConsideringStep> createState() => _ConsideringStepState();
}

class _ConsideringStepState extends State<ConsideringStep> {
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
          'ผลการตรวจสอบแบบฟอร์มคำขอใช้สิทธิ์ตามกฎหมายคุ้มครองข้อมูลส่วนบุคคล',
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
                      'ปฏิเสธคำขอ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    ExpandedContainer(
                      expand: isSelected == 2,
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: UiConfig.lineGap),
                          const TitleRequiredText(
                            text: 'เหตุผลประกอบ',
                            required: true,
                          ),
                          CustomTextField(
                            controller: reasonController,
                            hintText: 'เนื่องด้วย...',
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
