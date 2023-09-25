import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/config.dart';
import 'config/firebase_options.dart';
import 'config/router/global_router.dart';
import 'config/themes/pdpa_theme_data.dart';
import 'core/services/injection_container.dart';
import 'features/authentication/presentation/bloc/authentication_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();

  await init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('th', 'TH')],
      path: 'lib/core/localization',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => serviceLocator<AuthenticationBloc>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: GlobalRouter.router,
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
/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton(
              child: Text(
                tr('app.changeLang'),
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () => setState(() {
                if (context.locale.languageCode == 'en') {
                  context.setLocale(const Locale('th', 'TH'));
                } else {
                  context.setLocale(const Locale('en', 'US'));
                }
              }),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'app.description',
              style: TextStyle(),
            ).tr(),
            const Text(
              'app.counter',
              style: TextStyle(),
            ).plural(_counter),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: tr('app.increment'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/