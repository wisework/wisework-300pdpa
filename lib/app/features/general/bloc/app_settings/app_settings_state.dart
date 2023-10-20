part of 'app_settings_bloc.dart';

abstract class AppSettingsState extends Equatable {
  const AppSettingsState();

  @override
  List<Object> get props => [];
}

class AppSettingsInitial extends AppSettingsState {
  const AppSettingsInitial();

  @override
  List<Object> get props => [];
}

class AppSettingsError extends AppSettingsState {
  const AppSettingsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class LoadedAppSettings extends AppSettingsState {
  const LoadedAppSettings(this.localDevice);

  final String localDevice;

  @override
  List<Object> get props => [localDevice];
}
