import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_detail/detail_consent_form_screen.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_screen.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_settings/consent_form_settings_screen.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_settings/screens/edit_consent_theme_screen.dart';

import 'package:pdpa/app/features/consent_management/consent_form/screens/edit_consent_form/edit_consent_form_screen.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/edit_consent_form/screens/choose_pupose_category_screen.dart';

import 'package:pdpa/app/features/consent_management/consent_form/screens/user_consent_form_screen.dart';

class ConsentFormRoute {
  static final GoRoute consentForm = GoRoute(
    path: '/consent-form',
    builder: (context, _) => const ConsentFormScreen(),
  );

  static final GoRoute createConsentForm = GoRoute(
    path: '/consent-form/create',
    builder: (context, _) => const EditConsentFormScreen(consentFormId: ''),
  );

  static final GoRoute consentFormDetail = GoRoute(
    path: '/consent-form/:id/detail',
    builder: (context, state) => DetailConsentFormScreen(
      consentFormId: state.pathParameters['id'] ?? '',
    ),
  );

  static final GoRoute editConsentForm = GoRoute(
    path: '/consent-form/:id/edit',
    builder: (context, state) => EditConsentFormScreen(
      consentFormId: state.pathParameters['id'] ?? '',
    ),
  );

  static final GoRoute choosePurposeCategory = GoRoute(
    path: '/consent-form/create/choose-purpose-category',
    builder: (context, _) => const ChoosePurposeCategoryScreen(),
  );

  // static final GoRoute consentFormSettings = GoRoute(
  //   path: '/consent-form/:id/settings',
  //   builder: (context, state) => ConsentFormSettingScreen(
  //     consentFormId: state.pathParameters['id'] ?? 'a3otPSo80xnoMlX4zhIA',
  //   ),
  // );

  static final GoRoute consentFormSettings = GoRoute(
    path: '/consent-form/a3otPSo80xnoMlX4zhIA/settings',
    builder: (context, state) => const ConsentFormSettingScreen(
      consentFormId: 'a3otPSo80xnoMlX4zhIA',
    ),
  );

  static final GoRoute createConsentTheme = GoRoute(
    path: '/consent-form/settings/consent-themes/create',
    builder: (context, _) => const EditConsentThemeScreen(
      consentThemeId: '',
    ),
  );

  static final GoRoute editConsentTheme = GoRoute(
    path: '/consent-form/settings/consent-themes/:id/edit',
    builder: (context, state) => EditConsentThemeScreen(
      consentThemeId: state.pathParameters['id'] ?? '',
    ),
  );

  static final GoRoute copyConsentTheme = GoRoute(
    path: '/consent-form/settings/consent-themes/:id/copy',
    builder: (context, state) => EditConsentThemeScreen(
      consentThemeId: '',
      copyConsentThemeId: state.pathParameters['id'] ?? '',
    ),
  );

  static final GoRoute userConsentForm = GoRoute(
    path: '/companies/:id1/consent-form/:id2/form',
    builder: (context, state) => UserConsentFormScreen(
      companyId: state.pathParameters['id1'] ?? '',
      consentFormId: state.pathParameters['id2'] ?? '',
    ),
  );

  static final List<GoRoute> routes = <GoRoute>[
    consentForm,
    createConsentForm,
    consentFormDetail,
    editConsentForm,
    choosePurposeCategory,
    consentFormSettings,
    createConsentTheme,
    editConsentTheme,
    copyConsentTheme,
    userConsentForm,
  ];
}
