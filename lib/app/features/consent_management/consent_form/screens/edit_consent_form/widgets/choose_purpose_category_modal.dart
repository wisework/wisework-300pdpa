import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/user_reorder_item.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class ChoosePurposeCategoryModal extends StatefulWidget {
  const ChoosePurposeCategoryModal({
    super.key,
    required this.purposeCategories,
    required this.purposes,
    required this.initialItems,
    required this.onChanged,
  });

  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<UserReorderItem> initialItems;
  final Function(List<UserReorderItem> items) onChanged;

  @override
  State<ChoosePurposeCategoryModal> createState() =>
      _ChoosePurposeCategoryModalState();
}

class _ChoosePurposeCategoryModalState
    extends State<ChoosePurposeCategoryModal> {
  late List<PurposeCategoryModel> selectPurposeCategories;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    if (widget.initialItems.isNotEmpty) {
      final ids = widget.initialItems.map((item) => item.id).toList();

      selectPurposeCategories = UtilFunctions.filterPurposeCategoriesByIds(
        widget.purposeCategories,
        ids,
      );
    } else {
      selectPurposeCategories = [];
    }
  }

  void _selectPurposeCategory(PurposeCategoryModel purposeCategory) {
    setState(() {
      if (selectPurposeCategories.contains(purposeCategory)) {
        selectPurposeCategories = selectPurposeCategories
            .where((categoryId) => categoryId != purposeCategory)
            .toList();
      } else {
        selectPurposeCategories = selectPurposeCategories
            .map((categoryId) => categoryId)
            .toList()
          ..add(purposeCategory);
      }
    });

    final items = UtilFunctions.getReorderItem(
      selectPurposeCategories.map((category) => category.id).toList(),
    );

    widget.onChanged(items);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: UiConfig.lineSpacing),
            child: _buildModalContent(context),
          ),
        ),
      ),
    );
  }

  Column _buildModalContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          elevation: 1.0,
          color: Theme.of(context).colorScheme.onBackground,
          child: Padding(
            padding: const EdgeInsets.only(
              left: UiConfig.defaultPaddingSpacing,
              right: UiConfig.defaultPaddingSpacing,
              bottom: UiConfig.lineGap,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    tr('masterData.cm.purposeCategory.purposeList'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200.0),
                  child: _buildCreatePurposeCategoryButton(context),
                ),
              ],
            ),
          ),
        ), //!
        const SizedBox(height: UiConfig.lineSpacing),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConfig.defaultPaddingSpacing,
            ),
            itemCount: widget.purposeCategories.length,
            itemBuilder: (_, index) {
              if (widget.purposeCategories.isEmpty) {
                return Text(
                  'masterData.cm.purposeCategory.noData',
                  style: Theme.of(context).textTheme.bodyMedium,
                ); //!
              }
              return Column(
                children: <Widget>[
                  _buildCheckBoxListTile(
                    context,
                    purposeCategory: widget.purposeCategories[index],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Row _buildCheckBoxListTile(
    BuildContext context, {
    required PurposeCategoryModel purposeCategory,
  }) {
    const language = 'en-US';
    final title = purposeCategory.title.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );
    final item = UtilFunctions.getReorderItemById(
      selectPurposeCategories.map((category) => category.id).toList(),
      purposeCategory.id,
    );

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            right: UiConfig.actionSpacing,
          ),
          child: CustomCheckBox(
            value: selectPurposeCategories.contains(purposeCategory),
            onChanged: (_) {
              _selectPurposeCategory(purposeCategory);
            },
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (item.id.isNotEmpty && item.priority != 0)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.only(
                        left: UiConfig.actionSpacing,
                      ),
                      child: Text(
                        item.priority.toString(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreatePurposeCategoryButton(BuildContext context) {
    return MaterialInkWell(
      onTap: () async {
        context.push(MasterDataRoute.createPurposeCategoryByConsent.path);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Icon(
                Ionicons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: UiConfig.actionSpacing),
            Expanded(
              child: Text(
                tr('masterData.cm.purposeCategory.addnewPurpose'), //!
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
