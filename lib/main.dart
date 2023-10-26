import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/config/config.dart';
import 'app/config/provider/global_bloc_provider.dart';
import 'app/config/router/global_router.dart';
import 'app/config/themes/pdpa_theme_data.dart';
import 'app/injection.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();

  await initLocator();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('th', 'TH')],
      path: 'lib/app/localization',
      fallbackLocale: const Locale('th', 'TH'),
      startLocale: const Locale('th', 'TH'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: GlobalBlocProvider.providers,
      child: MaterialApp.router(
        routerConfig: GlobalRouter.router,
        builder: BotToastInit(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: AppConfig.appName,
        theme: PdpaThemeData.lightThemeData,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
