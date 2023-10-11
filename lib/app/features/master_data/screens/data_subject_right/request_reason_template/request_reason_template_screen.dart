import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class RequestReasonTemplateScreen extends StatelessWidget {
  const RequestReasonTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RequestReasonTemplateView();
  }
}

class RequestReasonTemplateView extends StatefulWidget {
  const RequestReasonTemplateView({super.key});

  @override
  State<RequestReasonTemplateView> createState() => _RequestReasonTemplateViewState();
}

class _RequestReasonTemplateViewState extends State<RequestReasonTemplateView> {
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
          tr('masterData.dsr.requestreasons.title'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              // child: ListView.builder(
              //   itemCount: purposes.length,
              //   itemBuilder: (context, index) {
              //     return _buildItemCard(
              //       context,
              //       purpose: purposes[index],
              //     );
              //   },
              // ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(MasterDataRoute.createRequestReason.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // MasterDataItemCard _buildItemCard(
  //   BuildContext context, {
  //   required PurposeModel purpose,
  // }) {
  //   const language = 'en-US';
  //   final description = purpose.description.firstWhere(
  //     (item) => item.language == language,
  //     orElse: LocalizedText.empty,
  //   );
  //   final warningDescription = purpose.warningDescription.firstWhere(
  //     (item) => item.language == language,
  //     orElse: LocalizedText.empty,
  //   );

  //   return MasterDataItemCard(
  //     title: description.text,
  //     subtitle: warningDescription.text,
  //     status: purpose.status,
  //   );
  // }
}