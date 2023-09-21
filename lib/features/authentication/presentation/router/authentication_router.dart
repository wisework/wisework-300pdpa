import 'package:go_router/go_router.dart';
import 'package:pdpa/features/authentication/presentation/screens/sign_in_screen.dart';

class AuthenticationRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/accept-invite',
        builder: (context, state) => const SignInScreen(),
      ),
    ],
  );
}
