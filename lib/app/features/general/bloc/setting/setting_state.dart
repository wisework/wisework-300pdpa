part of 'setting_bloc.dart';

sealed class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {
  const SettingInitial();

  @override
  List<Object> get props => [];
}

class SettingUpdated extends SettingState {
  const SettingUpdated(
    this.user,
    this.companies,
  );
  final UserModel user;
  final List<CompanyModel> companies;

  @override
  List<Object> get props => [user, companies];
}
