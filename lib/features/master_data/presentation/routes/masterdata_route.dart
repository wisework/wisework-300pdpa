import 'package:go_router/go_router.dart';
import 'package:pdpa/features/master_data/presentation/presentation.dart';

class MasterDataRoute {
  static final List<GoRoute> routes = <GoRoute>[
    masterdata,
  ];

  static final GoRoute masterdata = GoRoute(
    path: '/masterdata',
    builder: (context, _) => const MasterDataScreen(),
  );
}
