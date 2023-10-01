import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/master_data/screens/consent/custom_field/custom_field_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/custom_field/screens/edit_custom_field_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose_category/purpose_category_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose_category/screens/edit_purpose_category_screen.dart';
import 'package:pdpa/app/features/master_data/screens/master_data_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose/purpose_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose/edit_purpose_screen.dart';

class MasterDataRoute {
  static final GoRoute masterData = GoRoute(
    path: '/master-data',
    builder: (context, _) => MasterDataScreen(),
  );

  static final GoRoute customFields = GoRoute(
    path: '/master-data/custom-fields',
    builder: (context, _) => const CustomFieldScreen(),
  );

  static final GoRoute createCustomField = GoRoute(
    path: '/master-data/custom-field/create',
    builder: (context, _) => const EditCustomFieldScreen(),
  );

  static final GoRoute editCustomField = GoRoute(
    path: '/master-data/custom-field/edit',
    builder: (context, _) => const EditCustomFieldScreen(),
  );

  static final GoRoute purposes = GoRoute(
    path: '/master-data/purposes',
    builder: (context, _) => const PurposeScreen(),
  );

  static final GoRoute createPurpose = GoRoute(
    path: '/master-data/purpose/create',
    builder: (context, _) => const EditPurposeScreen(),
  );

  static final GoRoute editPurpose = GoRoute(
    path: '/master-data/purpose/edit',
    builder: (context, _) => const EditPurposeScreen(),
  );

  static final GoRoute purposesCategory = GoRoute(
    path: '/master-data/purposescategory',
    builder: (context, _) => const PurposeCategoryScreen(),
  );

  static final GoRoute createPurposeCategory = GoRoute(
    path: '/master-data/purposecategory/create',
    builder: (context, _) => const EditPurposeCategoryScreen(),
  );

  static final GoRoute editPurposeCategory = GoRoute(
    path: '/master-data/purposecategory/edit',
    builder: (context, _) => const EditPurposeCategoryScreen(),
  );

  static final List<GoRoute> routes = <GoRoute>[
    masterData,
    customFields,
    createCustomField,
    editCustomField,
    purposes,
    createPurpose,
    editPurpose,
    purposesCategory,
    createPurposeCategory,
    editPurposeCategory
  ];
}
