import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/custom_field/custom_field_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/edit_custom_field/bloc/edit_custom_field_bloc.dart';

import 'config/config.dart';
import 'data/repositories/authentication_repository.dart';
import 'data/repositories/master_data_repository.dart';
import 'features/authentication/bloc/invitation/invitation_bloc.dart';
import 'features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'features/master_data/bloc/consent/edit_purpose/edit_purpose_bloc.dart';
import 'features/master_data/bloc/consent/purpose/purpose_bloc.dart';
import 'services/apis/authentication_api.dart';
import 'services/apis/master_data_api.dart';
import 'shared/drawers/bloc/drawer_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initLocator() async {
  serviceLocator
    //? External Dependencies
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(
      () => GoogleSignIn(
        clientId: AppConfig.webClientId,
        scopes: ['https://www.googleapis.com/auth/contacts.readonly'],
      ),
    );

  await _authentication();
  await _masterData();
  await _other();
}

Future<void> _authentication() async {
  serviceLocator
    //? App logic
    ..registerFactory(
      () => SignInBloc(
        authenticationRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => InvitationBloc(
        authenticationRepository: serviceLocator(),
      ),
    )
    //? Repositories
    ..registerLazySingleton(
      () => AuthenticationRepository(
        serviceLocator(),
      ),
    )
    //? APIs
    ..registerLazySingleton(
      () => AuthenticationApi(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
}

Future<void> _masterData() async {
  serviceLocator
    //? App logic
    ..registerFactory(
      () => PurposeBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditPurposeBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CustomFieldBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditCustomFieldBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    //? Repositories
    ..registerLazySingleton(
      () => MasterDataRepository(
        serviceLocator(),
      ),
    )
    // ..registerLazySingleton(
    //   () => UserRepository(
    //     serviceLocator(),
    //   ),
    // )
    //? APIs
    ..registerLazySingleton(
      () => MasterDataApi(
        serviceLocator(),
      ),
    );
  // ..registerLazySingleton(
  //   () => UserApi(
  //     serviceLocator(),
  //   ),
  // );
}

Future<void> _other() async {
  //? App logic
  serviceLocator.registerFactory(
    () => DrawerBloc(),
  );
}
