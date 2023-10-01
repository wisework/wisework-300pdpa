import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

class EditPurposeCategoryScreen extends StatelessWidget {
  const EditPurposeCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditPurposeCategoryView();
  }
}

class EditPurposeCategoryView extends StatefulWidget {
  const EditPurposeCategoryView({super.key});

  @override
  State<EditPurposeCategoryView> createState() =>
      _EditPurposeCategoryViewState();
}

class _EditPurposeCategoryViewState extends State<EditPurposeCategoryView> {
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
            tr('masterData.cm.purposecategory.create'), //!
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
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
