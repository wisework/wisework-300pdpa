// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_user_consent_cubit.dart';

class SearchUserConsentState extends Equatable {
  const SearchUserConsentState({
    required this.initialUserConsents,
    required this.userConsents,
    required this.initialConsentForms,
    required this.consentForms,
    required this.initialMandatoryFields,
    required this.mandatoryFields,
  });

  final List<UserConsentModel> initialUserConsents;
  final List<UserConsentModel> userConsents;
  final List<ConsentFormModel> initialConsentForms;
  final List<ConsentFormModel> consentForms;
  final List<MandatoryFieldModel> initialMandatoryFields;
  final List<MandatoryFieldModel> mandatoryFields;

  SearchUserConsentState copyWith({
    List<UserConsentModel>? initialUserConsents,
    List<UserConsentModel>? userConsents,
    List<ConsentFormModel>? initialConsentForms,
    List<ConsentFormModel>? consentForms,
    List<MandatoryFieldModel>? initialMandatoryFields,
    List<MandatoryFieldModel>? mandatoryFields,
  }) {
    return SearchUserConsentState(
      initialUserConsents: initialUserConsents ?? this.initialUserConsents,
      userConsents: userConsents ?? this.userConsents,
      initialConsentForms: initialConsentForms ?? this.initialConsentForms,
      consentForms: consentForms ?? this.consentForms,
      initialMandatoryFields: initialMandatoryFields ?? this.initialMandatoryFields,
      mandatoryFields: mandatoryFields ?? this.mandatoryFields,
    );
  }

  @override
  List<Object> get props => [
        initialUserConsents,
        userConsents,
        initialConsentForms,
        consentForms,
        initialMandatoryFields,
        mandatoryFields,
      ];
}
