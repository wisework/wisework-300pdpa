import 'package:go_router/go_router.dart';
import 'package:pdpa/features/general/presentation/home/screens/home_screen.dart';

class HomeRoute {
  static final List<GoRoute> routes = <GoRoute>[
    home,
  ];

  static final GoRoute home = GoRoute(
    path: '/home',
    builder: (context, _) => const HomeScreen(),
  );
}
