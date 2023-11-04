import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/general/screens/board_screen.dart';
import 'package:pdpa/app/features/general/screens/home_screen.dart';
import 'package:pdpa/app/features/general/screens/setting_screen.dart';

class GeneralRoute {
  static final GoRoute home = GoRoute(
    path: '/',
    builder: (context, _) => const HomeScreen(),
  );
   static final GoRoute setting = GoRoute(
    path: '/setting',
    builder: (context, _) => const SettingScreen(),
  );
  static final GoRoute board = GoRoute(
    path: '/board',
    builder: (context, _) => const BoardScreen(),
  );

  static final List<GoRoute> routes = <GoRoute>[
    home,
    setting,
    board
  ];
}
