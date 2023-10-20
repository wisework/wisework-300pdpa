import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/consent_management/user_consent/screens/user_consent_detail/user_consert_detail_screen.dart';
import 'package:pdpa/app/features/consent_management/user_consent/screens/user_consent_screen.dart';

class UserConsentRoute {
  static final GoRoute userConsentScreen = GoRoute(
    path: '/user-consents',
    builder: (context, state) => const UserConsentScreen(),
  );

  static final GoRoute userConsentDetail = GoRoute(
    path: '/user-consents/:id/detail',
    builder: (context, state) => UserConsentDetailScreen(
      userConsentId: state.pathParameters['id'] ?? '',
    ),
  );

  static final List<GoRoute> routes = <GoRoute>[
    userConsentScreen,
    userConsentDetail
  ];
}
