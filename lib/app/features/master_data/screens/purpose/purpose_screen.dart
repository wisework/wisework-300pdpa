import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/models/localized_text.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

class PurposeScreen extends StatelessWidget {
  const PurposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PurposeView();
  }
}

class PurposeView extends StatefulWidget {
  const PurposeView({super.key});

  @override
  State<PurposeView> createState() => _PurposeViewState();
}

class _PurposeViewState extends State<PurposeView> {
  final purposes = [
    PurposeModel(
      id: '1',
      description: const [
        LocalizedText(language: 'en-US', text: 'Description 1 EN'),
        LocalizedText(language: 'th-TH', text: 'Description 1 TH'),
      ],
      warningDescription: const [
        LocalizedText(language: 'en-US', text: 'WarningDescription 1 EN'),
        LocalizedText(language: 'th-TH', text: 'WarningDescription 1 TH'),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
      status: ActiveStatus.active,
      createdBy: 'Admin',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: 'Admin',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
    PurposeModel(
      id: '1',
      description: const [
        LocalizedText(language: 'en-US', text: 'Description 2 EN'),
        LocalizedText(language: 'th-TH', text: 'Description 2 TH'),
      ],
      warningDescription: const [
        LocalizedText(language: 'en-US', text: 'WarningDescription 2 EN'),
        LocalizedText(language: 'th-TH', text: 'WarningDescription 2 TH'),
      ],
      retentionPeriod: 2,
      periodUnit: 'y',
      status: ActiveStatus.active,
      createdBy: 'Admin',
      createdDate: DateTime.fromMillisecondsSinceEpoch(0),
      updatedBy: 'Admin',
      updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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
              child: ListView.builder(
                itemCount: purposes.length,
                itemBuilder: (context, index) {
                  return _buildItemCard(
                    context,
                    purpose: purposes[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(MasterDataRoute.createPurpose.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          CustomIconButton(
            onPressed: () {
              context.pop();
            },
            icon: Ionicons.chevron_back_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          const SizedBox(width: UiConfig.appBarTitleSpacing),
          Text(
            'Purpose',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required PurposeModel purpose,
  }) {
    const language = 'en-US';
    final description = purpose.description.firstWhere(
      (item) => item.language == language,
      orElse: LocalizedText.empty,
    );
    final warningDescription = purpose.warningDescription.firstWhere(
      (item) => item.language == language,
      orElse: LocalizedText.empty,
    );

    return MasterDataItemCard(
      title: description.text,
      subtitle: warningDescription.text,
      status: purpose.status,
    );
  }
}
