import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/master_data/screens/consent/custom_field/custom_field_screen.dart';
import 'package:pdpa/app/features/master_data/screens/master_data_screen.dart';

class MasterDataRoute {
  static final GoRoute masterdata = GoRoute(
    path: '/masterdata',
    builder: (context, _) => MasterDataScreen(),
  );
  static final GoRoute customfield = GoRoute(
    path: '/customfield',
    builder: (context, _) => CustomFieldScreen(),
  );

  static final List<GoRoute> routes = <GoRoute>[
    masterdata,
    customfield,
  ];
}
