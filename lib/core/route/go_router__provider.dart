import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/core/route/route_name.dart';
import 'package:pdpa/features/authentication/presentation/login.dart';
import 'package:pdpa/features/home/presentation/home_page.dart';
import 'package:pdpa/main.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey(debugLabel: 'shell');

class GoRouteProvider {
  GoRouter goRouter() {
    return GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => LoginScreen(),
          ),
          GoRoute(
            path: '/home',
            name: homeRoute,
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: '/myhome:id',
            builder: (context, state) {
              final id = state.uri.queryParameters['id'];
              final counter = state.extra; // Get "id" param from URL
              return MyHomePage(title: id!,counter: counter,);
            },
          ),
          GoRoute(
            path: '/trans',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: LoginScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // Change the opacity of the screen using a Curve based on the the animation's
                  // value
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
          // ShellRoute(
          //     navigatorKey: _shellNavigatorKey,
          //     builder: (context, state, child) {
          //       return MyApp(key: state.pageKey);
          //     },
          //     routes: [
          //       GoRoute(
          //         path: '/',
          //         name: loginRoute,
          //         pageBuilder: (context, state) {
          //           return LoginScreen();
          //         },
          //       ),
          //       GoRoute(
          //         path: '/home',
          //         name: homeRoute,
          //         pageBuilder: (context, state) {
          //           return HomeScreen(key: state.pageKey);
          //         },
          //       )
          //     ])
        ]);
  }
}

//  //? Verify that user authenticated, if not return login screen
//     final status = BlocProvider.of<AuthBloc>(context).state.status;
//     if (status != AuthenticationStatus.authenticated) {
//       switch (settings.name) {
//         case AppRoutes.splash:
//           return buildRoute(
//             const SplashScreen(),
//             settings: settings,
//           );
//         default:
//           return buildRoute(
//             const LoginScreen(),
//             settings: settings,
//           );
//       }
//     }
