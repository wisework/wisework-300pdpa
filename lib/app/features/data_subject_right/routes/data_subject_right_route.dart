import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/data_subject_right/screens/create_dsr/start_screen.dart';
import 'package:pdpa/app/features/data_subject_right/screens/data_subject_right_screen.dart';

class DataSubjectRightRouter {
  static final GoRoute dsr = GoRoute(
    path: '/dsr',
    builder: (context, _) => const DSRScreen(),
  );
  static final GoRoute start = GoRoute(
    path: '/dsr/start',
    builder: (context, _) => const DSRStratScreen(),
  );
  static final List<GoRoute> routes = <GoRoute>[
    dsr,
    start,
  ];
}
