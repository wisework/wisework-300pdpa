import 'package:go_router/go_router.dart';
import 'package:pdpa/features/authentication/presentation/routes/authentication_route.dart';
import 'package:pdpa/features/general/presentation/home/routes/home_route.dart';
import 'package:pdpa/features/master_data/presentation/routes/masterdata_route.dart';

class GlobalRouter {
  static final String initial = MasterDataRoute.masterdata.path;

  static GoRouter get router {
    return GoRouter(
      initialLocation: initial,
      routes: [
        ...AuthenticationRoute.routes,
        ...HomeRoute.routes,
        ...MasterDataRoute.routes,
      ],
    );
  }
}
