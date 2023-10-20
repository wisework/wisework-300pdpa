import 'package:easy_localization/easy_localization.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/drawers/models/drawer_menu_models.dart';

final List<DrawerMenuModel> drawerMenuPreset = [
  DrawerMenuModel(
    value: 'home',
    title: tr('app.features.home'),
    icon: Ionicons.home_outline,
    route: GeneralRoute.home,
  ),
  DrawerMenuModel(
    value: 'consent_management',
    title: tr('app.features.consentmanagement'),
    icon: Ionicons.reader_outline,
    route: GeneralRoute.home,
    children: [
      DrawerMenuModel(
        value: 'consent_forms',
        title: tr('app.features.consentforms'),
        icon: Ionicons.clipboard_outline,
        route: ConsentFormRoute.consentForm,
        parent: 'consent_management',
      ),
      DrawerMenuModel(
        value: 'user_consents',
        title: tr('app.features.userconsents'),
        icon: Ionicons.people_outline,
        route: UserConsentRoute.userConsentScreen,
        parent: 'consent_management',
      ),
    ],
  ),
  DrawerMenuModel(
    value: 'data_subject_right',
    title: tr('app.features.datasubjectright'),
    icon: Ionicons.shield_checkmark_outline,
    route: DataSubjectRightRoute.dataSubjectRight,
  ),
  DrawerMenuModel(
    value: 'master_data',
    title: tr('app.features.masterdata'),
    icon: Ionicons.server_outline,
    route: MasterDataRoute.masterData,
  ),
  DrawerMenuModel(
    value: 'settings',
    title: tr('app.features.setting'),
    icon: Ionicons.settings_outline,
    route: GeneralRoute.setting,
  ),
];
