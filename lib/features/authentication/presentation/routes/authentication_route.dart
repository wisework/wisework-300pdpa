import 'package:go_router/go_router.dart';
import 'package:pdpa/features/authentication/presentation/screens/accept_invite_screen.dart';
import 'package:pdpa/features/authentication/presentation/screens/sign_in_screen.dart';

class AuthenticationRoute {
  static final List<GoRoute> routes = <GoRoute>[
    signIn,
    acceptInvite,
  ];

  static final GoRoute signIn = GoRoute(
    path: '/',
    builder: (context, _) => const SignInScreen(),
  );

  static final GoRoute acceptInvite = GoRoute(
    path: '/accept-invite',
    builder: (context, _) => const AcceptInviteScreen(),
  );
}
