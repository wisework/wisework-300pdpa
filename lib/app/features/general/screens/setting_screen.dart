import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/config/provider/theme_provider.dart';
import 'package:pdpa/app/config/themes/pdpa_theme_data.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/user_preferences.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
    } else {
      currentUser = UserModel.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingView(
      currentUser: currentUser,
    );
  }
}

class SettingView extends StatefulWidget {
  const SettingView({
    super.key,
    required this.currentUser,
  });

  final UserModel currentUser;

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String currentLanguage;

  @override
  void initState() {
    super.initState();

    currentLanguage = widget.currentUser.defaultLanguage;
  }

  // void _selectMenuDrawer(DrawerMenuModel menu) {
  //   context.read<DrawerBloc>().add(SelectMenuDrawerEvent(menu: menu));
  //   context.pushReplacement(menu.route.path);
  // }

  // void _setCurrentLanguage(String? value) {
  //   if (value != null && value != currentLanguage) {
  //     currentLanguage = value;

  //     final locales = value.split('-');
  //     context.setLocale(
  //       Locale(locales.first, locales.last),
  //     );

  //     // EasyLocalization.of(context)?.setLocale(
  //     //   Locale(locales.first, locales.last),
  //     // );

  //     final setDeviceLanguage = SetDeviceLanguageEvent(
  //       language: value,
  //       user: widget.currentUser.copyWith(defaultLanguage: value),
  //     );
  //     context.read<AppSettingsBloc>().add(setDeviceLanguage);
  //     _selectMenuDrawer(
  //       DrawerMenuModel(
  //         value: 'home',
  //         title: tr('app.features.home'),
  //         icon: Ionicons.home_outline,
  //         route: GeneralRoute.home,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icons.menu_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('app.features.setting'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: ContentWrapper(
          child: Column(
            children: <Widget>[
              // const SizedBox(height: UiConfig.lineSpacing),
              // _buildGeneralSection(),
              const SizedBox(height: UiConfig.lineSpacing),
              _buildThemeSwitchButton(themeProvider),
              const SizedBox(height: UiConfig.lineSpacing),
              _buildShowWhatNewButton(),
            ],
          ),
        ),
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }

  // CustomContainer _buildGeneralSection() {
  //   return CustomContainer(
  //     child: Column(
  //       children: <Widget>[
  //         const SizedBox(height: UiConfig.lineSpacing),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: <Widget>[
  //             Text(
  //               tr('app.language'),
  //               style: Theme.of(context).textTheme.bodyMedium,
  //             ),
  //             SizedBox(
  //               width: 120,
  //               child: CustomDropdownButton<String>(
  //                 colorBorder: Theme.of(context).colorScheme.onPrimary,
  //                 value: currentLanguage,
  //                 items: languages.map(
  //                   (language) {
  //                     return DropdownMenuItem(
  //                       value: language,
  //                       child: Text(
  //                         language,
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                     );
  //                   },
  //                 ).toList(),
  //                 onSelected: _setCurrentLanguage,
  //               ),
  //             ),
  //           ],
  //         ),
  //         Divider(
  //           color:
  //               Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
  //         ),
  //         const SizedBox(height: UiConfig.lineSpacing),
  //       ],
  //     ),
  //   );
  // }

  CustomContainer _buildThemeSwitchButton(ThemeProvider themeProvider) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'การตั้งค่าทั่วไป',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                tr('app.mode'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              CustomSwitchButton(
                value:
                    themeProvider.currentTheme == PdpaThemeData.darkThemeData,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
          Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  CustomContainer _buildShowWhatNewButton() {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'เกี่ยวกับแอป',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          MaterialInkWell(
            onTap: () {
              showModalBottomSheet();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: UiConfig.textLineSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "What's new",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: UiConfig.textLineSpacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "เวอร์ชัน",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    versionApp,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  void showModalBottomSheet() {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: UiConfig.maxWidthContent,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: _buildModalInfo(context),
            ),
          ),
        );
      },
    );
  }

  Container _buildModalInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        UiConfig.defaultPaddingSpacing,
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: MaterialInkWell(
              borderRadius: BorderRadius.circular(13.0),
              backgroundColor:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
              onTap: () async {
                await UserPreferences.setBool(
                  AppPreferences.isFirstLaunch,
                  false,
                ).then((_) => Navigator.of(context).pop());
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 2.0,
                  top: 1.0,
                  right: 2.0,
                  bottom: 3.0,
                ),
                child: Icon(
                  Ionicons.close_outline,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              const SizedBox(height: UiConfig.lineGap),
              Text(
                "DPO มีอะไรใหม่!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineGap * 2),
          Text(
            "อัปเดตฟีเจอร์ใหม่ ที่จะช่วยให้คุณจัดการกับเรื่องข้อมูล ส่วนบุคคลได้ครบถ้วนมากยิ่งขึ้น สะดวก มั่นใจ ถูกต้องตามกรอบของ พ.ร.บ.คุ้มครองข้อมูลส่วนบุคคล",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: UiConfig.lineGap * 2),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConfig.defaultPaddingSpacing,
            ),
            child: _buildAppMenuInfo(),
          ),
          const SizedBox(height: UiConfig.lineGap * 2),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConfig.defaultPaddingSpacing,
            ),
            child: CustomButton(
              height: 45.0,
              onPressed: () {
                context.push(GeneralRoute.board.path);
              },
              child: Text(
                tr('app.disvover.seewhatnew'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
          const SizedBox(height: UiConfig.lineGap * 2),
        ],
      ),
    );
  }

  Column _buildAppMenuInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: UiConfig.defaultPaddingSpacing,
                bottom: 4.0,
              ),
              child: Icon(
                Ionicons.shield_checkmark_outline,
                size: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              "จัดการคำร้องขอใช้สิทธิ์",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: UiConfig.defaultPaddingSpacing,
                bottom: 4.0,
              ),
              child: Icon(
                Ionicons.moon_outline,
                size: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              "โหมดกลางคืน",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
