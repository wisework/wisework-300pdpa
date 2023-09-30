import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/features/authentication/bloc/invitation/invitation_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose/purpose_bloc.dart';
import 'package:pdpa/app/services/apis/authentication_api.dart';
import 'package:pdpa/app/services/apis/master_data_api.dart';
import 'package:pdpa/app/shared/drawers/bloc/drawer_bloc.dart';

import 'config/config.dart';
import 'features/authentication/bloc/sign_in/sign_in_bloc.dart';

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
    //? Repositories
    ..registerLazySingleton(
      () => MasterDataRepository(
        serviceLocator(),
      ),
    )
    //? APIs
    ..registerLazySingleton(
      () => MasterDataApi(
        serviceLocator(),
      ),
    );
}

Future<void> _other() async {
  //? App logic
  serviceLocator.registerFactory(
    () => DrawerBloc(),
  );
}
