part of 'edit_consent_theme_bloc.dart';

abstract class EditConsentThemeState extends Equatable {
  const EditConsentThemeState();

  @override
  List<Object> get props => [];
}

final class EditConsentThemeInitial extends EditConsentThemeState {
  const EditConsentThemeInitial();

  @override
  List<Object> get props => [];
}

final class EditConsentThemeError extends EditConsentThemeState {
  const EditConsentThemeError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

final class GettingCurrentConsentTheme extends EditConsentThemeState {
  const GettingCurrentConsentTheme();

  @override
  List<Object> get props => [];
}

final class GotCurrentConsentTheme extends EditConsentThemeState {
  const GotCurrentConsentTheme(this.consentTheme);

  final ConsentThemeModel consentTheme;

  @override
  List<Object> get props => [consentTheme];
}

final class CreatingCurrentConsentTheme extends EditConsentThemeState {
  const CreatingCurrentConsentTheme();

  @override
  List<Object> get props => [];
}

final class CreatedCurrentConsentTheme extends EditConsentThemeState {
  const CreatedCurrentConsentTheme(this.consentTheme);

  final ConsentThemeModel consentTheme;

  @override
  List<Object> get props => [consentTheme];
}

final class UpdatingCurrentConsentTheme extends EditConsentThemeState {
  const UpdatingCurrentConsentTheme();

  @override
  List<Object> get props => [];
}

final class UpdatedCurrentConsentTheme extends EditConsentThemeState {
  const UpdatedCurrentConsentTheme(this.consentTheme);

  final ConsentThemeModel consentTheme;

  @override
  List<Object> get props => [consentTheme];
}

final class DeletingCurrentConsentTheme extends EditConsentThemeState {
  const DeletingCurrentConsentTheme();

  @override
  List<Object> get props => [];
}

final class DeletedCurrentConsentTheme extends EditConsentThemeState {
  const DeletedCurrentConsentTheme(this.consentThemeId);

  final String consentThemeId;

  @override
  List<Object> get props => [consentThemeId];
}
