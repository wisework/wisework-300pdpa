// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AppSettingsInitial()) {
    on<InitialAppSettingsEvent>(_initialAppSettingsHandler);
    on<SetDeviceLanguageEvent>(_setDeviceLanguageEvent);
  }

  final AuthenticationRepository _authenticationRepository;

  void _initialAppSettingsHandler(
    InitialAppSettingsEvent event,
    Emitter<AppSettingsState> emit,
  ) {
    emit(LoadedAppSettings(event.user.defaultLanguage));
  }

  Future<void> _setDeviceLanguageEvent(
    SetDeviceLanguageEvent event,
    Emitter<AppSettingsState> emit,
  ) async {
    final result = await _authenticationRepository.updateCurrentUser(
      event.user,
    );
    result.fold(
      (_) {},
      (user) => emit(LoadedAppSettings(event.user.defaultLanguage)),
    );
  }
}
