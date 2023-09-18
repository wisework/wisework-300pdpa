import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/authentication_remote_data_source.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/authentication_remote_data_source_implementation.dart';
import 'package:pdpa/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_in_with_google.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_out.dart';
import 'package:pdpa/features/authentication/presentation/bloc/authentication_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator
    // External Dependencies
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => GoogleSignIn);

  await _authentication();
}

Future<void> _authentication() async {
  serviceLocator
    // App Logic
    ..registerFactory(() => AuthenticationBloc(
        signInWithEmailAndPassword: serviceLocator(),
        signInWithGoogle: serviceLocator(),
        signOut: serviceLocator()))
    // Use cases
    ..registerLazySingleton(() => SignInWithEmailAndPassword(serviceLocator()))
    ..registerLazySingleton(() => SignInWithGoogle(serviceLocator()))
    ..registerLazySingleton(() => SignOut(serviceLocator()))
    // Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(serviceLocator()))
    // Data Sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(() =>
        AuthenticationRemoteDataSourceImplementation(
            serviceLocator(), serviceLocator(), serviceLocator()));
}
