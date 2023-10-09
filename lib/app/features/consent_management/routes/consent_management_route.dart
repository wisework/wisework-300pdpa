import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/consent_management/screens/consent_form/consent_form_screen.dart';
import 'package:pdpa/app/features/consent_management/screens/consent_form/screens/detail_consent_form_screen.dart';
import 'package:pdpa/app/features/consent_management/screens/consent_form/screens/edit_consent_form_screen.dart';

class ConsentManagementRoute {
  static final GoRoute consentForm = GoRoute(
    path: '/consent-form',
    builder: (context, _) => const ConsentFormScreen(),
  );

  static final GoRoute createConsentForm = GoRoute(
    path: '/create-consent-form',
    builder: (context, _) => const EditConsentFormScreen(cansentFormId: ''),
  );

  static final GoRoute consentFormDetail = GoRoute(
    path: '/consent-form-detail',
    builder: (context, _) => const DetailConsentFormScreen(),
  );

  static final GoRoute editConsentForm = GoRoute(
    path: '/consent-form-edit',
    builder: (context, state) => EditConsentFormScreen(
      cansentFormId: state.pathParameters['id'] ?? '',
    ),
  );

  static final List<GoRoute> routes = <GoRoute>[
    //Consent form
    consentForm,
    createConsentForm,
    consentFormDetail,
    editConsentForm,
  ];
}
