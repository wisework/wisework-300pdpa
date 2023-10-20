part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class UpdateCurrentUserEvent extends SettingEvent {
  const UpdateCurrentUserEvent({
    required this.user,
    required this.companies,
  });

  final UserModel user;
  final List<CompanyModel> companies;

  @override
  List<Object> get props => [user, companies];
}

class UpdateLanguageSettingsEvent extends SettingEvent {
  const UpdateLanguageSettingsEvent({
    required this.user,
    required this.company,
  });

  final UserModel user;
  final CompanyModel company;

  @override
  List<Object> get props => [user, company];
}
