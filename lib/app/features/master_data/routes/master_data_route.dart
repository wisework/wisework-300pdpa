import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/master_data/screens/consent/custom_field/custom_field_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/custom_field/screens/edit_custom_field_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose_category/purpose_category_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose_category/screens/edit_purpose_category_screen.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/data_subject_right.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/reason_type/screens/edit_reason_type_screen.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/reject_type/screens/edit_reject_type_screen.dart';
import 'package:pdpa/app/features/master_data/screens/data_subject_right/request_type/screens/edit_request_type_screen.dart';
import 'package:pdpa/app/features/master_data/screens/mandatory/mandatory_field_screen.dart';
import 'package:pdpa/app/features/master_data/screens/master_data_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose/purpose_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose/edit_purpose_screen.dart';

class MasterDataRoute {
  static final GoRoute masterData = GoRoute(
    path: '/master-data',
    builder: (context, _) => MasterDataScreen(),
  );

  //? Mandatory Field
  static final GoRoute mandatoryFields = GoRoute(
    path: '/master-data/mandatory-fields',
    builder: (context, _) => const MandatoryFieldScreen(),
  );

  //? Custom Field
  static final GoRoute customFields = GoRoute(
    path: '/master-data/custom-fields',
    builder: (context, _) => const CustomFieldScreen(),
  );

  static final GoRoute createCustomField = GoRoute(
    path: '/master-data/custom-field/create',
    builder: (context, _) => const EditCustomFieldScreen(
      customfieldId: '',
    ),
  );

  static final GoRoute editCustomField = GoRoute(
    path: '/master-data/custom-fields/:id/edit',
    builder: (context, state) => EditCustomFieldScreen(
      customfieldId: state.pathParameters['id'] ?? '',
    ),
  );

  //? Purpose
  static final GoRoute purposes = GoRoute(
    path: '/master-data/purposes',
    builder: (context, _) => const PurposeScreen(),
  );

  static final GoRoute createPurpose = GoRoute(
    path: '/master-data/purposes/create',
    builder: (context, _) => const EditPurposeScreen(purposeId: ''),
  );

  static final GoRoute editPurpose = GoRoute(
    path: '/master-data/purposes/:id/edit',
    builder: (context, state) => EditPurposeScreen(
      purposeId: state.pathParameters['id'] ?? '',
    ),
  );

  //? Purpose Category
  static final GoRoute purposesCategories = GoRoute(
    path: '/master-data/purposescategory',
    builder: (context, _) => const PurposeCategoryScreen(),
  );

  static final GoRoute createPurposeCategory = GoRoute(
    path: '/master-data/purposecategory/create',
    builder: (context, _) => const EditPurposeCategoryScreen(
      purposeCategoryId: '',
    ),
  );

  static final GoRoute editPurposeCategory = GoRoute(
    path: '/master-data/purposecategory/:id/edit',
    builder: (context, state) => EditPurposeCategoryScreen(
      purposeCategoryId: state.pathParameters['id'] ?? '',
    ),
  );

  // static final GoRoute createPurposeCategoryByConsent = GoRoute(
  //   path: '/master-data/purposecategory/create-by-consent',
  //   builder: (context, _) => const EditPurposeCategoryScreen(
  //     purposeCategoryId: '',
  //     isCreateByConsent: true,
  //   ),
  // );

  //? Reason Type
  static final GoRoute reasonType = GoRoute(
    path: '/master-data/reasontype',
    builder: (context, _) => const ReasonTypeScreen(),
  );

  static final GoRoute createReasonType = GoRoute(
    path: '/master-data/reasontype/create',
    builder: (context, _) => const EditReasonTypeScreen(
      reasonTypeId: '',
    ),
  );

  static final GoRoute editReasonType = GoRoute(
    path: '/master-data/reasontype/:id/edit',
    builder: (context, state) => EditReasonTypeScreen(
      reasonTypeId: state.pathParameters['id'] ?? '',
    ),
  );

  //? Request Type
  static final GoRoute requestType = GoRoute(
    path: '/master-data/requesttype',
    builder: (context, _) => const RequestTypeScreen(),
  );

  static final GoRoute createRequestType = GoRoute(
    path: '/master-data/requesttype/create',
    builder: (context, _) => const EditRequestTypeScreen(
      requestTypeId: '',
    ),
  );

  static final GoRoute editRequestType = GoRoute(
    path: '/master-data/requesttype/:id/edit',
    builder: (context, state) => EditRequestTypeScreen(
      requestTypeId: state.pathParameters['id'] ?? '',
    ),
  );

  //? Reject Type
  static final GoRoute rejectType = GoRoute(
    path: '/master-data/rejecttype',
    builder: (context, _) => const RejectTypeScreen(),
  );

  static final GoRoute createRejectType = GoRoute(
    path: '/master-data/rejecttype/create',
    builder: (context, _) => const EditRejectTypeScreen(
      rejectTypeId: '',
    ),
  );

  static final GoRoute editRejectType = GoRoute(
    path: '/master-data/rejecttype/:id/edit',
    builder: (context, state) => EditRejectTypeScreen(
      rejectTypeId: state.pathParameters['id'] ?? '',
    ),
  );

  static final List<GoRoute> routes = <GoRoute>[
    masterData,
    //mandatory
    mandatoryFields,
    //consent
    customFields,
    createCustomField,
    editCustomField,
    purposes,
    createPurpose,
    editPurpose,
    purposesCategories,
    createPurposeCategory,
    editPurposeCategory,
    // createPurposeCategoryByConsent,
    //dsr
    reasonType,
    createReasonType,
    editReasonType,
    requestType,
    createRequestType,
    editRequestType,
    rejectType,
    createRejectType,
    editRejectType,
  ];
}
