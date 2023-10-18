import 'package:flutter/material.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/shared/utils/functions.dart';

class ReorderPurposeCategory extends StatefulWidget {
  const ReorderPurposeCategory({
    super.key,
    required this.purposeCategory,
    required this.consentForm,
  });

  final List<PurposeCategoryModel> purposeCategory;
  final ConsentFormModel consentForm;

  @override
  State<ReorderPurposeCategory> createState() => _ReorderPurposeCategoryState();
}

class _ReorderPurposeCategoryState extends State<ReorderPurposeCategory> {
  @override
  Widget build(BuildContext context) {
    final List<PurposeCategoryModel> purposeCategory = widget.purposeCategory;
    final purposeFiltered = UtilFunctions.filterPurposeCategoriesByIds(
      purposeCategory,
      widget.consentForm.purposeCategories,
    );
    if (purposeCategory.isNotEmpty) {
      return ReorderableListView.builder(
          shrinkWrap: true,
          // buildDefaultDragHandles: false,
          itemBuilder: (BuildContext context, int index) {
            const language = "en-US";
            final title = purposeFiltered[index].title.firstWhere(
                  (item) => item.language == language,
                  orElse: LocalizedModel.empty,
                );
            return ListTile(
              key: Key('$index'),
              title: Text(title.text),
            );
          },
          itemCount: purposeFiltered.length,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }

              final PurposeCategoryModel item =
                  purposeCategory.removeAt(oldIndex);
              purposeCategory.insert(newIndex, item);
            });
          });
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Icon(
        Icons.format_list_bulleted,
        size: 36,
        color: Theme.of(context).colorScheme.onTertiary,
      ),
    );
  }
}
