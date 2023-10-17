import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form/consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form_detail/consent_form_detail_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/edit_consent_form/edit_consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_detail/current_consent_form_detail_cubit.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/user_consent_form/user_consent_form_bloc.dart';

import 'config/config.dart';
import 'data/repositories/authentication_repository.dart';
import 'data/repositories/consent_repository.dart';
import 'data/repositories/general_repository.dart';
import 'data/repositories/master_data_repository.dart';
import 'features/authentication/bloc/invitation/invitation_bloc.dart';
import 'features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'features/consent_management/consent_form/bloc/consent_form_settings/consent_form_settings_bloc.dart';
import 'features/consent_management/consent_form/bloc/edit_consent_theme/edit_consent_theme_bloc.dart';
import 'features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
import 'features/master_data/bloc/consent/custom_field/custom_field_bloc.dart';
import 'features/master_data/bloc/consent/edit_custom_field/bloc/edit_custom_field_bloc.dart';
import 'features/master_data/bloc/consent/edit_purpose/edit_purpose_bloc.dart';
import 'features/master_data/bloc/consent/edit_purpose_category/edit_purpose_category_bloc.dart';
import 'features/master_data/bloc/consent/purpose/purpose_bloc.dart';
import 'features/master_data/bloc/consent/purpose_category/purpose_category_bloc.dart';
import 'features/master_data/bloc/data_subject_right/edit_reason_type/edit_reason_type_bloc.dart';
import 'features/master_data/bloc/data_subject_right/edit_reject_type/edit_reject_type_bloc.dart';
import 'features/master_data/bloc/data_subject_right/edit_request_type/edit_request_type_bloc.dart';
import 'features/master_data/bloc/data_subject_right/reason_type/reason_type_bloc.dart';
import 'features/master_data/bloc/data_subject_right/reject_type/reject_type_bloc.dart';
import 'features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'services/apis/authentication_api.dart';
import 'services/apis/consent_api.dart';
import 'services/apis/general_api.dart';
import 'services/apis/master_data_api.dart';
import 'shared/drawers/bloc/drawer_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initLocator() async {
  serviceLocator
    //? External Dependencies
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(
      () => GoogleSignIn(
        clientId: AppConfig.webClientId,
        scopes: ['https://www.googleapis.com/auth/contacts.readonly'],
      ),
    );

  await _authentication();
  await _consentManagement();
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

Future<void> _consentManagement() async {
  serviceLocator
    //? App logic
    ..registerFactory(
      () => ConsentFormBloc(
        consentRepository: serviceLocator(),
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditConsentFormBloc(
        consentRepository: serviceLocator(),
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ConsentFormDetailBloc(
        consentRepository: serviceLocator(),
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentConsentFormDetailCubit(),
    )
    ..registerFactory(
      () => ConsentFormSettingsBloc(
        consentRepository: serviceLocator(),
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserConsentFormBloc(
        consentRepository: serviceLocator(),
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentConsentFormSettingsCubit(
        generalRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditConsentThemeBloc(
        consentRepository: serviceLocator(),
      ),
    )
    //? Repositories
    ..registerLazySingleton(
      () => ConsentRepository(
        serviceLocator(),
      ),
    )
    //? APIs
    ..registerLazySingleton(
      () => ConsentApi(
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
    ..registerFactory(
      () => PurposeCategoryBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditPurposeCategoryBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => RequestTypeBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditRequestTypeBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => RejectTypeBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditRejectTypeBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ReasonTypeBloc(
        masterDataRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => EditReasonTypeBloc(
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
  serviceLocator
    //? App logic
    ..registerFactory(
      () => DrawerBloc(),
    )
    //? Repositories
    ..registerLazySingleton(
      () => GeneralRepository(
        serviceLocator(),
      ),
    )
    //? APIs
    ..registerLazySingleton(
      () => GeneralApi(
        serviceLocator(),
      ),
    );
}
