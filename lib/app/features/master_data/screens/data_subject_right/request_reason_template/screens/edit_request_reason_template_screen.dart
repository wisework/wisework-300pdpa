import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class EditRequestReasonTemplateScreen extends StatelessWidget {
  const EditRequestReasonTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditRequestReasonTemplateView();
  }
}

class EditRequestReasonTemplateView extends StatefulWidget {
  const EditRequestReasonTemplateView({super.key});

  @override
  State<EditRequestReasonTemplateView> createState() =>
      _EditRequestReasonTemplateViewState();
}

class _EditRequestReasonTemplateViewState
    extends State<EditRequestReasonTemplateView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Ionicons.chevron_back_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('masterData.dsr.requestreasons.create'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          CustomIconButton(
            onPressed: () {},
            icon: Ionicons.save_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: UiConfig.defaultPaddingSpacing,
              ),
              child: _buildRequestRejectForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: UiConfig.defaultPaddingSpacing,
              ),
              child: _buildChooseRejectsForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: UiConfig.defaultPaddingSpacing,
              ),
              child: _buildConfiguration(context),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildRequestRejectForm(BuildContext context) {
    return (Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              tr('masterData.dsr.requestreasons.requesttype.create'),
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 500,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Modal BottomSheet'),
                          ElevatedButton(
                            child: const Text('Close BottomSheet'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tr('masterData.dsr.requestreasons.chooserequesttype.create'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

  Column _buildChooseRejectsForm(BuildContext context) {
    return (Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              tr('masterData.dsr.requestreasons.rejecttype.create'),
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Text(
          'เพิ่มตัวเลือกการปฏิเสธที่อนุญาตในประเภทคำร้องนี้',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 500,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Modal BottomSheet'),
                          ElevatedButton(
                            child: const Text('Close BottomSheet'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tr('masterData.dsr.requestreasons.chooserejecttype.create'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

  Column _buildConfiguration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Configuration', //!
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Active', //!
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            CustomSwitchButton(
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          children: <Widget>[
            Text(
              'Update Info', //!
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'admin@gmail.com',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: UiConfig.textLineSpacing),
            Text(
              '30/09/2023 12:00:00',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: UiConfig.textLineSpacing),
          ],
        ),
      ],
    );
  }
}
