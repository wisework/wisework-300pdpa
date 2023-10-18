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
    builder: (context, _) => const DataSubjectRightScreen(),
  );
  static final GoRoute intro = GoRoute(
    path: '/dsr/request/intro',
    builder: (context, _) => const RequestIntroScreen(),
  );
  static final GoRoute stepOne = GoRoute(
    path: '/dsr/request/stepone',
    builder: (context, _) => const RequestDataRequesterScreen(),
  );
  static final GoRoute stepTwo = GoRoute(
    path: '/dsr/request/steptwo',
    builder: (context, _) => const RequestPowerVerificationScreen(),
  );
  static final GoRoute stepThree = GoRoute(
    path: '/dsr/request/stepthree',
    builder: (context, _) => const RequestDataOwnerScreen(),
  );
  static final GoRoute stepFour = GoRoute(
    path: '/dsr/request/stepfour',
    builder: (context, _) => const RequestIdentityVerificaiotnScreen(),
  );
  static final GoRoute stepFive = GoRoute(
    path: '/dsr/request/stepfive',
    builder: (context, _) => const RequestSelectRequestScreen(),
  );
  static final GoRoute stepSix = GoRoute(
    path: '/dsr/request/stepsix',
    builder: (context, _) => const RequestConditionScreen(),
  );
  static final GoRoute stepSeven = GoRoute(
    path: '/dsr/request/stepseven',
    builder: (context, _) => const RequestAcceptTermScreen(),
  );
  static final List<GoRoute> routes = <GoRoute>[
    dsr,
    intro,
    stepOne,
    stepTwo,
    stepThree,
    stepFour,
    stepFive,
    stepSix,
    stepSeven,
  ];
}
