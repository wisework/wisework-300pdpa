import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/custom_field/custom_field_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose/purpose_bloc.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/drawers/bloc/drawer_bloc.dart';
import 'package:pdpa/app/shared/drawers/drawer_menu.dart';

class GlobalBlocProvider {
  static List<BlocProvider> get providers {
    return [
      BlocProvider<SignInBloc>(
        create: (context) => serviceLocator<SignInBloc>(),
      ),
      BlocProvider<DrawerBloc>(
        create: (context) => serviceLocator<DrawerBloc>()
          ..add(SelectMenuDrawerEvent(menu: drawerMenu.first)),
      ),
      BlocProvider<PurposeBloc>(
        create: (context) => serviceLocator<PurposeBloc>(),
      ),
      BlocProvider<CustomFieldBloc>(
        create: (context) => serviceLocator<CustomFieldBloc>(),
      ),
    ];
  }
}
