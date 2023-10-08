part of 'consent_form_settings_bloc.dart';

abstract class ConsentFormSettingsEvent extends Equatable {
  const ConsentFormSettingsEvent();

  @override
  List<Object> get props => [];
}

class GetConsentFormSettingsEvent extends ConsentFormSettingsEvent {
  const GetConsentFormSettingsEvent({
    required this.consentId,
    required this.companyId,
  });

  final String consentId;
  final String companyId;

  @override
  List<Object> get props => [consentId, companyId];
}
