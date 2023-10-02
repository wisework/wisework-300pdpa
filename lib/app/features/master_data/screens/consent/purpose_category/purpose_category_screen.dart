import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/master_data/widgets/master_data_item_card.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

class PurposeCategoryScreen extends StatelessWidget {
  const PurposeCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PurposeCategoryView();
  }
}

class PurposeCategoryView extends StatefulWidget {
  const PurposeCategoryView({super.key});

  @override
  State<PurposeCategoryView> createState() => _PurposeCategoryViewState();
}

class _PurposeCategoryViewState extends State<PurposeCategoryView> {
  final purposecategory = [
    PurposeCategoryModel(
        id: '1',
        title: const [
          LocalizedModel(language: 'en-US', text: 'Test1'),
          LocalizedModel(language: 'en-US', text: 'Test1'),
        ],
        description: const [
          LocalizedModel(language: 'en-US', text: 'Test1'),
          LocalizedModel(language: 'en-US', text: 'Test1'),
        ],
        purposes: const [],
        priority: 1,
        status: ActiveStatus.active,
        createdBy: '',
        createdDate: DateTime.fromMillisecondsSinceEpoch(0),
        updatedBy: '',
        updatedDate: DateTime.fromMillisecondsSinceEpoch(0)),
    PurposeCategoryModel(
        id: '2',
        title: const [
          LocalizedModel(language: 'en-US', text: 'Test2'),
          LocalizedModel(language: 'en-US', text: 'Test2'),
        ],
        description: const [
          LocalizedModel(language: 'en-US', text: 'Test2'),
          LocalizedModel(language: 'en-US', text: 'Test2'),
        ],
        purposes: const [],
        priority: 1,
        status: ActiveStatus.active,
        createdBy: '',
        createdDate: DateTime.fromMillisecondsSinceEpoch(0),
        updatedBy: '',
        updatedDate: DateTime.fromMillisecondsSinceEpoch(0)),
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
                itemCount: purposecategory.length,
                itemBuilder: (context, index) {
                  return _buildItemCard(
                    context,
                    purpose: purposecategory[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(MasterDataRoute.createPurposeCategory.path);
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
            tr('masterData.cm.purposeCategory.title'), //!
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  MasterDataItemCard _buildItemCard(
    BuildContext context, {
    required PurposeCategoryModel purpose,
  }) {
    const language = 'en-US';
    final description = purpose.description.firstWhere(
      (item) => item.language == language,
      orElse: LocalizedModel.empty,
    );
    final title = purpose.title.firstWhere(
      (item) => item.language == language,
      orElse: LocalizedModel.empty,
    );

    return MasterDataItemCard(
      title: description.text,
      subtitle: title.text,
      status: purpose.status,
      onTap: () {},
    );
  }
}
