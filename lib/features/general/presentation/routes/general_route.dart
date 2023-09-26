import 'package:go_router/go_router.dart';
import 'package:pdpa/features/general/presentation/screens/home_screen.dart';

class GeneralRoute {
  static final GoRoute home = GoRoute(
    path: '/',
    builder: (context, _) => const HomeScreen(),
  );

  static final List<GoRoute> routes = <GoRoute>[
    home,
  ];
}
