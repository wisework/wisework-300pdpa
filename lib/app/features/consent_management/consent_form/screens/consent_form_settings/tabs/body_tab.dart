import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_settings/widgets/purpose_category_setting.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

class BodyTab extends StatelessWidget {
  const BodyTab({
    super.key,
    required this.consentForm,
    required this.purposeCategories,
  });

  final ConsentFormModel consentForm;
  final List<PurposeCategoryModel> purposeCategories;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          _buildPurposeCategorySection(context),
          const SizedBox(height: UiConfig.lineSpacing),
        ],
      ),
    );
  }

  Builder _buildPurposeCategorySection(BuildContext context) {
    final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
      purposeCategories,
      consentForm.purposeCategories,
    );

    return Builder(builder: (context) {
      if (purposeCategoryFiltered.isNotEmpty) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              itemCount: purposeCategoryFiltered.length,
              itemBuilder: (context, index) => PurposeCategorySetting(
                purposeCategory: purposeCategoryFiltered[index],
              ),
              separatorBuilder: (context, _) => const SizedBox(
                height: UiConfig.lineSpacing,
              ),
            ),
          ],
        );
      }

      return CustomContainer(
        padding: const EdgeInsets.symmetric(
          vertical: UiConfig.defaultPaddingSpacing * 2,
        ),
        child: Center(
          child: Text(
            'No purpose category added',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    });
  }
}
