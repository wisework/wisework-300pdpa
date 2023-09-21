import 'package:go_router/go_router.dart';
import 'package:pdpa/features/authentication/presentation/screens/sign_in_screen.dart';

class GlobalRouter {
  static const String initial = '/sign-in';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
    ],
  );
}
