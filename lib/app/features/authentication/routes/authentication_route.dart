import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/authentication/screens/accept_invite_screen.dart';
import 'package:pdpa/app/features/authentication/screens/sign_in_screen.dart';
import 'package:pdpa/app/features/authentication/screens/sign_up_company_screen.dart';
import 'package:pdpa/app/features/authentication/screens/splash_screen.dart';

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

  static final GoRoute signUpCompany = GoRoute(
    path: '/sign-up-company',
    builder: (context, _) => const SignUpCompanyScreen(),
  );

  static final List<GoRoute> routes = <GoRoute>[
    splash,
    signIn,
    acceptInvite,
    signUpCompany,
  ];
}
