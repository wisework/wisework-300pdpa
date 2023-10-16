import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';

class UtilFunctions {
  static CompanyModel getCurrentCompany(
    List<CompanyModel> companies,
    String currentCompanyId,
  ) {
    for (CompanyModel company in companies) {
      if (company.id == currentCompanyId) return company;
    }
    return CompanyModel.empty();
  }

  static List<CustomFieldModel> filterCustomFieldsByIds(
    List<CustomFieldModel> customFields,
    List<String> customFieldsIds,
  ) {
    return customFields
        .where((category) => customFieldsIds.contains(category.id))
        .toList();
  }

  static List<PurposeCategoryModel> filterPurposeCategoriesByIds(
    List<PurposeCategoryModel> purposeCategories,
    List<String> purposeCategoryIds,
  ) {
    return purposeCategories
        .where((category) => purposeCategoryIds.contains(category.id))
        .toList();
  }

  static List<PurposeModel> filterPurposeByIds(
    List<PurposeModel> purposes,
    List<String> purposeIds,
  ) {
    return purposes
        .where((category) => purposeIds.contains(category.id))
        .toList();
  }
}
