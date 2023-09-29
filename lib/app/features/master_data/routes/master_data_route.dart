import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/master_data/screens/consent/custom_field/custom_field_screen.dart';
import 'package:pdpa/app/features/master_data/screens/consent/custom_field/edit_custom_field_screen.dart';
import 'package:pdpa/app/features/master_data/screens/master_data_screen.dart';
import 'package:pdpa/app/features/master_data/screens/purpose/purpose_screen.dart';
import 'package:pdpa/app/features/master_data/screens/purpose/screens/edit_purpose_screen.dart';

class MasterDataRoute {
  static final GoRoute masterdata = GoRoute(
    path: '/masterdata',
    builder: (context, _) => MasterDataScreen(),
  );
  static final GoRoute customfield = GoRoute(
    path: '/customfield',
    builder: (context, _) => const CustomFieldScreen(),
  );
  static final GoRoute editCustomfield = GoRoute(
    path: '/customfield/edit',
    builder: (context, _) => const EditCustomFieldScreen(),
  );

  static final GoRoute purpose = GoRoute(
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
  static final List<GoRoute> routes = <GoRoute>[
    masterdata,
    customfield,
    editCustomfield,
    purpose,
    createPurpose,
    editPurpose,
  ];
}
