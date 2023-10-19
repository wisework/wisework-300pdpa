import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return const SettingView();
  }
}

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
    bool isEnglish = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {

    // if (context.deviceLocale.toString() == 'en_US') {
    //   isActivated = true;
    // } else {
    //   isActivated = false;
    // }
  }
 void toggleLocale() {
    if (isEnglish) {
      EasyLocalization.of(context)?.setLocale(const Locale('th', 'TH'));
    } else {
      EasyLocalization.of(context)?.setLocale(const Locale('en', 'US'));
    }
    setState(() {
      isEnglish = !isEnglish;
    });
  }
  // void toggleLocale() {
  //   if (EasyLocalization.of(context)?.locale == Locale('en', 'US')) {
  //     EasyLocalization.of(context)?.setLocale(Locale('th', 'TH'));
  //   } else {
  //     EasyLocalization.of(context)?.setLocale(Locale('en', 'US'));
  //   }
  //   setState(() {}); // Rebuild the UI to reflect the new locale
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Ionicons.menu_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('app.features.setting'), //!
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: UiConfig.lineSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        tr('masterData.etc.active'), //!
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      CustomSwitchButton(
                        value: isEnglish,
                        onChanged: (value) {
                          toggleLocale();
                        },
                      ),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withOpacity(0.5),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }
}
