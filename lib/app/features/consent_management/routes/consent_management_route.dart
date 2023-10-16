import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/consent_management/screens/consent_form/consent_form_screen.dart';
import 'package:pdpa/app/features/consent_management/screens/consent_form/screens/consent_form_detail/detail_consent_form_screen.dart';
import 'package:pdpa/app/features/consent_management/screens/consent_form/screens/edit_consent_form_screen.dart';

class ConsentManagementRoute {
  static final GoRoute consentForm = GoRoute(
    path: '/consent-management/consent-form',
    builder: (context, _) => const ConsentFormScreen(),
  );

  static final GoRoute createConsentForm = GoRoute(
    path: '/consent-management/consent-form/create',
    builder: (context, _) => const EditConsentFormScreen(cansentFormId: ''),
  );

  static final GoRoute consentFormDetail = GoRoute(
    path: '/consent-management/consent-form/:id/detail',
    builder: (context, state) => DetailConsentFormScreen(
      consentFormId: state.pathParameters['id'] ?? '',
    ),
  );

  static final GoRoute editConsentForm = GoRoute(
    path: '/consent-management/consent-form/:id/edit',
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
