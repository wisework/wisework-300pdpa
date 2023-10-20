// ignore: depend_on_referenced_packages
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:pdpa/app/config/config.dart';
// import 'package:pdpa/app/data/models/authentication/user_model.dart';
// import 'package:pdpa/app/data/repositories/authentication_repository.dart';

// part 'app_settings_state.dart';

// class AppSettingsCubit extends Cubit<AppSettingsState> {
//   AppSettingsCubit({
//     required AuthenticationRepository authenticationRepository,
//   })  : _authenticationRepository = authenticationRepository,
//         super(const AppSettingsState(localDevice: AppConfig.defaultLanguage));

//   final AuthenticationRepository _authenticationRepository;

//   void setLocalDevice(UserModel user, String language) async {
//     final result = await _authenticationRepository.updateCurrentUser(user);
//     result.fold(
//       (_) {},
//       (user) => emit(state.copyWith(deviceLanguage: language)),
//     );
//   }
// }
