import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/expanded_card.dart';

class ChoosePurposeCategoryModal extends StatefulWidget {
  const ChoosePurposeCategoryModal({
    super.key,
    required this.initialPurposeCategory,
    required this.purposeCategories,
    required this.onChanged,
    required this.onUpdated,
    required this.language,
  });

  final String language;
  final List<PurposeCategoryModel> initialPurposeCategory;
  final List<PurposeCategoryModel> purposeCategories;
  final Function(List<PurposeCategoryModel> categories) onChanged;
  final Function(UpdatedReturn<PurposeCategoryModel> categories) onUpdated;

  @override
  State<ChoosePurposeCategoryModal> createState() =>
      _ChoosePurposeCategoryModalState();
}

class _ChoosePurposeCategoryModalState
    extends State<ChoosePurposeCategoryModal> {
  late List<PurposeCategoryModel> purposeCategories;
  late List<PurposeCategoryModel> selectPurposeCategories;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    purposeCategories =
        widget.purposeCategories.map((category) => category).toList();
    selectPurposeCategories =
        widget.initialPurposeCategory.map((category) => category).toList();
  }

  void _selectPurposeCategory(PurposeCategoryModel purposeCategory) {
    final selectIds =
        selectPurposeCategories.map((selected) => selected.id).toList();

    setState(() {
      if (selectIds.contains(purposeCategory.id)) {
        selectPurposeCategories = selectPurposeCategories
            .where((selected) => selected.id != purposeCategory.id)
            .toList();
      } else {
        selectPurposeCategories = selectPurposeCategories
            .map((selected) => selected)
            .toList()
          ..add(purposeCategory);
      }
    });

    widget.onChanged(selectPurposeCategories);
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
                    tr('masterData.cm.purposeCategory.list'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200.0),
                  child: _buildAddButton(context),
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
            itemCount: purposeCategories.length,
            itemBuilder: (_, index) {
              if (purposeCategories.isEmpty) {
                return Text(
                  'masterData.cm.purposeCategory.noData',
                  style: Theme.of(context).textTheme.bodyMedium,
                ); //!
              }
              return Column(
                children: <Widget>[
                  _buildCheckBoxListTile(
                    context,
                    purposeCategory: purposeCategories[index],
                    language: widget.language,
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

  ExpandedCard _buildCheckBoxListTile(
    BuildContext context, {
    required PurposeCategoryModel purposeCategory,
    required String language,
  }) {
    final title = purposeCategory.title.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    final selectIds =
        selectPurposeCategories.map((category) => category.id).toList();
    final priority = selectIds.indexOf(purposeCategory.id) + 1;

    return ExpandedCard(
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 4.0,
              right: UiConfig.actionSpacing,
            ),
            child: CustomCheckBox(
              value: selectIds.contains(purposeCategory.id),
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
                  if (priority > 0)
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
                          '$priority',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(
          left: UiConfig.defaultPaddingSpacing * 3,
          top: UiConfig.lineGap,
          bottom: UiConfig.lineGap,
        ),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => Text(
            purposeCategory.purposes[index].description
                .firstWhere(
                  (item) => item.language == language,
                  orElse: () => const LocalizedModel.empty(),
                )
                .text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: UiConfig.textSpacing,
            ),
            child: Divider(
              color:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          itemCount: purposeCategory.purposes.length,
        ),
      ),
    );
  }

  CustomIconButton _buildAddButton(BuildContext context) {
    return CustomIconButton(
      onPressed: () async {
        await context
            .push(MasterDataRoute.createPurposeCategory.path)
            .then((value) {
          if (value != null) {
            final updated = value as UpdatedReturn<PurposeCategoryModel>;

            purposeCategories = purposeCategories..add(updated.object);
            _selectPurposeCategory(updated.object);

            widget.onUpdated(updated);
          }
        });
      },
      icon: Ionicons.add,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
