import 'package:go_router/go_router.dart';
import 'package:pdpa/app/features/user/screens/edit_user_screen.dart';
import 'package:pdpa/app/features/user/screens/user_screen.dart';

class UserRoute {
  static final GoRoute user = GoRoute(
    path: '/user',
    builder: (context, _) => const UserScreen(),
  );

  static final GoRoute createUser = GoRoute(
    path: '/user/create',
    builder: (context, _) => const EditUserScreen(userId: ''),
  );

  static final GoRoute editUser = GoRoute(
    path: '/user/:id/edit',
    builder: (context, state) => EditUserScreen(
      userId: state.pathParameters['id'] ?? '',
    ),
  );

  static final List<GoRoute> routes = <GoRoute>[
    user,
    createUser,
    editUser,
  ];
}
