part of 'search_consent_form_cubit.dart';

class SearchConsentFormState extends Equatable {
  const SearchConsentFormState({
    required this.initialConsentForms,
    required this.consentForms,
  });

  final List<ConsentFormModel> initialConsentForms;
  final List<ConsentFormModel> consentForms;

  SearchConsentFormState copyWith({
    List<ConsentFormModel>? initialConsentForms,
    List<ConsentFormModel>? consentForms,
  }) {
    return SearchConsentFormState(
      initialConsentForms: initialConsentForms ?? this.initialConsentForms,
      consentForms: consentForms ?? this.consentForms,
    );
  }

  @override
  List<Object> get props => [initialConsentForms, consentForms];
}
