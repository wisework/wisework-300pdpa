import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/data_subject_right/screens/create_dsr/accepte_term_screen.dart';
import 'package:pdpa/app/features/data_subject_right/screens/create_dsr/condition_screen.dart';
import 'package:pdpa/app/features/data_subject_right/screens/create_dsr/data_owner_screen.dart';
import 'package:pdpa/app/features/data_subject_right/screens/create_dsr/data_requester_screen.dart';
import 'package:pdpa/app/features/data_subject_right/screens/create_dsr/identity_verification_screen.dart';
import 'package:pdpa/app/features/data_subject_right/screens/create_dsr/intro_screen.dart';
import 'package:pdpa/app/features/data_subject_right/screens/create_dsr/power_verification_screen.dart';
import 'package:pdpa/app/features/data_subject_right/screens/create_dsr/select_request_screen.dart';

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
  static final GoRoute step1 = GoRoute(
    path: '/dsr/step1',
    builder: (context, _) => const DSRStep1Screen(),
  );
  static final GoRoute step2 = GoRoute(
    path: '/dsr/step2',
    builder: (context, _) => const DSRStep2Screen(),
  );
  static final GoRoute step3 = GoRoute(
    path: '/dsr/step3',
    builder: (context, _) => const DSRStep3Screen(),
  );
  static final GoRoute step4 = GoRoute(
    path: '/dsr/step4',
    builder: (context, _) => const DSRStep4Screen(),
  );
  static final GoRoute step5 = GoRoute(
    path: '/dsr/step5',
    builder: (context, _) => const DSRStep5Screen(),
  );
  static final GoRoute step6 = GoRoute(
    path: '/dsr/step6',
    builder: (context, _) => const DSRStep6Screen(),
  );
  static final GoRoute step7 = GoRoute(
    path: '/dsr/step7',
    builder: (context, _) => const DSRStep7Screen(),
  );
  static final List<GoRoute> routes = <GoRoute>[
    dsr,
    start,
    step1,
    step2,
    step3,
    step4,
    step5,
    step6,
    step7,
  ];
}
