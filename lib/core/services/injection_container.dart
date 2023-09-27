import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdpa/config/config.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/authentication/authentication_remote_data_source.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/authentication/authentication_remote_data_source_impl.dart';
import 'package:pdpa/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:pdpa/features/authentication/domain/usecases/authentication/get_current_user.dart';
import 'package:pdpa/features/authentication/domain/usecases/authentication/sign_in_with_google.dart';
import 'package:pdpa/features/authentication/domain/usecases/authentication/sign_out.dart';
import 'package:pdpa/features/authentication/domain/usecases/authentication/update_user.dart';
import 'package:pdpa/features/authentication/presentation/bloc/authentication_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator
    // External Dependencies
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(
      () => GoogleSignIn(
          clientId: AppConfig.webClientId,
          scopes: ['https://www.googleapis.com/auth/contacts.readonly']),
    );

  await _authentication();
}

Future<void> _authentication() async {
  serviceLocator
    // App Logic
    ..registerFactory(() => AuthenticationBloc(
        getCurrentUser: serviceLocator(),
        signInWithGoogle: serviceLocator(),
        signOut: serviceLocator(),
        updateUser: serviceLocator()))
    // Use cases
    ..registerLazySingleton(() => GetCurrentUser(serviceLocator()))
    ..registerLazySingleton(() => SignInWithGoogle(serviceLocator()))
    ..registerLazySingleton(() => SignOut(serviceLocator()))
    ..registerLazySingleton(() => UpdateUser(serviceLocator()))
    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl(serviceLocator()))
    // Data Sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(() =>
        AuthenticationRemoteDataSourceImpl(
            serviceLocator(), serviceLocator(), serviceLocator()));
}
