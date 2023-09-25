import 'package:go_router/go_router.dart';
import 'package:pdpa/features/authentication/presentation/screens/accept_invite_screen.dart';
import 'package:pdpa/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:pdpa/features/authentication/presentation/screens/splash_screen.dart';

class AuthenticationRoute {
  static final GoRoute splash = GoRoute(
    path: '/loading',
    builder: (context, state) => const SplashScreen(),
  );

  static final GoRoute signIn = GoRoute(
    path: '/sign-in',
    builder: (context, _) => const SignInScreen(),
  );

  static final GoRoute acceptInvite = GoRoute(
    path: '/accept-invite',
    builder: (context, _) => const AcceptInviteScreen(),
  );

  static final List<GoRoute> routes = <GoRoute>[
    splash,
    signIn,
    acceptInvite,
  ];
}
