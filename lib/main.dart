import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/core/widgets/language_button.dart';
import 'package:pdpa/features/auth/auth.dart';
import 'package:pdpa/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  WidgetsFlutterBinding
      .ensureInitialized(); // Needs to be called so that we can await for EasyLocalization.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('th', 'TH')],
        path:
            'lib/core/localization', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   String? lang;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//         actions: <Widget>[
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: TextButton(
//               child: Text(
//                 tr('app.changeLang'),
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () => setState(() {
//                 if (context.locale.languageCode == 'en') {
//                   context.setLocale(Locale('th', 'TH'));
//                 } else {
//                   context.setLocale(Locale('en', 'US'));
//                 }
//               }),
//             ),
//           )
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'app.description',
//               style: TextStyle(),
//             ).tr(),
//             Text(
//               'app.counter',
//               style: TextStyle(),
//             ).plural(_counter),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: tr('app.increment'),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
