part of 'app_settings_bloc.dart';

abstract class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object> get props => [];
}

class InitialAppSettingsEvent extends AppSettingsEvent {
  const InitialAppSettingsEvent({
    required this.user,
  });

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class SetDeviceLanguageEvent extends AppSettingsEvent {
  const SetDeviceLanguageEvent({
    required this.language,
    required this.user,
  });

  final String language;
  final UserModel user;

  @override
  List<Object> get props => [language];
}
