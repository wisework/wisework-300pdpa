import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/config/provider/theme_provider.dart';
import 'package:pdpa/app/config/themes/pdpa_theme_data.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
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
                'app.features.generalSetting',
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
}
