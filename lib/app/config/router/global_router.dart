import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/authentication/routes/authentication_route.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/features/user/routes/user_route.dart';

class GlobalRouter {
  static final String initial = AuthenticationRoute.splash.path;

  static GoRouter get router {
    return GoRouter(
      initialLocation: initial,
      routes: [
        ...AuthenticationRoute.routes,
        ...GeneralRoute.routes,
        ...ConsentFormRoute.routes,
        ...UserConsentRoute.routes,
        ...MasterDataRoute.routes,
        ...DataSubjectRightRoute.routes,
        ...UserRoute.routes,
      ],
    );
  }
}
