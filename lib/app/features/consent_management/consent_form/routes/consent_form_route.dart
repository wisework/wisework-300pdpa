import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_settings/consent_form_settings_screen.dart';

class ConsentFormRoute {
  static final GoRoute consentFormDetail = GoRoute(
    path: '/consent-form-detail',
  );

  static final GoRoute createConsentForm = GoRoute(
    path: '/consent-form-detail',
  );

  static final GoRoute consentFormSettings = GoRoute(
    path: '/consent-form/settings',
    builder: (context, _) => const ConsentFormSettingScreen(),
  );

  static final List<GoRoute> routes = <GoRoute>[
    // consentFormDetail,
    // createConsentForm,
    consentFormSettings,
  ];
}
