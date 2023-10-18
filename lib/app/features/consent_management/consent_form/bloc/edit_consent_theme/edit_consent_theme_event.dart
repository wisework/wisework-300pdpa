part of 'edit_consent_theme_bloc.dart';

abstract class EditConsentThemeEvent extends Equatable {
  const EditConsentThemeEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentConsentThemeEvent extends EditConsentThemeEvent {
  const GetCurrentConsentThemeEvent({
    required this.consentThemeId,
    required this.companyId,
  });

  final String consentThemeId;
  final String companyId;

  @override
  List<Object> get props => [consentThemeId, companyId];
}

class CreateCurrentConsentThemeEvent extends EditConsentThemeEvent {
  const CreateCurrentConsentThemeEvent({
    required this.consentTheme,
    required this.companyId,
  });

  final ConsentThemeModel consentTheme;
  final String companyId;

  @override
  List<Object> get props => [consentTheme, companyId];
}

class UpdateCurrentConsentThemeEvent extends EditConsentThemeEvent {
  const UpdateCurrentConsentThemeEvent({
    required this.consentTheme,
    required this.companyId,
  });

  final ConsentThemeModel consentTheme;
  final String companyId;

  @override
  List<Object> get props => [consentTheme, companyId];
}

class DeleteCurrentConsentThemeEvent extends EditConsentThemeEvent {
  const DeleteCurrentConsentThemeEvent({
    required this.consentThemeId,
    required this.companyId,
  });

  final String consentThemeId;
  final String companyId;

  @override
  List<Object> get props => [consentThemeId, companyId];
}
